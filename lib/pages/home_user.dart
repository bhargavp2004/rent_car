import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_car/pages/addpost.dart';
import 'package:rent_car/pages/cargriditem.dart';
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
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
      // body: Container(
      //   // Set background color to blue
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         StreamBuilder(
      //           stream:
      //               FirebaseFirestore.instance.collection('cars').snapshots(),
      //           builder: (context, snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return Center(child: CircularProgressIndicator());
      //             }

      //             if (snapshot.hasError) {
      //               return Center(child: Text('Error: ${snapshot.error}'));
      //             }

      //             var carDocs = snapshot.data?.docs;
      //             // print(carDocs);
      //             return GridView.builder(
      //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 2,
      //                 childAspectRatio: 0.7,
      //               ),
      //               itemCount: carDocs?.length,
      //               itemBuilder: (context, index) {
      //                 if (carDocs != null) {
      //                   var carData =
      //                       carDocs[index].data() as Map<String, dynamic>;
      //                   print(carData);
      //                   var imagePath = carData['image'] as String?;
      //                   var carId = carDocs[index].id;

      //                   if (imagePath != null && imagePath.isNotEmpty) {
      //                     print("Inside IF");
      //                     var brand = carData['brand'] as String;
      //                     var model = carData['model'] as String;
      //                     return CarGridItem(
      //                       carId: carId,
      //                       brand: brand,
      //                       model: model,
      //                       imageURL: imagePath,
      //                     );
      //                   } else {
      //                     // Handle the case where imagePath is null or empty
      //                     return Card(
      //                       child: Center(
      //                         child: Text(
      //                           'Invalid Image',
      //                           style: TextStyle(color: Colors.red),
      //                         ),
      //                       ),
      //                     );
      //                   }
      //                 }
      //                 // Handle the case where carDocs is null or empty
      //                 return Container();
      //               },
      //             );
      //           },
      //         ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     Navigator.push(context,
      //         //         MaterialPageRoute(builder: (context) => CarGridPage()));
      //         //   },
      //         //   child: Text('View My Posts'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     Navigator.push(context,
      //         //         MaterialPageRoute(builder: (context) => AddPost()));
      //         //   },
      //         //   child: Text('Add Post'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     // Add your action for "Delete Post" here
      //         //   },
      //         //   child: Text('Delete Post'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     // Add your action for "Update Post" here
      //         //   },
      //         //   child: Text('Update Post'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         ElevatedButton(
      //           onPressed: () {
      //             // Add your action for "logout" here
      //             FirebaseAuth.instance.signOut();
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => SignInPage()));
      //           },
      //           child: Text('logout'),
      //           style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
