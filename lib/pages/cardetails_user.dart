import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
  bool booked=false;
  // final animationController = ();
  @override
  void initState() {
    super.initState();
    _carDetails = _fetchCarDetails(widget.carId);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchCarDetails(String carId) async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('cars').doc(carId).get();
    // DocumentReference docReference = documentSnapshot.reference;
    DocumentReference docRef = FirebaseFirestore.instance.collection('cars').doc(carId);

    // Retrieve the current document data
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>? ?? {};

    // Ensure the 'available_dates' field is an array
    if (data.containsKey('available_dates') && data['available_dates'] is List) {
      List<dynamic> availableDates = List.from(data['available_dates']);
      DateTime currentDate = DateTime.now();
      availableDates.removeWhere((date) {
        DateTime dateObject = DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000);
        return dateObject.isBefore(currentDate);
      });
      await docRef.update({'available_dates': availableDates});
    }
    return documentSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    Book () async{
      DocumentReference docRef = FirebaseFirestore.instance.collection('cars').doc(widget.carId);
      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>? ?? {};
      if (data.containsKey('available_dates') && data['available_dates'] is List) {
        List<dynamic> availableDates = List.from(data['available_dates']);
        DateTime currentDate = DateTime.now();
        availableDates.removeWhere((date) {
          print(date);
          return booked_dates.contains(DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000));
        });
        await docRef.update({'available_dates': availableDates});
      }
    }
    if(booked) {
      Future.delayed(Duration(seconds: 5), (){
        setState(() {
          Navigator.pop(context);
          booked=false;
        });
      });
      return Scaffold(
        body: Center(child: Lottie.network('https://lottie.host/2a7cc1b2-3098-4dae-a0e9-37f03b189677/ae3bssCiLU.json', animate: true, repeat: false)),
      );
    }
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
        // print(available_dates);
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
                      var list=<DateTime>[];
                      args.value.toList().forEach((e) {
                        // print(e);
                        list.add(e);
                      });
                      setState(() {
                        booked_dates=list;
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
                Text('Brand: $brand', style: TextStyle(fontSize: 20.0),),
                Text('Model: $model', style: TextStyle(fontSize: 20.0),),
                Text('Year : $year', style: TextStyle(fontSize: 20.0),),
                Text('Mileage : $mileage', style: TextStyle(fontSize: 20.0),),
                Text('Seats : $seats', style: TextStyle(fontSize: 20.0),),
                Text('Price Per Day : $price', style: TextStyle(fontSize: 20.0),),
                if(booked_dates.isNotEmpty) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Selected Dates: ', style: TextStyle(fontSize: 20.0),),
                ),
                ListView.builder(itemBuilder: (context, index) {return Center(child: Text(DateFormat('dd/MM/yyyy').format(booked_dates[index]), style: TextStyle(color: Colors.green, fontSize: 25.0, fontWeight: FontWeight.bold),));}, shrinkWrap: true, itemCount: booked_dates.length,),
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
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ElevatedButton(
                    onPressed: () async{
                      if(await confirm(context, content: Text("You have to pay ${booked_dates.length * price}"), title: Text('Confirm Booking'), textOK: Text('Book'))){
                        // payment done and now just book it
                        await Book();
                        print('booked');

                        setState(() {
                          booked=true;
                        });
                      }
                    },
                    child: Text('Book Now !'),
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
