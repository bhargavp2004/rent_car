import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cargriditem.dart';
import 'theme.dart';

class CarGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Posts'),
        centerTitle: true,
        backgroundColor: customTheme.primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cars')
            .where('owner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var carDocs = snapshot.data?.docs;
          // print(carDocs);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: carDocs?.length,
            itemBuilder: (context, index) {
              if (carDocs != null) {
                var carData = carDocs[index].data() as Map<String, dynamic>;
                print(carData);
                var imagePath = carData['image'] as String?;
                var carId = carDocs[index].id;

                if (imagePath != null && imagePath.isNotEmpty) {
                  print("Inside IF");
                  var brand = carData['brand'] as String;
                  var model = carData['model'] as String;
                  return CarGridItem(
                    carId: carId,
                    brand: brand,
                    model: model,
                    imageURL: imagePath,
                    
                  );
                } else {
                  // Handle the case where imagePath is null or empty
                  return Card(
                    child: Center(
                      child: Text(
                        'Invalid Image',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
              }
              // Handle the case where carDocs is null or empty
              return Container();
            },
          );
        },
      ),
    );
  }
}
