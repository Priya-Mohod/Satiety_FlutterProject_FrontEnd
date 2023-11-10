import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';

class CustomSearchBar extends StatefulWidget {
  final String searchText;
  final void Function(String) onSearch;
  const CustomSearchBar(
      {super.key, required this.searchText, required this.onSearch});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          widget.onSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
