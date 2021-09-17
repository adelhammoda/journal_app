import 'package:flutter/material.dart';
import 'package:journal_app/bloc/login_bloc.dart';
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
  String realPassword='';
  String confPassword='';
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
        backgroundColor: Colors.lightGreen,
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
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(
                          Icons.email_outlined,
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
                      focusNode: _passwordNode,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(
                          Icons.security,
                        ),
                        errorText: snapShot.hasError
                            ? snapShot.error.toString()
                            : null,
                      ),
                      onChanged: (password){
                        setState(() {
                          realPassword=password;
                        });
                        _loginBLoc.passwordChange.add(password);

                      },
                    )),
            AnimatedCrossFade(firstChild:
             TextField(
                focusNode: _confirmPasswordNode,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.confirmation_num),
                  labelText: 'Confirm Password',
                  errorText:realPassword==confPassword?null:'Unconfirmed Password',
                  enabled: changeAuthState,
                ),
                onChanged:(String confirmedPassword){
                  setState(() {
                    confPassword=confirmedPassword;
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
              ? buildLoginAndCreateButtons("Create Account", 'Login'):
          buildLoginAndCreateButtons('Login', 'Create Account');
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
                child: Text(raisedButton),
                onPressed: temp&&(changeAuthState?(realPassword==confPassword):true)
                    ? () {
                  _loginBLoc.loginOrCreateChanged.add(
                      raisedButton.contains('Login')
                          ? 'Login'
                          : 'create');
                }
                    : null,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      changeAuthState = !changeAuthState;
                    });
                  },
                  child: Text(textButton + ' instead'))
            ],
          );
        });
  }
}
