import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:satietyfrontend/pages/getData.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

String getdata = '';
Map mapData = {};
List allData = [];

class _ListViewPageState extends State<ListViewPage> {
  Future getData() async {
    var url = Uri.parse('http://192.168.0.70:8080/getall');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        //getdata = response.body;
        allData = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  //Data data = Data();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: 'Home',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum, size: 40),
            label: 'Forum',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: 'Add',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, size: 40),
            label: 'Bookmarks',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 40),
            label: 'Messeges',
            backgroundColor: Colors.cyan,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/ListViewPage');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/ForumPage');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/OptionPage');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/BookmarksPage');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/MessegePage');
          }
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Container(
                  height: 150,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.cyan[100],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/a.png',
                        height: 100,
                        width: 100,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.cyanAccent[400],
                            height: 35,
                            width: 280,
                            child: Text(
                              allData[index]['freeFoodName'].toString(),
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            color: Color.fromARGB(255, 104, 213, 219),
                            height: 100,
                            width: 280,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  allData[index]['freeFoodDescription']
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Quantity: ${allData[index]['freeFoodQuantity'].toString()}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Address: ${allData[index]['freeFoodAddress'].toString()}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        itemCount: allData.length,
      ),
    );
  }
}

/*
              Padding(
                  padding: EdgeInsets.all(4),
                  child: Image.asset('images/a.png'),
                ),
              Text(allData[index]['freeFoodName'].toString()),
              Text(allData[index]['freeFoodDescription'].toString()),
              Text(allData[index]['freeFoodQuantity'].toString()),
              Text(allData[index]['freeFoodAddress'].toString()),
Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/b.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        //color: Colors.yellow,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  elevation: 10,
                  minimumSize: const Size(250, 60),
                ),
                onPressed: () {
                  // data.getData;
                },
                child: const Text(
                  'Show List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'calibri',
                  ),
                ),
              ),
              Center(
                child: Container(
                    height: 500,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Center(child: Text(mapData[].toString()))),
              ),
            ],
          ),
        ),
      ),

      ///////////////


      ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 150,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.cyan[100],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Food Name: ${allData[index]['freeFoodName'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Food Description: ${allData[index]['freeFoodDescription'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Food Quantity: ${allData[index]['freeFoodQuantity'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Food Address: ${allData[index]['freeFoodAddress'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: allData.length,
      ),
      */
