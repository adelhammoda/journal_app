import 'dart:async';

import 'package:journal_app/services/authentication_api.dart';



class AuthenticationBLoC {
 final AuthenticationApi _authenticationApi;
  final StreamController<String?> _authenticationController = StreamController<
      String?>();

  Sink<String?> get addUser => _authenticationController.sink;

  Stream<String?> get user => _authenticationController.stream;
  final StreamController<bool> _logoutController = StreamController<bool>();

  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get  listLogoutUser =>_logoutController.stream;
 AuthenticationBLoC(this._authenticationApi){
   onAuthChanged();
 }
 void dispose(){
   _authenticationController.close();
   _logoutController.close();
 }
 void onAuthChanged(){
   _authenticationApi.getFireBaseAuth().authStateChanges().listen((user) {
     final String? uid=user!=null?user.uid:null;
     addUser.add(uid);

   });
   _logoutController.stream.listen((loggedOut) {
     if(loggedOut) {
       _signOut();
     }
   });
 }

  void _signOut(  ) {
   _authenticationApi.signOut();
  }
}