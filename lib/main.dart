import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/bloc/authentication_bloc_proiverder.dart';
import 'package:journal_app/bloc/authentication_block.dart';
import 'package:journal_app/bloc/home_bloc.dart';
import 'package:journal_app/bloc/home_bloc_provider.dart';
import 'package:journal_app/bloc/setting_bloc_provider.dart';
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
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasError) {
              return SettingState(
                child: _buildMaterialApp(Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
              );
            }
         else if (snapshot.data!=null) {
              return SettingState(
                child: HomeBlocProvider(child: _buildMaterialApp(MyHomePage()),
                    homeBloc: HomeBloc(DbFireStore(), AuthenticationService()),
                    uid: snapshot.data ?? ''),
              );
            }

            else
            return  SettingState(
              child:_buildMaterialApp(LogIn()),
            );
          }),
      authenticationBloc: _authenticationBloc,
    );
  }

  Widget _buildMaterialApp(Widget home) {
    return Builder(
      builder:(BuildContext context){
        return MaterialApp(
        theme: ThemeData(
          iconTheme: IconThemeData(
            color:
             SettingProvider.of(context).setting.iconColor

          ),
            textTheme: TextTheme(
              bodyText1:TextStyle(
                  color: SettingProvider.of(context).setting.textColor
              )  ,
              bodyText2: TextStyle(
                  color: SettingProvider.of(context).setting.textColor
              ) ,
              button: TextStyle(
                color: SettingProvider.of(context).setting.textColor
              ) ,
                headline6:
                TextStyle(color: Colors.lightGreen.shade800, fontSize: 15,)),
            primarySwatch: SettingProvider.of(context).setting.primarySwatch ,
            canvasColor:  SettingProvider.of(context).setting.canvasColor,
            bottomAppBarColor:  SettingProvider.of(context).setting.appBarColor
        ),
        debugShowCheckedModeBanner: false,
        home: home,
      );
      },
    );
  }

}
