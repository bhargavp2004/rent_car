import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_car/pages/login_user.dart';
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
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final role = data['role'].toString();
    // print(role + "------------------");
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
          if (userCredentials.user != null && role.compareTo('user') == 0) {
            print('==============');
            showSnackbar('Registration Successful');
            FirebaseFirestore.instance
                .collection('users')
                .add({'uid': userCredentials.user!.uid});
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage_User()));;
          }
          if (userCredentials.user != null && role.compareTo('admin') == 0) {
            print('==============');
            showSnackbar('Registration Successful');
            FirebaseFirestore.instance
                .collection('admins')
                .add({'uid': userCredentials.user!.uid});
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()));
          }
        } catch (err) {
          showSnackbar(err.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(data['role'].toString() + '+_+_+_+_+_+_+_+_+_+_+_+_++_+_+__+_+');
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
                  Navigator.pushReplacement(
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
