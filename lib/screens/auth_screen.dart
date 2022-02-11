import 'dart:math';

import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login, PasswordReset }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
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

  void _showErrorDialog(message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Error occured'),
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else if (_authMode == AuthMode.PasswordReset) {
        await Provider.of<Auth>(context, listen: false)
            .resetPassword(_authData['email']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMeassage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMeassage = 'Email zajęty, wpisz inny';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMeassage = 'Niepoprawny adres email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMeassage = 'Hasło jest za słabe';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMeassage = 'Nie znaleziono użytkownika z podanym adresem';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMeassage = 'Nieprawidłowe hasło';
      }
      _showErrorDialog(errorMeassage);
    } catch (error) {
      // const errorMessage = 'Could not authenticate you. Please try again later';
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
    } else if (_authData == AuthMode.PasswordReset) {
      setState(() {
        _authMode = AuthMode.Login;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
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
                if (_authMode == AuthMode.PasswordReset)
                  Text(
                      'Na podany adres email zostanie wysłana wiadomość z linkiem resetującym hasło.'),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Niepoprawny email!';
                    }
                    return null;
                    //  return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                if (_authMode == AuthMode.Login || _authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Hasło'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Hasło jest za krótkie!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Powtórz hasło'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Hasła nie są takie same!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 5,
                ),
                if (_authMode == AuthMode.Login)
                  GestureDetector(
                    onTap: () => setState(() {
                      _authMode = AuthMode.PasswordReset;
                    }),
                    child: Text(
                      'Zapomniałeś hasła?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else if (_authMode == AuthMode.PasswordReset)
                  RaisedButton(
                    child: Text('Wyślij'),
                    onPressed: () {
                      _submit();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Wysłano email z linkiem resetującym')));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  )
                else
                  RaisedButton(
                    child: Text(_authMode == AuthMode.Login
                        ? 'ZALOGUJ'
                        : 'ZAREJESTRUJ SIĘ'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: _authMode == AuthMode.PasswordReset
                      ? Text('Wróć')
                      : Text(
                          '${_authMode == AuthMode.Login ? 'REJESTRACJA' : 'LOGOWANIE'} '),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
