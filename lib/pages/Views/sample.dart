import 'package:flutter/material.dart';

class FoodListPage extends StatefulWidget {
  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  String selectedFilter = 'All';

  List<String> filters = [
    'All',
    'Veg',
    'Non-Veg',
    'Spicy',
    'Sweet',
    'Healthy',
    'Gluten-Free',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Food List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              // Handle search action here
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Filter By:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: filters.map((filter) {
                    return FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: selectedFilter == filter
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      onSelected: (isSelected) {
                        setState(() {
                          selectedFilter = isSelected ? filter : 'All';
                        });
                      },
                      selected: selectedFilter == filter,
                      selectedColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.grey[300],
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with the actual number of food items
              itemBuilder: (context, index) {
                // Replace this with the code to display individual food items
                return ListTile(
                  title: Text('Food Item ${index + 1}'),
                  subtitle: Text('Description of Food Item ${index + 1}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
