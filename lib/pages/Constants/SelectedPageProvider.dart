import 'package:flutter/material.dart';

import 'StringConstants.dart';

class SelectedPageProvider extends ChangeNotifier {
  String _selectedPage = StringConstants.Dashboard;

  String get selectedPage => _selectedPage;

  void setSelectedPage(String page) {
    if (_selectedPage != page) {
      _selectedPage = page;
      // notifyListeners();
    }
  }
}
