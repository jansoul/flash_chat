import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

late User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class _ChatScreenState extends State<ChatScreen> {
  final messageEditingController = TextEditingController();
  late String messageText;
  final _auth = FirebaseAuth.instance;

  void getUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      autocorrect: false,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageEditingController.clear();
                      try {
                        await _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email
                        });
                      } catch (e) {
                        print(e);
                      }
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            ),
          );
        }
        List<MessageBubble> messageBubbles = [];
        snapshot.data!.docs.reversed.forEach((element) {
          var messageText = element['text'];
          var sender = element['sender'];

          messageBubbles.add(MessageBubble(
            sender: sender,
            text: messageText,
            isMe: loggedInUser.email == sender,
          ));
        });
        return Expanded(
          child: ListView(
            children: messageBubbles,
            reverse: true,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  MessageBubble({required this.sender, required this.text, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment:
              isMe == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              sender,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.only(
                  topRight:
                      isMe == true ? Radius.circular(20) : Radius.circular(0),
                  topLeft:
                      isMe == true ? Radius.circular(0) : Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: isMe == true ? Colors.white : Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 15,
                      color: isMe == true ? Colors.black : Colors.white),
                ),
              ),
            ),
          ]),
    );
  }
}
