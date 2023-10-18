import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
class CarDetails_User extends StatefulWidget {
  final String carId;
  CarDetails_User({required this.carId});

  @override
  State<CarDetails_User> createState() => _CarDetails_UserState();
}

class _CarDetails_UserState extends State<CarDetails_User> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _carDetails;
  var booked_dates=<DateTime>[];

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
        var available_dates=[];

        var dateController=new DateRangePickerController();
        dateController.selectedDates=booked_dates;
        carData['available_dates'].toList().forEach((e) {
          available_dates.add(DateTime.fromMillisecondsSinceEpoch(e.seconds * 1000));
        });
        print(available_dates);
        void _showDatePickerDialog(BuildContext context) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Date Range Picker'),
                content: Container(
                  width: 300.0, // Adjust the width as needed
                  height: 400.0, // Adjust the height as needed
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.multiple,
                    // backgroundColor: Colors.deepPurple.shade200,
                    todayHighlightColor: Colors.deepPurple.shade200,
                    // startRangeSelectionColor: Colors.deepPurple,
                    controller: dateController,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                      setState(() {
                        booked_dates=args.value;
                      });
                    },
                    selectableDayPredicate: (date) {
                      return available_dates.contains(date);
                    },
                    // initialSelectedRange: PickerDateRange(_startDate, _endDate),
                    // onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {_dateRangePickerController.selectedDates!.forEach((element) {print((element.year));});},
                    // controller: _dateRangePickerController,
                    // minDate: _startDate,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
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
                ListView.builder(itemBuilder: (context, index) {print(booked_dates[index]);return Center(child: Text(DateFormat('dd/MM/yyyy').format(booked_dates[index])));}, shrinkWrap: true, itemCount: booked_dates.length,),
                // ListView.builder(itemBuilder: (context, index) {
                //   return Text(DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(available_dates[index].seconds * 1000)));
                // }, itemCount: available_dates.length, shrinkWrap: true,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: ElevatedButton(
                  //   onPressed: (){
                  //
                  //   },
                  //   child: Text('select date'),
                  // )
                  child: ElevatedButton(
                    onPressed: () => _showDatePickerDialog(context),
                    child: Text('Pick Dates'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
