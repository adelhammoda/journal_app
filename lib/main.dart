import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/screens/home_page.dart';
import 'package:journal_app/screens/login.dart';





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
        // Check for errors
        if (snapshot.hasError) {
          return MyApp(child: Scaffold(
            body: Center(child: Text('error'),),
          ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp(child: MyHomePage());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MyApp(child: Scaffold(
            body:Center(
              child: Text('loading'),
            )
        ));
      },
    );
  }
}


class MyApp extends StatelessWidget {
   final Widget child;
   MyApp({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
              headline6:
              TextStyle(color: Colors.lightGreen.shade800, fontSize: 15)),
          primarySwatch: Colors.lightGreen,
          canvasColor: Colors.lightGreen.shade50,
          bottomAppBarColor: Colors.lightGreen
      ),
      debugShowCheckedModeBanner: false,
      home: child,
    );
  }
}

