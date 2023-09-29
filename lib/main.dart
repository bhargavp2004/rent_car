import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAR RENTAL',
      theme: customTheme,
      home: (FirebaseAuth.instance.currentUser != null) ? MyHomePage() : SignInPage(),
    );
  }
}
