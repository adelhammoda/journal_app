import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: 'drawer',
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text('email.com'),
            accountName: Text(
              'name',
              style: TextStyle(color: Colors.red),
            ),
            currentAccountPicture: CircleAvatar(),
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
        ],
      ),
    );
  }
}
