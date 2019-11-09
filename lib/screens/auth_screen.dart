import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tournament_app/screens/home_screen.dart';
import '../store/auth_model.dart';

import '../theme/theme.dart' as AppTheme;

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.AppColors.sand,
                  AppTheme.AppColors.intenseFire,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  Widget errorSnackbar(String message){
    return SnackBar(
            backgroundColor: Colors.black26,  
            content: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppTheme.FontFamilies.regular,
                fontSize: 20
              ),
              ),
            action: SnackBarAction(
              label: 'Got It !',
              textColor: Colors.white,
              onPressed: (){
                return;
              },
            ),
            );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
        ScopedModel.of<AuthModel>(context).userSignIn(_authData['email'], _authData['password'])
        .then((res){
            setState(() {
              _isLoading = false;
            });
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                curve: Curves.easeInOutSine,
                alignment: Alignment.bottomRight,
                duration: Duration(milliseconds: 350),
                child: HomeScreen(),
                ));
        })
        .catchError((err){
          String message = 'Email or Password do not match';

          if(err.toString().contains('INVALID_PASSWORD')){
            message = 'Invalid Password';
          }
          if(err.toString().contains('EMAIL_NOT_FOUND')){
            message = 'Wrong Email !';
          }
          if(err.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')){
            message = 'Too many wrong attempts ,try again in a minute';
          }
          
          // Find the Scaffold in the widget tree and use it to show a SnackBar.
          Scaffold.of(context).showSnackBar(errorSnackbar(message));
          return null;
        });
    } else {
      // Sign user up
        ScopedModel.of<AuthModel>(context).userSignup(_authData['email'], _authData['password']).then((res){
            setState(() {
              _isLoading = false;
            });
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                curve: Curves.easeInOutSine,
                alignment: Alignment.bottomRight,
                duration: Duration(milliseconds: 350),
                child: HomeScreen(),
                ));
        })
        .catchError((err){
          
          String message = 'Email or Password do not match';

          if(err.toString().contains('INVALID_EMAIL')){
            message = "Email that you've entered is not valid.";
          }
          if(err.toString().contains('WEAK_PASSWORD')){
            message = 'Your password is too short.';
          }
          if(err.toString().contains('EMAIL_EXISTS')){
            message = 'That email is already in use.';
          }

          // Find the Scaffold in the widget tree and use it to show a SnackBar.
          Scaffold.of(context).showSnackBar(errorSnackbar(message));
          return null;
        });

    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _guestLogin() async{
    try {
      final guestUser = await FirebaseAuth.instance.signInAnonymously();
      print(guestUser);
      print('guestUser');
    } catch (e) {
      print(e);
      print('error on guest login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
          height: _authMode == AuthMode.Signup ? 320 : 300,
          constraints:
              BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 300),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                          : null,
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                              _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button.color,
                        ),
                        FlatButton(
                          child: Text(
                              '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}'),
                          onPressed: _switchAuthMode,
                          padding:
                              EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textColor: Theme.of(context).primaryColor,
                        ),
                        FlatButton(
                          child: Text('Continue as Guest'),
                          onPressed:() => _guestLogin().then((_){
                            Navigator.of(context).push(PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              curve: Curves.easeInOutSine,
                              alignment: Alignment.bottomRight,
                              duration: Duration(milliseconds: 350),
                              child: HomeScreen(),
                            )).catchError((error){
                              print(error);
                            });
                          }),
                          padding:
                              EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        )
    );
  }
}