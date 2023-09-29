import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Extract the list of cars from the snapshot
          final cars = snapshot.data?.docs;

          // Build a ListView to display the cars
          return ListView.builder(
            itemCount: cars?.length,
            itemBuilder: (context, index) {
              final car = cars?[index].data() as Map<String, dynamic>;

              // Customize how you want to display the car details
              return ListTile(
                title: Text('Brand: ${car['brand']}'),
                subtitle: Text('Model: ${car['model']}'),
                // Add more details as needed
              );
            },
          );
        },
      ),
    );
  }
}
