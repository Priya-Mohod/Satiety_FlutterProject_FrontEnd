import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseSetup {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> addData(Map<String, dynamic> data, String collectionName) async {
    // await _firestore.collection(collectionName).add(data);
    await _fireStore
        .collection('users')
        .doc(data['email'])
        .set(data, SetOptions(merge: true));
  }
}

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String currentEmail, String receiverEmail,
      String foodId, String message) async {
    final Timestamp timestamp = Timestamp.now();
    Message messageObject = Message(
        senderEmail: currentEmail,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp);

    List<String> users = [currentEmail, receiverEmail, foodId];
    users.sort();
    String chatId = users.join("_");
    print('printing chat ID ${chatId}');
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageObject.toMap());
  }

  Stream<QuerySnapshot> getMessages(
      String currentEmail, String receiverEmail, String foodId) {
    List<String> users = [currentEmail];
    if (receiverEmail.isNotEmpty) {
      users.add(receiverEmail);
    }
    if (foodId.isNotEmpty) {
      users.add(foodId);
    }
    users.sort();
    String chatId = users.join("_");

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  final chatsCollection = FirebaseFirestore.instance.collection('chats');

  // Within _chatService
  Stream<QuerySnapshot> getAllChats() {
    return chatsCollection.snapshots();
  }
}

class Message {
  final String senderEmail;
  final String receiverEmail;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderEmail,
      required this.receiverEmail,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
