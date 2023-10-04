import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_car/pages/addpost.dart';
import 'package:rent_car/pages/home_user.dart';
import 'package:rent_car/pages/login.dart';
import 'package:rent_car/pages/myposts.dart';
import 'theme.dart';
import 'cargridpage.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var buttonColor = customTheme.primaryColor;
  void checkUser() {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // redirecting to user home page if current user is "user"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter UI Example'),
        backgroundColor: customTheme.primaryColor,
      ),
      body: Container(
        // Set background color to blue
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CarGridPage()));
                },
                child: Text('View My Posts'),
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPost()));
                },
                child: Text('Add Post'),
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your action for "Delete Post" here
                },
                child: Text('Delete Post'),
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your action for "Update Post" here
                },
                child: Text('Update Post'),
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your action for "logout" here
                  FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                  });
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
