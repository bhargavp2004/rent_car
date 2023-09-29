import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Variables to track if fields are empty
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;
  bool isConfirmPasswordEmpty = false;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // You can adjust the duration
      ),
    );
  }

  void createAccount(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Reset error flags
    setState(() {
      isEmailEmpty = false;
      isPasswordEmpty = false;
      isConfirmPasswordEmpty = false;
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
      showSnackbar('Please enter a password');
    }
    if (confirmPassword == "") {
      setState(() {
        isConfirmPasswordEmpty = true;
      });
      showSnackbar('Please confirm your password');
    }

    if (!isEmailEmpty && !isPasswordEmpty && !isConfirmPasswordEmpty) {
      if (password != confirmPassword) {
        showSnackbar('Password and Confirm Password should match');
      } else {
        try {
          UserCredential userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          showSnackbar('Registration Successful');
          if (userCredentials.user != null) {
            Navigator.pop(context);
          }
        } catch (err) {
          showSnackbar(err.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',

                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',

                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',

                ),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () {
                  createAccount(context);
                },
                child: Text('Sign Up'),
              ),
              CupertinoButton(
                child: Text('Already have an account? Sign in'),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SignInPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
