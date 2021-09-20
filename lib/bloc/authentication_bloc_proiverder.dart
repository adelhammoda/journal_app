import 'package:flutter/material.dart';
import 'package:journal_app/bloc/authentication_block.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBLoC authenticationBloc;

  AuthenticationBlocProvider(
      {Key? key, required Widget widget, required this.authenticationBloc})
      : super(key: key, child: widget);

  static AuthenticationBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>(
        aspect: AuthenticationBlocProvider)) !;
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider old) =>
      authenticationBloc != old.authenticationBloc;
}
