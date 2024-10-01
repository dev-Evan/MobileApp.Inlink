import 'package:flutter/material.dart';
import 'package:gs_ui_library/custom_lib/gs_bottom_navigation_screen.dart';
import 'package:gs_ui_library/custom_lib/gs_custom_button.dart';
import 'custom_status_box.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            bottom: false,
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: GSCustomBottomNavigationScreen(
                initialIndex: 2,
                screens: [
                  HomeScreen(),
                  SearchScreen(),
                  ProfileScreen(),
                ],
                navItems: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: "Search"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Profile"),
                ],
                // Here you don't need to specify all the settings if you want defaults
              ),
            )),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GSCustomButton(
          text: 'Submit',
          onPressed: () {
            print('Submit button pressed');
          },
        ),
        GSCustomButton(
          icon: Icon(Icons.add),
          onPressed: () {
            print('Add button pressed');
          },
        ),
        GSCustomButton(
          text: 'Add',
          icon: Icon(Icons.add),
          backgroundColor: Colors.green,
          // Custom background color
          textColor: Colors.white,
          // Custom text color
          padding: 12.0,
          // Custom padding
          onPressed: () {
            print('Add button with text pressed');
          },
        )
      ],
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Status Box')),
      body: ListView(
        children: [
          StatusBox(
            profileImageUrl: 'https://example.com/profile.jpg',
            name: 'Jane Doe',
            dateTime: DateTime.now(),
            statusText: 'Had an amazing time hiking today!',
            likeCount: 10,
            actions: [
              StatusAction(
                icon: Icons.comment_outlined,
                label: '5 Comments',
                onTap: () {
                  print('Comment pressed');
                },
                iconColor: Colors.orange,
              ),
              StatusAction(
                icon: Icons.share,
                label: 'Share',
                onTap: () {
                  print('Share pressed');
                },
                iconColor: Colors.green,
              ),
            ],
            onEdit: () {
              print('Edit action triggered');
            },
            onDelete: () {
              print('Delete action triggered');
            },
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen'));
  }
}
