import 'package:flutter/material.dart';
import 'cardetails_user.dart';

class CarGridItem_User extends StatelessWidget {
  final String carId;
  final String brand;
  final String model;
  final String imageURL;

  CarGridItem_User(
      {required this.carId, required this.brand, required this.model, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (imageURL != null && Uri.parse(imageURL).isAbsolute)
              Image.network(
                imageURL,
                fit: BoxFit.fitWidth,
                height : 150,
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
              child: Column(
                children: [
                  Text(brand, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(model),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CarDetails_User(carId: carId),));
                      },
                      child: Text("View More")
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
