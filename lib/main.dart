import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/bloc/authentication_bloc_proiverder.dart';
import 'package:journal_app/bloc/authentication_block.dart';
import 'package:journal_app/bloc/home_bloc.dart';
import 'package:journal_app/bloc/home_bloc_provider.dart';
import 'package:journal_app/screens/home_page.dart';
import 'package:journal_app/screens/login.dart';
import 'package:journal_app/services/authentication.dart';
import 'package:journal_app/services/db_firestore.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {

        //Check for errors
        if (snapshot.hasError) {
          return Container(
              child:Center(
                child:Text('error')
              )
          );
        }

        //Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          home: Scaffold(
              body: Center(
                child:Text('Loading...')
              ),
            
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {


  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationBLoC _authenticationBloc =
    AuthenticationBLoC(AuthenticationService());
    return AuthenticationBlocProvider(
      widget: StreamBuilder<String?>(
        //TODO:add initial data from shared pref
          initialData: null,
          stream: _authenticationBloc.user,
          builder: (context, AsyncSnapshot<String?> snapshot) {
            // print('${snapshot.data} ]]]]]]]]]]]]]]]]]]]]]]]');
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasError) {
              return _buildMaterialApp(Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
            }
         else if (snapshot.data!=null) {
              return HomeBlocProvider(child: _buildMaterialApp(MyHomePage()),
                  homeBloc: HomeBloc(DbFireStore(), AuthenticationService()),
                  uid: snapshot.data ?? '');
            }

            else
            return _buildMaterialApp(LogIn());
          }),
      authenticationBloc: _authenticationBloc,
    );
  }

  MaterialApp _buildMaterialApp(Widget home) {

    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
              headline6:
              TextStyle(color: Colors.lightGreen.shade800, fontSize: 15)),
          primarySwatch: Colors.lightGreen,
          canvasColor: Colors.lightGreen.shade50,
          bottomAppBarColor: Colors.lightGreen),
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
