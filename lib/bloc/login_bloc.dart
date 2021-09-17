import 'dart:async';

import 'package:journal_app/classes/Validators.dart';
import 'package:journal_app/services/authentication_api.dart';

class LoginBLoc with Validators {
  final AuthenticationApi authenticationApi;
  String _email = '';
  String _password = '';
  bool _isEmailValid = false;
  bool _isPasswordValid = false;


//injection
  LoginBLoc(this.authenticationApi) {
    _startListenersIfEmailPasswordAreValid();
  }

  //email controller
  final StreamController<String> _emailController =
      StreamController<String>.broadcast();

  Sink<String> get emailChange => _emailController.sink;

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  //password controller
  final StreamController<String> _passwordController =
      StreamController<String>.broadcast();

  Sink<String> get passwordChange => _passwordController.sink;

  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);
  final StreamController<bool> _enableLoginCreateButtonController =
      StreamController<bool>.broadcast();

  Sink<bool> get enableLoginCreateButtonChanged =>
      _enableLoginCreateButtonController.sink;

  Stream<bool> get enableLoginCreateButton =>
      _enableLoginCreateButtonController.stream;
  final StreamController<String> _loginOrCreateButtonController =
      StreamController<String>();

  Sink<String> get loginOrCreateButtonChanged =>
      _loginOrCreateButtonController.sink;

  Stream<String> get loginOrCreateButton =>
      _loginOrCreateButtonController.stream;
  final StreamController<String> _loginOrCreateController =
      StreamController<String>.broadcast();

  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;

  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  void dispose() {
    _passwordController.close();
    _emailController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();

  }

  void _startListenersIfEmailPasswordAreValid() {
    email.listen((email) {
      _email = email;
      _isEmailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = '';
      _isEmailValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    password.listen((password) {
      _password = password;
      _isPasswordValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = '';
      _isPasswordValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    loginOrCreate.listen((action) {
      action == 'Login' ? _logIn() : _createAccount();
    });
  }

  void _updateEnableLoginCreateButtonStream() {

    if (_isEmailValid && _isPasswordValid) {
      enableLoginCreateButtonChanged.add(true);
    } else {
      enableLoginCreateButtonChanged.add(false);
    }
  }

  Future<String> _logIn() async {
    String result = '';
    if (_isPasswordValid && _isEmailValid) {
      await authenticationApi
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((value) {
        result = 'Success';
      }).catchError((e) {
        result = 'error';
      });
      return result;
    } else
      return 'email and password is not valid';
  }

  Future<String> _createAccount() async {
    String _result = '';
    if (_isEmailValid && _isPasswordValid) {
      await authenticationApi
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        print('Created user: $user');
        _result = 'Created user: $user';
        authenticationApi
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((user) {})
            .catchError((error) async {
          print('Login error: $error');
          _result = error;
        });
      }).catchError((error) async {
        print('Creating user error: $error');
      });
      return _result;
    } else {
      return 'Error creating user';
    }
  }
}
