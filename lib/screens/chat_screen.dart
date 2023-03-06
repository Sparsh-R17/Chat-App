import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          DropdownButton(
            //^ underline Sizedbox removes the underline from menu
            underline: const SizedBox(),
            elevation: 0,
            icon: const Icon(Icons.more_vert_outlined),
            iconEnabledColor: Theme.of(context).primaryIconTheme.color,
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                _auth.signOut();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/ExDIpcVPClqF4KA6xIj0/messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Text(documents[index]['text']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/ExDIpcVPClqF4KA6xIj0/messages')
              .add(
            {'text': 'Added by App'},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
