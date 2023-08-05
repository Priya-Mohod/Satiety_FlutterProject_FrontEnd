import 'package:flutter/material.dart';

class RequestProvider extends ChangeNotifier {
  List<Request> _myRequests = [];

  List<Request> get myRequests => _myRequests;

  void addRequest(Request request) {
    _myRequests.add(request);
    notifyListeners();
  }

  void updateRequestStatus(Request request, bool bool) {
    notifyListeners();
  }

  void removeRequest(Request request) {
    _myRequests.remove(request);
    notifyListeners(); // Notify listeners to trigger a rebuild of dependent widgets
  }
}

class Request {
  final String id;
  final int foodItemId;
  final String message;
  final bool isAccepted;

  Request({
    required this.id,
    required this.foodItemId,
    required this.message,
    required this.isAccepted,
  });
}
