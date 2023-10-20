import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cardetails.dart';
import 'carupdateform.dart';
import 'theme.dart';

class CarGridItem extends StatelessWidget {
  final String carId;
  final String brand;
  final String model;
  final String imageURL;

  CarGridItem({
    required this.carId,
    required this.brand,
    required this.model,
    required this.imageURL,
  });

  void deletePost(String carId) {
    // Delete the car entry from Firestore
    FirebaseFirestore.instance
        .collection('cars')
        .doc(carId)
        .delete()
        .then((value) {
      print('Car deleted successfully');
    }).catchError((error) {
      print('Failed to delete car: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
     return SizedBox(
      height: 300,
      child: Card(
        child: ListView(
          shrinkWrap: true,
          children: [
            if (imageURL != null && Uri.parse(imageURL).isAbsolute)
              Image.network(
                imageURL,
                fit: BoxFit.fitWidth,
                height: 120,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Failed to load image'));
                },
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    Text(brand, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(model),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarDetails(carId: carId)),
                        );
                      },
                      child: Text("View More"),
                      style : ElevatedButton.styleFrom(backgroundColor: customTheme.primaryColor),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deletePost(carId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("Delete Post"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateCarForm(carId: carId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text("Update Post"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
