import 'package:flutter/material.dart';
import 'package:journal_app/bloc/authentication_block.dart';
import 'package:journal_app/bloc/login_bloc.dart';
import 'package:journal_app/bloc/setting_bloc_provider.dart';
import 'package:journal_app/services/authentication.dart';
import 'package:responsive_s/responsive_s.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late final LoginBLoc _loginBLoc;
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _confirmPasswordNode = FocusNode();
  String realPassword = '';
  String confPassword = '';
  bool changeAuthState = false;

  @override
  void initState() {
    _loginBLoc = LoginBLoc(AuthenticationService());
    super.initState();
  }

  @override
  void dispose() {
    _loginBLoc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context,
        responsiveMethod: ResponsiveOrientationMethod.staticSize);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SettingProvider.of(context).setting.appBarColor,
        bottom: PreferredSize(
          child: Icon(
            Icons.account_circle,
            size: responsive.setWidth(30),
            color: Colors.white,
          ),
          preferredSize: Size.fromHeight(responsive.setHeight(10)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: _loginBLoc.email,
                builder: (BuildContext context, AsyncSnapshot snapShot) =>
                    TextField(
                      focusNode: _emailNode,
                      autofocus: true,
                      onSubmitted: (value) {
                        _passwordNode.requestFocus();
                      },
                      style: TextStyle(
                          color: SettingProvider.of(context).setting.textColor),
                      cursorColor: SettingProvider.of(context).setting.isLight?Colors.black:Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: SettingProvider.of(context)
                                    .setting
                                    .iconColor)),
                        labelStyle: TextStyle(
                          color: SettingProvider.of(context).setting.textColor,
                        ),
                        labelText: 'Email',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: SettingProvider.of(context)
                                    .setting
                                    .textColor)),
                        icon: Icon(
                          Icons.email_outlined,
                          color: SettingProvider.of(context).setting.iconColor,
                        ),
                        errorText: snapShot.hasError
                            ? snapShot.error.toString()
                            : null,
                      ),
                      onChanged: _loginBLoc.emailChange.add,
                    )),
            StreamBuilder(
                stream: _loginBLoc.password,
                builder: (BuildContext context, AsyncSnapshot snapShot) =>
                    TextField(
                      onSubmitted: (value) {
                        if (changeAuthState)
                          _confirmPasswordNode.requestFocus();
                        else {
                          _emailNode.unfocus();
                          _passwordNode.unfocus();
                        }
                      },
                      style: TextStyle(
                          color: SettingProvider.of(context).setting.textColor),
                      cursorColor: SettingProvider.of(context).setting.isLight?Colors.black:Colors.white,
                      focusNode: _passwordNode,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: SettingProvider.of(context)
                                    .setting
                                    .iconColor)),
                        labelStyle: TextStyle(
                          color: SettingProvider.of(context).setting.textColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: SettingProvider.of(context)
                                    .setting
                                    .textColor)),
                        labelText: 'Password',
                        icon: Icon(
                          Icons.security,
                          color: SettingProvider.of(context).setting.iconColor,
                        ),
                        errorText: snapShot.hasError
                            ? snapShot.error.toString()
                            : null,
                      ),
                      onChanged: (password) {
                        setState(() {
                          realPassword = password;
                        });
                        _loginBLoc.passwordChange.add(password);
                      },
                    )),
            AnimatedCrossFade(
                firstChild: TextField(
                  style: TextStyle(
                      color: SettingProvider.of(context).setting.textColor),
                  cursorColor: SettingProvider.of(context).setting.isLight?Colors.black:Colors.white,
                  focusNode: _confirmPasswordNode,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color:
                                SettingProvider.of(context).setting.iconColor)),
                    labelStyle: TextStyle(
                      color: SettingProvider.of(context).setting.textColor,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color:
                                SettingProvider.of(context).setting.textColor)),
                    icon: Icon(
                      Icons.confirmation_num,
                      color: SettingProvider.of(context).setting.iconColor,
                    ),
                    labelText: 'Confirm Password',
                    errorText: realPassword == confPassword
                        ? null
                        : 'Unconfirmed Password',
                    enabled: changeAuthState,
                  ),
                  onChanged: (String confirmedPassword) {
                    setState(() {
                      confPassword = confirmedPassword;
                    });
                  },
                  onSubmitted: (_) {
                    _confirmPasswordNode.unfocus();
                    _emailNode.unfocus();
                    _passwordNode.unfocus();
                  },
                ),
                secondChild: Container(),
                crossFadeState: changeAuthState
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500)),
            SizedBox(
              height: responsive.setHeight(5),
            ),
            _buildLoginAndCreateButton(),
          ],
        ),
      ),
    );
  }

  //
  Widget _buildLoginAndCreateButton() {
    return StreamBuilder(
        initialData: 'Login',
        stream: _loginBLoc.loginOrCreate,
        builder: (context, AsyncSnapshot snapshot) {
          // print('${snapshot.data}');
          return changeAuthState
              ? buildLoginAndCreateButtons("Create Account", 'Login')
              : buildLoginAndCreateButtons('Login', 'Create Account');
        });
  }

  Widget buildLoginAndCreateButtons(String raisedButton, String textButton) {
    return StreamBuilder(
        stream: _loginBLoc.enableLoginCreateButton,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          bool temp = false;
          if (snapshot.data != null) temp = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: temp &&
                      (changeAuthState
                          ? (realPassword == confPassword)
                          : true)? MaterialStateProperty.all(SettingProvider.of(context).setting.buttonBackgroundColor):
                  MaterialStateProperty.all( Colors.grey)
                ),
                child: Text(
                  raisedButton,
                  style: TextStyle(
                      color: SettingProvider.of(context).setting.textColor),
                ),
                onPressed: temp &&
                        (changeAuthState
                            ? (realPassword == confPassword)
                            : true)
                    ? () async {
                        _loginBLoc.loginOrCreateChanged.add(
                            raisedButton.contains('Login')
                                ? 'Login'
                                : 'create');
                        AuthenticationBLoC _auth =
                            new AuthenticationBLoC(AuthenticationService());
                        String uid =
                            await _loginBLoc.authenticationApi.currentUserUid();
                        print('$uid');
                        _auth.addUser.add(uid);
                      }
                    : null,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    changeAuthState = !changeAuthState;
                  });
                },
                child: Text(
                  textButton + ' instead',
                  style: TextStyle(
                      color: SettingProvider.of(context).setting.iconColor),
                ),
              )
            ],
          );
        });
  }
}
