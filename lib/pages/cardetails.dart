import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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

        // Now you have the carData, you can use it to display details
        // For example, to display brand and model:
        var brand = carData['brand'];
        var model = carData['model'];
        var year = carData['year'];
        var mileage = carData['mileage'];
        var seats = carData['seats'];
        var price = carData['price_per_day'];
        var profit = carData['profit'];
        // print(carData['available_dates'].toList().forEach((e){print(DateTime.fromMillisecondsSinceEpoch(e.seconds * 1000, isUtc: true)
        // );}));
        // print(carData['available_dates'].toList().length);
        return Scaffold(
          appBar: AppBar(
            title: Text('Car Details - ${widget.carId}'),
          ),
          // body: ListView.builder(itemBuilder: (context, index){return Te}, itemCount: 5,),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Brand: $brand'),
                Text('Model: $model'),
                Text('Year : $year'),
                Text('Mileage : $mileage'),
                Text('Seats : $seats'),
                Text('Price Per Day : $price'),
                Text('Profit: $profit'),
              ],
            ),
          ),
        );
      },
    );
  }
}
