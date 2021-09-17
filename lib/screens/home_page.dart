import 'dart:math';

import 'package:flutter/material.dart';
import 'package:journal_app/widgets.dart';
import 'package:responsive_s/responsive_s.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Responsive responsive;

  @override
  Widget build(BuildContext context) {
    responsive = new Responsive(context);
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.lightGreen.shade50,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.lightGreen.shade800,
            ),
            onPressed: () {
              // TODO: Add signOut method
            },
          ),
        ],
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(responsive.setHeight(5)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.lightGreen,
              Colors.lightGreen.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          width: 60,
        ),
        elevation: 0.0,
        title: Text('Journal app'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.lightGreen.shade50,
              Colors.lightGreen,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          height: responsive.setHeight(10),
          width: 60,
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildJournalTile(
                title: 'Title',
                state: Icons.airplanemode_active,
                subtitle: 'subtitle'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen.shade300,
        onPressed: () {},
        tooltip: 'Add Journal',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildJournalTile(
      {required String title,
      required String subtitle,
      required IconData state}) {
    Color iconColor = Colors.white;
    if (state == Icons.airplanemode_active)
      iconColor = Colors.blue;
    else if (state == Icons.add) iconColor = Colors.lightGreen;
    return ListTile(
      tileColor: Colors.grey,
      isThreeLine: true,
      leading: DefaultTextStyle(
        style: TextStyle(
          fontSize: responsive.setFont(5.5),
          fontWeight: FontWeight.w800
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('1',style: TextStyle(color: Colors.red),),
            Text('12',style: TextStyle(color:Colors.red),),
          ],
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Transform.rotate(
        child: Icon(
          state,
          color: iconColor,
          size: responsive.setFont(10),
        ),
        angle: pi * 45 / 180,
      ),
    );
  }
}
