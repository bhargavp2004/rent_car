import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rent_car/pages/home_user.dart';
import 'package:rent_car/pages/login.dart';
import 'pages/home.dart';
import 'pages/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String isLoading='loading';
  redirectAppropriately() {
    if(FirebaseAuth.instance.currentUser==null){
      setState(() {
        isLoading='signin';
      });
    }
    else if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance
          .collection(
          'users') // Replace 'your_collection' with your actual collection name
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            isLoading='user';
          });
          return;
        } else{
          FirebaseFirestore.instance
              .collection(
              'admins') // Replace 'your_collection' with your actual collection name
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((snapshot) {
                if (snapshot.docs.isNotEmpty) {
                  setState(() {
                    isLoading='admin';
                  });
                  return;
                }
                else {
                  setState(() {
                    isLoading = 'signin';
                  });
                  return;
                }
              }
          );
        }
      });
    }
  }
  @override
  void initState(){
    redirectAppropriately();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CAR RENTAL',
      theme: customTheme,
      // theme: ThemeData(useMaterial3: true, customTheme),
      home: (isLoading.compareTo('loading')==0?Text('loading'):(isLoading.compareTo('admin')==0?MyHomePage():(isLoading.compareTo('user')==0?MyHomePage_User():(isLoading.compareTo('signin')==0?SignInPage():null)))),
      // home: MyHomePage()
    );
  }
}
