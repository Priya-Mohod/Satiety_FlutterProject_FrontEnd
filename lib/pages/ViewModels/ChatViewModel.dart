import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/Models/ChatModel.dart';

class ChatViewModel with ChangeNotifier {
  Service service = Service();
  List<Chat> _messages = [];
  List<Chat> get messages => _messages;

  Future<bool> fetchChatData() async {
    try {
      final response = await service.fetchChatData(54);
      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _messages = data.map((item) => Chat.fromJson(item)).toList();
        //notifyListeners();
        print(_messages);
        return true;
      } else if (response != null) {
        // Handle error response
        print('Fetch Chat data - Error: ${response.statusCode}');
      } else {
        // Unable to send data to server
        print('Fetch Chat data - Unable to get data from server');
      }
      return false;
    } catch (e) {
      print('Exception occurred while fetching chat data: $e');
      return false;
    }
  }
}
