import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme.dart';

class MyPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
        backgroundColor: customTheme.primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final cars = snapshot.data?.docs;

          return ListView.builder(
            itemCount: cars?.length,
            itemBuilder: (context, index) {
              final car = cars?[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Brand: ${car['brand']}'),
                subtitle: Text('Model: ${car['model']}'),
              );
            },
          );
        },
      ),
    );
  }
}
