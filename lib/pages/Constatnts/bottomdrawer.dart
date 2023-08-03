import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';

class BottomDrawer {
  static void showBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400, // Set a fixed height for the bottom drawer
          decoration: BoxDecoration(
            color: Colors.cyan[50],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 30),
                  ListTile(
                    leading: Icon(
                      Icons.fastfood_rounded,
                      color: Color.fromARGB(255, 168, 58, 128),
                      size: 35,
                    ),
                    title: Text(
                      'Add Food',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Text(
                      'Give away food for free or chargable, and help the community!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      // Close the drawer and navigate to the forum page
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/AddFreeFood');
                    },
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    leading: Icon(
                      Icons.forum_rounded,
                      color: Color.fromARGB(255, 50, 1, 58),
                      size: 35,
                    ),
                    title: Text(
                      'Forum',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Text(
                      'Share your thoughts and ideas with the community!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      // Close the drawer and navigate to the forum page
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/ForumPage');
                    },
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  const Icon(
                    Icons.support_agent_rounded,
                    color: Colors.redAccent,
                    size: 35,
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForumPage(),
                          ));
                    },
                    child: const Text('Help! What can I add?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 201, 54, 35),
                          fontSize: 25,
                          fontFamily: 'times new roman',
                        )),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static void showFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          //height: 400, // Set a fixed height for the bottom drawer
          decoration: BoxDecoration(
            color: Colors.cyan[50],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text('Food Filter',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'times new roman',
                  )),
              SizedBox(height: 20),
              Divider(
                color: Colors.black,
                height: 1,
                thickness: 1,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Free or Chargeable:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      minimumSize: const Size(40, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.refresh_sharp,
                                          size: 20,
                                          color: Colors.amber[900],
                                        ),
                                        SizedBox(width: 10),
                                        Text('All',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    )),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      minimumSize: const Size(50, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 20,
                                          color: Colors.green[900],
                                        ),
                                        SizedBox(width: 10),
                                        Text('Free',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    )),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      minimumSize: const Size(50, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee_rounded,
                                          size: 20,
                                          color: Colors.red[900],
                                        ),
                                        SizedBox(width: 10),
                                        Text('Chargeable',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
