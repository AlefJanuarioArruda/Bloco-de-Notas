import 'package:blocsqlitecrud/cubits/notes_cubit.dart';
import 'package:blocsqlitecrud/models/note.dart';
import 'package:blocsqlitecrud/utils/note_list_Bar.dart';
import 'package:blocsqlitecrud/views/note_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class DocumentosView extends StatelessWidget {
  const DocumentosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: MainAppBar(
        title:
        const Text(
          'Frutify Annotation',
          style:
          TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white
          ),), key: null,


      ),
      body: const _Content(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          // como o FAB cria uma nota nova, a nota nao eh parametro recebido
          // na tela de edicao
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NoteEditPage(note: null)),
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotesCubit>().state;
    // a descricao dos estados esta no arquivo notes_state
    // os estados nao tratados aqui sao utilizados na tela de edicao da nota
    // print('notelist ' + state.toString());
    if (state is NotesInitial) {
      return const SizedBox();
    } else if (state is NotesLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is NotesLoaded) {
      //a mensagem abaixo aparece se a lista de notas estiver vazia
      if (state.notes!.isEmpty) {
        return const Center(
          child: Text('Não há notas. Clique no botão abaixo para Adicionar.',style: TextStyle(fontWeight: FontWeight.w800),),
        );
      } else {
        return _NotesList(state.notes);
      }
    } else {
      return const Center(
        child: Text('Erro ao recuperar notas.'),
      );
    }
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList(this.notes, {Key? key}) : super(key: key);
  final List<Note>? notes;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final note in notes!) ...[
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 5,bottom: 15),
                child: Text(note.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
              ),

              subtitle: Text(
                note.content,
              ),
              trailing: Wrap(children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit,color: Colors.blue,),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(

                          builder: (context) => NoteEditPage(note: note)),
                    );
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete,color: Colors.red,),
                    onPressed: () {
                      // excluir nota atraves do id
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Excluir Nota'),
                          content: const Text('Confirmar operação?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar',style: TextStyle(color: Colors.red),),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<NotesCubit>().excluirNota(note.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    content: Text('Nota excluída com sucesso'),
                                  ));
                              },
                              child: const Text('OK',style: TextStyle(color: Colors.blue),),
                            ),
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          ),
          // const Divider(
          //   height: 2,
          // ),
        ],
      ],
    );
  }
}
