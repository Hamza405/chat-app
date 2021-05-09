import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_app/widget/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    void _sumbitAuthForm(
        String email, String userName, String password,File image, bool isLogin,BuildContext ctx) async {
      var authResult;
      try {
        setState(() {
          _isLoading=true;
        });
        if (isLogin) {
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          final ref =  FirebaseStorage.instance.ref().child('user_image').child(_auth.currentUser.uid+'.jpg');
          await ref.putFile(image);
          final imageUrl = await ref.getDownloadURL();
          await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.uid).set({
            'userName':userName,
            'email':email,
            'imageUrl':imageUrl
          });   
            
        }
         setState(() {
          _isLoading=false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>ChatScreen()));
      }  catch (e) {
         setState(() {
          _isLoading=false;
        });
        var message = 'An error occurred';
        if (e.message != null) {
          message = e.message.toString();
        }
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).primaryColor,
        ));
        print(e.toString());
      }
    }

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_sumbitAuthForm,_isLoading));
  }
}
