
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/notes_cubit.dart';
import '../views/note_list.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({Key? key}) : super(key: key);

  // o NotesCubit que foi criado e providenciado para o MaterialApp eh recuperado
  // via construtor .value e executa a funcao de buscar as notas,
  // ou seja, novas instancias nao usam o .value, instancias existentes sim
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<NotesCubit>(context)..buscarNotas(),
      child: const DocumentosView(),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final double barHeight = 50.0;
  final  button ;


  MainAppBar({Key? key, required this.title, this.button, }) : super(key: key);



  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 100.0);
  @override

  Widget build(BuildContext context) {
    double H = MediaQuery.of(context).size.height;
    double W = MediaQuery.of(context).size.width;

    return PreferredSize(
        child: ClipPath(
          clipper: WaveClip(),
          child: Container(
            color: Colors.black,
            child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      title,
                        SizedBox(width: W/10,),
                        IconButton(
                          icon: const Icon(Icons.clear_all,size: 35,color: Colors.white,),
                          onPressed: () {
                            // excluir todas as notas
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Excluir Todas as Notas'),
                                content: const Text('Confirmar operação?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar',style: TextStyle(color: Colors.red),),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<NotesCubit>().excluirNotas();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(const SnackBar(
                                          backgroundColor: Colors.black,
                                          content: Text('Notas excluídas com sucesso',style: TextStyle(color: Colors.white),),
                                        ));
                                    },
                                    child: const Text('OK',style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),],),
                    ),

                  ],
                ),

            ),
          ),

        preferredSize: Size.fromHeight(kToolbarHeight + 100));
  }
}
class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 30;
    final highPoint = size.height - 60;
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

