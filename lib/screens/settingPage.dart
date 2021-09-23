import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journal_app/bloc/authentication_bloc_proiverder.dart';
import 'package:journal_app/bloc/authentication_block.dart';
import 'package:journal_app/bloc/setting_bloc_provider.dart';
import 'package:journal_app/widgets/app_bar.dart';
import 'package:journal_app/widgets/drawer.dart';
import 'package:responsive_s/responsive_s.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late AuthenticationBLoC _authenticationBloc;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _addPhotoNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
  }

  _pickedImage(ImageSource source) async {
    XFile? _pickedImage;
    _pickedImage = await _picker.pickImage(source: source);
    if (_pickedImage != null)
      SettingProvider.of(context).updatePhotoPath(_pickedImage.path);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: buildAppBar(
          context: context,
          responsive: responsive,
          onPressed: () {
            _authenticationBloc.logoutUser.add(true);
          },
          title: 'Setting'),
      body: SingleChildScrollView(
        child: Column(children: [
          Text(
            'Hello ${SettingProvider.of(context).setting.name}',
            style: TextStyle(
              color: SettingProvider.of(context).setting.iconColor,
              fontSize: responsive.setFont(10),
            ),
          ),
          SizedBox(
            height: responsive.setHeight(2),
          ),
          Padding(
            padding: EdgeInsets.all(responsive.setWidth(3)),
            child: TextField(
                controller: _controller,
                // focusNode: _nameFocusNode,
                onSubmitted: (String? name) {
                  if (name != '' && name != null)
                    SettingProvider.of(context).updateName(name);
                },
                style: TextStyle(
                    color: SettingProvider.of(context).setting.textColor),
                cursorColor: SettingProvider.of(context).setting.isLight
                    ? Colors.black
                    : Colors.white,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color:
                              SettingProvider.of(context).setting.iconColor)),
                  labelStyle: TextStyle(
                    color: SettingProvider.of(context).setting.textColor,
                  ),
                  labelText: 'Your Name',
                  hintStyle: TextStyle(
                    color: SettingProvider.of(context).setting.textColor,
                  ),
                  hintText: 'This name will used inside this app only.',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          style: BorderStyle.solid,
                          color:
                              SettingProvider.of(context).setting.textColor)),
                  icon: Icon(
                    Icons.account_circle,
                    color: SettingProvider.of(context).setting.iconColor,
                  ),
                )),
          ),
          SizedBox(
            height: responsive.setHeight(4),
          ),
          ListTile(
            focusNode: _addPhotoNode,
            title: Text(
              'Add personal photo',
              style: TextStyle(
                color: SettingProvider.of(context).setting.textColor,
              ),
            ),
            onTap: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.camera,
                              color:
                                  SettingProvider.of(context).setting.iconColor,
                            ),
                            title: Text('Camera'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await _pickedImage(ImageSource.camera);
                            },
                            focusColor:
                                SettingProvider.of(context).setting.iconColor,
                            tileColor: SettingProvider.of(context)
                                .setting
                                .iconColor
                                .withOpacity(0.5),
                          ),
                          ListTile(
                              focusColor:
                                  SettingProvider.of(context).setting.iconColor,
                              leading: Icon(
                                Icons.image,
                                color: SettingProvider.of(context)
                                    .setting
                                    .iconColor,
                              ),
                              title: Text('Gallery'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickedImage(ImageSource.gallery);
                              },
                              tileColor: SettingProvider.of(context)
                                  .setting
                                  .iconColor
                                  .withOpacity(0.5))
                        ],
                      ));
            },
            focusColor: SettingProvider.of(context).setting.iconColor,
            leading: SettingProvider.of(context).setting.userPhotoPath == null
                ? CircleAvatar()
                : CircleAvatar(
                    backgroundImage: FileImage(File(
                        SettingProvider.of(context).setting.userPhotoPath!)),
                  ),
            trailing: Icon(Icons.personal_injury),
          ),
          Divider(
            color: Color(0xfffffffe),
          ),
          ListTile(
            title: Text(
              'Login with another account',
              style: TextStyle(
                color: SettingProvider.of(context).setting.textColor,
              ),
            ),
            subtitle: Builder(
              builder: (context) {
                if (_firebaseAuth.currentUser == null ||
                    _firebaseAuth.currentUser!.email == null)
                  return Container();
                else
                  return Text(
                    _firebaseAuth.currentUser!.email!,
                    style: TextStyle(color: SettingProvider.of(context).setting.isLight?Colors.black:Color(0xfffffffe)),
                  );
              },
            ),
            onTap: () {
              _authenticationBloc.logoutUser.add(true);
            },
            focusColor: SettingProvider.of(context).setting.iconColor,
            leading: Icon(Icons.change_circle),
          )
        ]),
      ),
      drawer: MyDrawer(),
    );
  }
}
