import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _message='';
  final _controller = TextEditingController();
  void _sendMessage()async{
    FocusScope.of(context).unfocus();
    final user =await FirebaseAuth.instance.currentUser;
    final userData =await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chats').add({
      'text':_message,
      'createdAt':Timestamp.now(),
      'userId':user.uid,
      'userName':userData['userName'],
      'userImage':userData['imageUrl']
    });
    _controller.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Send Messages ...',
                  ),
                  onChanged: (v) {
                    setState(() {
                      _message=v;
                    });
                  })),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: _message.trim().isEmpty?null:_sendMessage
          )
        ],
      ),
    );
  }
}
