import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../Admob/Admob.arquivo.dart';
import '../cubits/note_validation_cubit.dart';
import '../cubits/notes_cubit.dart';
import '../models/note.dart';
import 'note_edit_Bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NotesEditView extends StatefulWidget {
  NotesEditView({
    Key? key,
    this.note,
  }) : super(key: key);

  final Note? note;

  @override
  State<NotesEditView> createState() => _NotesEditViewState();
}

class _NotesEditViewState extends State<NotesEditView> {
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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _contentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // se for edicao de uma nota existente, os campos do formulario
    // sao preenchidos com os atributos da nota
    if (widget.note == null) {
      _titleController.text = '';
      _contentController.text = '';
    } else {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: BlocListener<NotesCubit, NotesState>(
          listener: (context, state) {
            // a descricao dos estados esta no arquivo notes_state e os estados
            // nao tratados aqui sao utilizados na tela de lista de notas
            // print(state.toString());
            if (state is NotesInitial) {
              const SizedBox();
            } else if (state is NotesLoading) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  });
            } else if (state is NotesSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    backgroundColor: Colors.black,
                  content: Text('Operação realizada com sucesso',style: TextStyle(color: Colors.white),
                )));
              // apos a nota ser salva, as notas sao recuperadas novamente e
              // o aplicativo apresenta novamenta a tela de lista de notas
              Navigator.pop(context);
              context.read<NotesCubit>().buscarNotas();
            } else if (state is NotesLoaded) {
              Navigator.pop(context);
            } else if (state is NotesFailure) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  backgroundColor: Colors.transparent,
                  content: Text('Erro ao atualizar nota',style: TextStyle(color: Colors.white),),
                ));
            }
          },
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  BlocBuilder<NoteValidationCubit, NoteValidationState>(
                    builder: (context, state) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 1,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.black,
                            border: InputBorder.none,

                            label: Text(
                              'Titulo',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: _contentFocusNode.requestFocus,
                          onChanged: (text) {
                            context.read<NoteValidationCubit>().validaForm(
                                _titleController.text, _contentController.text);
                          },
                          onFieldSubmitted: (String value) {},
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (state is NoteValidating) {
                              if (state.tituloMessage == '') {
                                return null;
                              } else {
                                return state.tituloMessage;
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: BlocBuilder<NoteValidationCubit,
                        NoteValidationState>(
                      builder: (context, state) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29),

                          ),
                          child: TextFormField(
                            maxLines: 6,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.multiline,

                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.black,
                              border: InputBorder.none,

                              label: Center(
                                child: Text(
                                  'Assunto',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            controller: _contentController,
                            focusNode: _contentFocusNode,

                            onChanged: (text) {
                              context.read<NoteValidationCubit>().validaForm(
                                  _titleController.text,
                                  _contentController.text);
                            },
                            onFieldSubmitted: (String value) {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                context.read<NotesCubit>().salvarNota(widget.note?.id,
                                    _titleController.text,
                                    _contentController.text);
                              }
                            },
                            autovalidateMode: AutovalidateMode
                                .onUserInteraction,
                            validator: (value) {
                              if (state is NoteValidating) {
                                if (state.conteudoMessage == '') {
                                  return null;
                                } else {
                                  return state.conteudoMessage;
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35,bottom: 35),
                    child: SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<NoteValidationCubit,
                          NoteValidationState>(
                        builder: (context, state) {
                          return MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            child: const Text(
                              'Salvar',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //fechar teclado
                                FocusScope.of(context).unfocus();
                                context.read<NotesCubit>().salvarNota(
                                    widget.note?.id,
                                    _titleController.text,
                                    _contentController.text);
                              }
                            },
                            color: Colors.white,
                            elevation: 30,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
                  ]),
                  Lottie.asset("assets/animation.json")],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

