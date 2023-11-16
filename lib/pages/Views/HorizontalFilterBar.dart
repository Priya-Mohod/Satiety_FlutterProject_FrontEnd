import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/Drawers.dart';

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
  Set<String> selectedFilter = {''};

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
                    child: GestureDetector(
                      onTap: () async {
                        await BottomDrawer()
                            .showFilterDrawer(context, selectedFilter,
                                (Set<String> selectedOptions) {
                          setState(() {
                            selectedFilter = selectedOptions;
                          });
                        });
                      },
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
                  ),
                GestureDetector(
                  onTap: () {
                    widget.onOptionSelected(option);
                    if (selectedFilter.contains(option)) {
                      selectedFilter.remove(option);
                    } else {
                      selectedFilter.add(option);
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          color: selectedFilter.contains(option)
                              ? Colors.yellow
                              : null),
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
