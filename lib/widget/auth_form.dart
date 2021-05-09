import 'package:chat_app/widget/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class AuthForm extends StatefulWidget {
  final void Function(String email, String userName, String password,File image,
      bool isLogin, BuildContext ctx) sumbitAuthForm;
  final bool isLoading;
  AuthForm(this.sumbitAuthForm, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _userEmail;
  String _userName;
  String _userPassword;
  File _userImageFile;
  void _pickedImage(File image){
    _userImageFile=image;
  } 

  void _sumbit() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(_userImageFile==null&&!_isLogin){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please Pick an image'),backgroundColor: Theme.of(context).errorColor));
      return;
    }
    if (_isValid) {
      _formKey.currentState.save();
      widget.sumbitAuthForm(_userEmail.trim(), _userName, _userPassword.trim(),_userImageFile,
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        margin: EdgeInsets.all(20),
        child: AnimatedContainer(
          width: deviceSize.width * 0.8,
          height:
              _isLogin ? deviceSize.height * 0.45 : deviceSize.height * 0.7,
          constraints: BoxConstraints(minHeight:  _isLogin ? deviceSize.height * 0.45 : deviceSize.height * 0.7),
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInCirc,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('userName'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'User name must be at least 3 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'User Name',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 20),
                  if (widget.isLoading) Center(child: CircularProgressIndicator()),
                  if (!widget.isLoading)
                    RaisedButton(
                        onPressed: _sumbit,
                        child: Text(_isLogin ? 'login' : 'SignUp')),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
