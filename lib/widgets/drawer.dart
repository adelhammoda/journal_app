import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:journal_app/bloc/home_bloc.dart';
import 'package:journal_app/bloc/home_bloc_provider.dart';
import 'package:journal_app/bloc/setting_bloc_provider.dart';
import 'package:journal_app/screens/home_page.dart';
import 'package:journal_app/screens/settingPage.dart';
import 'package:journal_app/services/authentication.dart';
import 'package:journal_app/services/db_firestore.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: 'drawer',
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            otherAccountsPictures: [
              InkWell(
                onTap: () {
                  SettingProvider.of(context).swatchTheme();
                },
                child: Icon(
                  SettingProvider.of(context).setting.isLight
                      ? Icons.dark_mode
                      : Icons.wb_sunny,
                  color: SettingProvider.of(context).setting.isLight
                      ? Colors.yellow
                      : Colors.white,
                  size: 30,
                ),
              )
            ],
            accountEmail: Builder(
              builder: (context) {
                if (_firebaseAuth.currentUser == null ||
                    _firebaseAuth.currentUser!.email == null)
                  return Container();
                else
                  return Text(_firebaseAuth.currentUser!.email!);
              },
            ),
            accountName: Text(
              SettingProvider.of(context).setting.name,
              style: TextStyle(color: Colors.red),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: SettingProvider.of(context)
                          .setting
                          .userPhotoPath ==
                      null
                  ? null
                  : FileImage(
                      File(SettingProvider.of(context).setting.userPhotoPath!)),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTDvKskqKCJDsNXJIIsbWHrnx0wfGXnpiHOQ&usqp=CAU'),
                fit: BoxFit.fill,
              ),
              border: Border.all(color: Colors.lightGreen),
              shape: BoxShape.rectangle,
              // gradient: RadialGradient(
              //   colors: [Colors.green,Colors.lightGreen]
              // )
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                  HomeBlocProvider(child: MyHomePage(),
                      homeBloc: HomeBloc(DbFireStore(), AuthenticationService()),
                      uid: _firebaseAuth.currentUser==null?'':_firebaseAuth.currentUser!.uid),
                ),
              );
            },
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SettingPage(),
              ));
            },
            leading: Icon(Icons.home),
            title: Text('Setting'),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
          )
        ],
      ),
    );
  }
}
