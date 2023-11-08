import 'package:flutter/material.dart';

class SearchBarView extends StatefulWidget {
  final ValueChanged<String> onSearchTextChanged;
  final double height;

  SearchBarView({required this.onSearchTextChanged, required this.height});

  _SearchBarView createState() => _SearchBarView();
}

class _SearchBarView extends State<SearchBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                onChanged: widget.onSearchTextChanged,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform search operation
            },
          ),
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              // Perform voice search operation
            },
          ),
        ],
      ),
    );
  }
}
