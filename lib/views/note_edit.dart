import 'package:blocsqlitecrud/cubits/note_validation_cubit.dart';
import 'package:blocsqlitecrud/cubits/notes_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blocsqlitecrud/models/note.dart';
import 'package:lottie/lottie.dart';

import '../utils/note_edit_Bar.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage({Key? key, this.note}) : super(key: key);
  final Note? note;
  // o NotesCubit que foi criado e providenciado para o MaterialApp eh recuperado
  // via construtor .value, lembrando que novas instancias nao usam o .value,
  // somente as novas instancias de um cubit/bloc
  // o NoteValidationCubit eh criado e providenciado para validacao dos campos
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<NotesCubit>(context),
        ),
        BlocProvider(
          create: (context) => NoteValidationCubit(),
        ),
      ],
      child: NotesEditView(note: note),
    );
  }
}

class NotesEditView extends StatelessWidget {
  NotesEditView({
    Key? key,
    this.note,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final Note? note;

  @override
  Widget build(BuildContext context) {
    // se for edicao de uma nota existente, os campos do formulario
    // sao preenchidos com os atributos da nota
    if (note == null) {
      _titleController.text = '';
      _contentController.text = '';
    } else {
      _titleController.text = note!.title;
      _contentController.text = note!.content;
    }
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10,right: 10,top: 10),
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
                  content: Text('Operação realizada com sucesso'),
                ));
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
                  content: Text('Erro ao atualizar nota'),
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
                        width: MediaQuery.of(context).size.width * 1,
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
                    child: BlocBuilder<NoteValidationCubit, NoteValidationState>(
                      builder: (context, state) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: MediaQuery.of(context).size.width * 1,
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
                                  _titleController.text, _contentController.text);
                            },
                            onFieldSubmitted: (String value) {
                              if (_formKey.currentState!.validate()) {

                                FocusScope.of(context).unfocus();
                                context.read<NotesCubit>().salvarNota(note?.id,
                                    _titleController.text, _contentController.text);
                              }
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                padding: const EdgeInsets.only(top: 35 ),
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
                                note?.id,
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
                  Lottie.asset("assets/animation.json")],
              ),
            ),
          ),
        ),
      ),
    );
  }
}