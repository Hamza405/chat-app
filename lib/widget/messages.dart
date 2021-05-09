import 'package:chat_app/widget/MessageBubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chats').orderBy('createdAt',descending: true).snapshots(),
      builder: (ctx,AsyncSnapshot<QuerySnapshot> snapshot){
        final user =  FirebaseAuth.instance.currentUser;
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child:CircularProgressIndicator());
        }
        final docs=snapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount:docs.length ,
          itemBuilder: (ctx,index)=>MessageBubble(docs[index]['text'],docs[index]['userName'],docs[index]['userImage'],user.uid==docs[index]['userId'],ValueKey(docs[index].id)),
        );
        
      },
    );
  }
}