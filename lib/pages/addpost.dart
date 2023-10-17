import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_car/pages/home.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var imgurl = null;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // You can adjust the duration
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _mileageController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateRangePickerController _dateRangePickerController = DateRangePickerController();
  late File? selectedImage = File('');

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    File? imageToUpload = selectedImage;

    if (imageToUpload != null) {
      final FirebaseStorage storage = FirebaseStorage.instance;
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          UniqueKey().toString();
      final Reference ref = storage.ref().child(imageFileName);
      final UploadTask uploadTask = ref.putFile(imageToUpload);

      try {
        await uploadTask;
        String imageURL = await ref.getDownloadURL();
        print('Image URL: $imageURL');
        return imageURL;
      } catch (e) {
        print('Failed to upload image: $e');
        return '';
      }
    } else {
      return '';
    }
  }

  Future<void> _saveCarData() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      String imageURL = await _uploadImage();

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference cars = firestore.collection('cars');
      try {
        await cars.add({
          'brand': _brandController.text,
          'model': _modelController.text,
          'color': _colorController.text,
          'year': int.parse(_yearController.text),
          'seats': int.parse(_seatsController.text),
          'mileage': double.parse(_mileageController.text),
          'price_per_day': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'image': imageURL,
          'owner': FirebaseAuth.instance.currentUser!.uid,
          'available_dates': _dateRangePickerController.selectedDates,
        });
        showSnackbar("Car Added Successfully");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } catch (err) {
        showSnackbar('$err');
      }

      _formKey.currentState?.reset();
      setState(() {
        selectedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> _selectedDate = [];
    DateTime _startDate = DateTime.now();
    DateTime _endDate = DateTime.now().add(Duration(days: 30));

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
                initialSelectedRange: PickerDateRange(_startDate, _endDate),
                // onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {_dateRangePickerController.selectedDates!.forEach((element) {print((element.year));});},
                controller: _dateRangePickerController,
                minDate: _startDate,
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

    // DateTime? selectedDate;
    // selectDate() async{
    //   final DateTime? picked = await showDatePicker(
    //     context: context,
    //     initialDate: selectedDate ?? DateTime.now(),
    //     firstDate: DateTime(2000),
    //     lastDate: DateTime(2101),
    //   );

    //   if (picked != null && picked != selectedDate) {
    //     setState(() {
    //       selectedDate = picked;
    //     });
    //   }
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(labelText: 'Car Brand',border: OutlineInputBorder()),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return 'Please enter the car brand';
                      }
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(labelText: 'Model',border: OutlineInputBorder()),
                ),
              ),
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Year',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _colorController,
                  decoration: InputDecoration(labelText: 'Color',border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _seatsController,
                  decoration: InputDecoration(labelText: 'Seats',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _mileageController,
                  decoration: InputDecoration(labelText: 'Mileage',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price per Day',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description',border: OutlineInputBorder()),
                  maxLines: 3,
                ),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 10),
              if (selectedImage!.path.isNotEmpty)
                Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCarData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
