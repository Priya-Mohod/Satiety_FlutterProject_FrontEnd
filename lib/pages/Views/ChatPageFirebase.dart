import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/DateTimeUtils.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';

import '../Constants/FirebaseSetup.dart';

class ChatPageFirebase extends StatefulWidget {
  final String senderEmail;
  final String receiverEmail;
  final String foodId;

  const ChatPageFirebase({
    Key? key,
    required this.senderEmail,
    required this.receiverEmail,
    required this.foodId,
  }) : super(key: key);

  @override
  _ChatPageFirebaseState createState() => _ChatPageFirebaseState();
}

class _ChatPageFirebaseState extends State<ChatPageFirebase> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.senderEmail, widget.receiverEmail,
          widget.foodId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatPageFirebase'),
      ),
      body: Column(
        children: [
          // display messages
          Expanded(child: _buildMessageList()),

          // display textfield to enter message
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.senderEmail, widget.receiverEmail, widget.foodId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                _buildMessageItem(snapshot.data!.docs[index]),
          );
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> message = document.data() as Map<String, dynamic>;
    String messageTime = DateTimeUtils.getFormattedDate(message['timestamp']);

    var senderEmail = message['senderEmail'];
    var alignment = message['senderEmail'] == widget.senderEmail
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                message['message'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              messageTime,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ));
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration.collapsed(hintText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
