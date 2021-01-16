import 'package:hexcolor/hexcolor.dart';

import 'Getinfo.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String email;
File _imageFile;
int a = 0;
Future<void> currentUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
}

// ignore: deprecated_member_use
final _firestore = Firestore.instance;

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Center(child: Text('Feed')),
        leading: null,
        backgroundColor: HexColor('ff8864'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            CircleAvatar(
              backgroundColor: HexColor('ff4965'),
              radius: 30,
              child: IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetInfo()),
                  );
                },
              ),
            ),
            Container(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatefulWidget {
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('blogs')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.purple,
            ),
          );
        }
        // ignore: deprecated_member_use
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          String currentUser = email;
          currentUserEmail();
          final messageBubble = MessageBubble(
            sender: " ",
            text: messageText,
            isMe: email.toString() == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  String sender;
  String text;
  final bool isMe;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String out;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Material(
                borderRadius: widget.isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0))
                    : BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                elevation: 5.0,
                color: widget.isMe ? Colors.green[600] : Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: widget.text.substring(
                                  widget.text.length - 4, widget.text.length) ==
                              '.jpg' ||
                          widget.text.substring(
                                  widget.text.length - 4, widget.text.length) ==
                              '.png' ||
                          widget.text.substring(
                                  widget.text.length - 5, widget.text.length) ==
                              '.jpeg'
                      ? Image.network(
                          widget.text,
                        )
                      : Center(
                          child: Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.isMe ? Colors.white : Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
