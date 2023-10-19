import 'package:flutter/material.dart';
import 'package:rent_car/pages/home_user.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  var _budget=500.0;
  var _seats=2.0;
  var _mileage=0.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _mileageController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  DateRangePickerController _dateRangePickerController = DateRangePickerController();
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
              // initialSelectedRange: PickerDateRange(_startDate, _endDate),
              // onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {_dateRangePickerController.selectedDates!.forEach((element) {print((element.year));});},
              controller: _dateRangePickerController,
              minDate: DateTime.now(),
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
  @override
  Widget build(BuildContext context) {
    _mileageController.value=TextEditingValue(text: '0');
    return Scaffold(
      appBar: AppBar(
        title: Text('filter'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
              children: [
              //   Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: _seatsController,
              //     decoration: InputDecoration(labelText: 'minimum required seats',border: OutlineInputBorder()),
              //     validator: (value) {
              //       if (value != null) {
              //         if (value.isEmpty) {
              //           return 'Please enter the car brand';
              //         }
              //       }
              //       return null;
              //     },
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: _priceController,
              //     decoration: InputDecoration(labelText: 'budget',border: OutlineInputBorder()),
              //   ),
              // ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10.0,
                  trackShape: RoundedRectSliderTrackShape(),
                  activeTrackColor: Colors.green.shade800,
                  inactiveTrackColor: Colors.green.shade100,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 14.0,
                    pressedElevation: 8.0,
                  ),
                  thumbColor: Colors.green,
                  overlayColor: Colors.green.withOpacity(0.2),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.greenAccent,
                  inactiveTickMarkColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.black,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text('seats: ${_seats.round()}', style: TextStyle(fontSize: 20),),
                    Slider(
                      min: 2.0,
                      max: 12.0,
                      value: _seats,
                      divisions: 12,
                      label: '${_seats.round()}',
                      onChanged: (value) {
                        setState(() {
                          _seats = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10.0,
                  trackShape: RoundedRectSliderTrackShape(),
                  activeTrackColor: Colors.red.shade800,
                  inactiveTrackColor: Colors.red.shade100,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 14.0,
                    pressedElevation: 8.0,
                  ),
                  thumbColor: Colors.blue,
                  overlayColor: Colors.blue.withOpacity(0.2),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.blue,
                  inactiveTickMarkColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.black,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text('budget: ${_budget.round()}', style: TextStyle(fontSize: 20),),
                    Slider(
                      min: 500.0,
                      max: 10000.0,
                      value: _budget,
                      // divisions: 12,
                      label: '${_budget.round()}',
                      onChanged: (value) {
                        setState(() {
                          _budget = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10.0,
                  trackShape: RoundedRectSliderTrackShape(),
                  activeTrackColor: Colors.purple.shade800,
                  inactiveTrackColor: Colors.purple.shade100,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 14.0,
                    pressedElevation: 8.0,
                  ),
                  thumbColor: Colors.pinkAccent,
                  overlayColor: Colors.pink.withOpacity(0.2),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.pinkAccent,
                  inactiveTickMarkColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.black,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text('mileage: $_mileage', style: TextStyle(fontSize: 20),),
                    Slider(
                      min: 0.0,
                      max: 12.0,
                      value: _mileage,
                      divisions: 12,
                      label: '${_mileage.round()}',
                      onChanged: (value) {
                        setState(() {
                          _mileage = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: _mileageController,
              //     decoration: InputDecoration(labelText: 'minimum mileage required',border: OutlineInputBorder()),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // child: ElevatedButton(
                //   onPressed: (){
                //
                //   },
                //   child: Text('select date'),
                // )
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.redAccent),
                  ),
                  onPressed: () => _showDatePickerDialog(context),
                  child: Text('Pick Dates', style: TextStyle(fontSize: 25.0),),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                  ),
                  onPressed: (){Navigator.popUntil(context, (route) => route.isFirst); Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage_User(), settings: RouteSettings(
                    arguments: {
                      "budget": _budget,
                      "mileage": _mileage,
                      "seats": _seats,
                      'dates': _dateRangePickerController.selectedDates,
                    }
                  )));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Filter Posts...', style: TextStyle(fontSize: 25.0),),
                      Icon(Icons.filter_alt_rounded, size: 30.0,),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: _,
              //     decoration: InputDecoration(labelText: 'Model',border: OutlineInputBorder()),
              //   ),
              // ),
            ],
          )
        )
      )
    );
  }
}
