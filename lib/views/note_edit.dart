import 'package:blocsqlitecrud/cubits/note_validation_cubit.dart';
import 'package:blocsqlitecrud/cubits/notes_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blocsqlitecrud/models/note.dart';
import 'package:lottie/lottie.dart';

import '../utils/NotesEditView.dart';
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

