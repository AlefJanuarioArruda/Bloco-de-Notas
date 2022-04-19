
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Admob/Admob.arquivo.dart';
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
class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  @override
  void initState() {

    super.initState();
    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      // adUnitId: AdHelper.nativeAdUnitId,
      request: AdRequest(),
      //size: AdSize.banner,
      // size: AdSize.mediumRectangle,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    Stack(children: [
      Column(
        children: [
          if (_isBannerAdReady)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ),
        ],
      )
    ]);
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
                      padding: const EdgeInsets.only(left: 60),
                      child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      title,
                        SizedBox(width: W/10,),
                        IconButton(
                          icon: const Icon(Icons.close,size: 30,color: Colors.white,),
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
                   // Container(width: 300,height: 50,color: Colors.white,child: Ads(),),
                    Ads(),

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

