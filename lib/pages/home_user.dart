import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_car/pages/addpost.dart';
import 'package:rent_car/pages/login.dart';
import 'package:rent_car/pages/myposts.dart';
import 'theme.dart';
import 'cargridpage.dart';

class MyHomePage_User extends StatelessWidget {
  var buttonColor = customTheme.primaryColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter UI Example')),
      body: Container(
        // Set background color to blue
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => CarGridPage()));
              //   },
              //   child: Text('View My Posts'),
              //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => AddPost()));
              //   },
              //   child: Text('Add Post'),
              //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Add your action for "Delete Post" here
              //   },
              //   child: Text('Delete Post'),
              //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Add your action for "Update Post" here
              //   },
              //   child: Text('Update Post'),
              //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              // ),
              ElevatedButton(
                onPressed: () {
                  // Add your action for "logout" here
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: Text('logout'),
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
