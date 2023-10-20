import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_car/pages/theme.dart';

class CarDetails extends StatefulWidget {
  final String carId;

  CarDetails({required this.carId});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _carDetails;

  @override
  void initState() {
    super.initState();
    _carDetails = _fetchCarDetails(widget.carId);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchCarDetails(String carId) async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('cars').doc(carId).get();
    return documentSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _carDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var carData = snapshot.data?.data();
        if (carData == null) {
          return Center(child: Text('Car not found'));
        }

        var brand = carData['brand'];
        var model = carData['model'];
        var year = carData['year'];
        var mileage = carData['mileage'];
        var seats = carData['seats'];
        var price = carData['price_per_day'];
        var profit = carData['profit'];

        return Scaffold(
          appBar: AppBar(
            title: Text('Car Details - ${widget.carId}'),
            backgroundColor: customTheme.primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brand: $brand',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Model: $model',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Year: $year',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Mileage: $mileage Kmpl',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Seats: $seats',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Price Per Day: Rs. $price',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Profit: Rs. $profit',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
