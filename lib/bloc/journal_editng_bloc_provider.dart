import 'package:flutter/material.dart';
import 'package:journal_app/bloc/journal_edit_bloc.dart';


class JournalEditingBlocProvider extends InheritedWidget {
  final JournalEditBloc journalEditBloc;

  const JournalEditingBlocProvider(
      {Key? key, required Widget widget, required this.journalEditBloc})
      : super(child: widget, key: key);

  static JournalEditingBlocProvider of(BuildContext context) {
    print('${context.dependOnInheritedWidgetOfExactType(aspect: JournalEditingBlocProvider)}');
    return (context.dependOnInheritedWidgetOfExactType(aspect: JournalEditingBlocProvider)) !;
  }

  @override
  bool updateShouldNotify(JournalEditingBlocProvider oldWidget) =>
      oldWidget.journalEditBloc!=journalEditBloc;
}
