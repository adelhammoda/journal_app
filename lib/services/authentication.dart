import 'package:firebase_core/firebase_core.dart';

import 'authentication_api.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';


class AuthenticationService implements AuthenticationApi {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> createUserWithEmailAndPassword(
      { String email = '', String password = ''}) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  @override
  Future<String> currentUserUid() async {
    User? user = await
    ? _firebaseAuth.currentUser;
    if(user!=null)
    return user.uid;
    else
    throw 'check your connection please.';
  }

  @override
  getFireBaseAuth() => _firebaseAuth;

  @override
  Future<bool> isEmailVerified() async {
    User? user = await
    ? _firebaseAuth.currentUser;
    return user==null?false:
    user
    .
    emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null
    )
      user.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      { String email = '', String password = ''}) async {
    UserCredential? user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (user.user != null)
      return user.user!.uid;
    else
      throw 'error';
  }

  @override
  Future<void> signOut() async => _firebaseAuth.signOut();

}