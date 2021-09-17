import 'dart:async';

class Validators {
  final emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (String email, sink) =>
          (email.contains('@') && email.contains('.'))
              ? sink.add(email)
              : sink.addError('error'));
  final passwordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (String password, sink) =>
          (password.length >= 6) ? sink.add(password) : sink.addError('error'));

}
