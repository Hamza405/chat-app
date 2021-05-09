import 'package:chat_app/widget/messages.dart';
import 'package:chat_app/widget/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'auth_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
});
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat room'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    child: Container(
                        child: Row(
                      children: [Icon(Icons.exit_to_app), Text('Logout')],
                    )),
                    value: 'logout',
                  )
                ],
                onChanged: (i) {
                  if (i == 'logout') {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => AuthScreen()));
                  }
                },
                icon: Icon(Icons.more_vert,
                    color: Theme.of(context).primaryIconTheme.color)),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessage()
            
          ],
        ),
      ),
      
    );
  }
}
