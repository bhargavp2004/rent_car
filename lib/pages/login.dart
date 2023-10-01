import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_car/pages/home.dart';
import 'signup.dart';
import 'dart:core';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isEmailEmpty = false;

  bool isPasswordEmpty = false;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // You can adjust the duration
      ),
    );
  }

  void SignIn(context) async {
    String email = emailController.text;
    String password = passwordController.text;

    setState(() {
      isEmailEmpty = false;
      isPasswordEmpty = false;
    });

    if (email == "") {
      setState(() {
        isEmailEmpty = true;
      });
      showSnackbar('Please enter an email');
    }
    if (password == "") {
      setState(() {
        isPasswordEmpty = true;
      });
      showSnackbar('Please enter password');
    } else {
      try {
        UserCredential uc = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (uc.user != null) {
          showSnackbar('Login Successful!');
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => MyHomePage()));
        }
      } catch (err) {
        showSnackbar("Error : ${err.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Username Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  errorText: isEmailEmpty ? 'Please enter an email' : null,
                ),
              ),
              SizedBox(height: 20.0), // Add spacing
              // Password Field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: isPasswordEmpty ? 'Please Enter Password' : null,
                ),
                obscureText: true, // Hide password
              ),
              SizedBox(height: 20.0), // Add spacing
              // Sign In Button
              ElevatedButton(
                onPressed: () {
                  SignIn(context);
                },
                child: Text('Sign In'),
              ),
              CupertinoButton(
                child: Text('Create an Account'),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
