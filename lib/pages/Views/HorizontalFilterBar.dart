import 'package:flutter/material.dart';

class HorizontalFilterBar extends StatefulWidget {
  final List<String> options;
  final Function(String) onOptionSelected;
  final double height;

  HorizontalFilterBar(
      {required this.options,
      required this.onOptionSelected,
      required this.height});

  _HorizontalFilterBarState createState() => _HorizontalFilterBarState();
}

class _HorizontalFilterBarState extends State<HorizontalFilterBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[100],
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            return Row(
              children: [
                if (index == 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list, // Replace with your icon
                          size: 16.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                GestureDetector(
                  onTap: () => widget.onOptionSelected(option),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
