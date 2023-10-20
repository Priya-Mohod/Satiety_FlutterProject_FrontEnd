import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Views/CustomHeader.dart';
import 'package:satietyfrontend/pages/Views/HorizontalFilterBar.dart';
import 'package:satietyfrontend/pages/Views/SearchBarView.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(
            title: 'Satiety',
            profileImageURL: 'assets/account.png',
            height: 120,
          ),
          SearchBarView(onSearchTextChanged: (String text) {}, height: 80),
          HorizontalFilterBar(
            options: [
              'Free',
              'Chargeable',
              'Veg',
              'Non-Veg',
              'Available',
              'Just Gone',
              'Distance'
            ],
            onOptionSelected: (selectedOption) {
              // Handle the selected option
              print('Selected option: $selectedOption');
            },
            height: 50,
          )

          // Add other widgets for the body of the HomeScreen here
        ],
      ),
    );
  }
}
