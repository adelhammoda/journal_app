import 'package:flutter/material.dart';
import 'package:journal_app/bloc/authentication_block.dart';


class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBLoC authenticationBloc;

  AuthenticationBlocProvider(Key key, Widget widget, this.authenticationBloc)
      : super(key: key, child: widget);

  static AuthenticationBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType(
        aspect: AuthenticationBlocProvider) as AuthenticationBlocProvider);
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider old) =>
      authenticationBloc != old.authenticationBloc;
}

