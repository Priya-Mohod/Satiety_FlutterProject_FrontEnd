import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:satietyfrontend/pages/Constants/FirebaseSetup.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'Constants/Drawers.dart';
import 'Constants/bottomNavigationBar.dart';

class MessagePage extends StatefulWidget {
  final String currentUserEmail;
  const MessagePage({super.key, required this.currentUserEmail});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ChatService _chatService = ChatService();
  // Stream for chat documents
  Stream<QuerySnapshot<Map<String, dynamic>>>? _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream =
        _chatService.getAllChats().cast<QuerySnapshot<Map<String, dynamic>>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //endDrawer: SideDrawer(),
      body: Column(
        children: [
          // display messages
          Expanded(child: _buildMyChatsList()),
        ],
      ),
    );
  }

  Widget _buildMyChatsList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _chatStream,
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
                _buildChatItem(snapshot.data!.docs[index]),
          );
        }
      },
    );
  }

  // Future<void> _buildMyChatsList() async {
  //   // Get all chats
  //   final chats = await _chatService.getAllChats();

  //   // Loop through each chat and access data
  //   for (var chat in chats) {
  //     final data = chat.data();
  //     // Access specific fields from data (e.g., senderEmail, receiverEmail, etc.)
  //     print(data);
  //   }
}

Widget _buildChatItem(DocumentSnapshot messageSnapshot) {
  final messageData = messageSnapshot.data() as Map<String, dynamic>;
  final sender = messageData['sender'];
  final message = messageData['message'];
  final timestamp = messageData['timestamp'];

  return ListTile(
    leading: CircleAvatar(
      // You can set the sender's profile picture here
      child: Text(sender[0].toUpperCase()),
    ),
    title: Text(
      sender,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(message),
    trailing: Text(
      // Convert timestamp to a readable format, adjust as needed
      DateFormat('MM/dd/yyyy HH:mm').format(timestamp.toDate()),
    ),
    onTap: () {
      // Implement onTap if you want to handle tap events on the chat item
      // Display chat details
    },
  );
}
