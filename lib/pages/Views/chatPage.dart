import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';
import 'package:satietyfrontend/pages/ViewModels/ChatViewModel.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';

class ChatMessage {
  final String content;
  final String sender;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.sender,
    required this.timestamp,
  });
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();

  Future initializedData() async {
    var result = await Provider.of<ChatViewModel>(context, listen: false)
        .fetchChatData();
    print(result);
    if (result == false) {
      // ignore: use_build_context_synchronously
      SnackbarHelper.showSnackBar(context, StringConstants.server_error);
    }
  }

  @override
  void initState() {
    super.initState();
    initializedData();
    // Implement initializing the chat page
    // Connect to the server
    // Fetch previous messages
    final newMessage = ChatMessage(
      content: "I am a message",
      sender: 'another', // Replace with actual sender information
      timestamp: DateTime.now(),
    );
    messages.add(newMessage);
  }

  void sendMessage(String messageText) {
    // Implement sending messages to the server
    // Update the messages list with sender information
    setState(() {
      final newMessage = ChatMessage(
        content: messageText,
        sender: 'You', // Replace with actual sender information
        timestamp: DateTime.now(),
      );
      messages.add(newMessage);
    });
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = messages[index];
                  return ChatBubble(
                    message: message.content,
                    isMe: message.sender == 'You',
                  );
                },
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = messageController.text;
                      if (message.isNotEmpty) {
                        sendMessage(message);
                      }
                    },
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

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
