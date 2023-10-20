import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_car/pages/home.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'theme.dart';

class UpdateCarForm extends StatefulWidget {
  final String carId;

  UpdateCarForm({required this.carId});

  @override
  _UpdateCarFormState createState() => _UpdateCarFormState();
}

class _UpdateCarFormState extends State<UpdateCarForm> {
  List<DateTime> _selectedDate = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));

  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _seatsController = TextEditingController();
  TextEditingController _mileageController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();

  late File? selectedImage = File('');

  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchCarDetails();
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

  Future<void> _updateCarDetails() async {
    String imageUrl = _imageUrl ?? '';
    print(imageUrl);
    if (selectedImage != null && selectedImage?.path != '') {
      print("Selected image not null");
      print(selectedImage);
      imageUrl = await _uploadImage();
    }

    Map<String, dynamic> updatedData = {
      'brand': _brandController.text.isNotEmpty
          ? _brandController.text
          : _brandController.text,
      'model': _modelController.text.isNotEmpty
          ? _modelController.text
          : _modelController.text,
      'color': _colorController.text.isNotEmpty
          ? _colorController.text
          : _colorController.text,
      'year': _yearController.text.isNotEmpty
          ? int.parse(_yearController.text)
          : int.parse(_yearController.text),
      'seats': _seatsController.text.isNotEmpty
          ? int.parse(_seatsController.text)
          : int.parse(_seatsController.text),
      'mileage': _mileageController.text.isNotEmpty
          ? double.parse(_mileageController.text)
          : double.parse(_mileageController.text),
      'price_per_day': _priceController.text.isNotEmpty
          ? double.parse(_priceController.text)
          : double.parse(_priceController.text),
      'description': _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : _descriptionController.text,
      'image': imageUrl,
      'available_dates': _dateRangePickerController.selectedDates,
    };
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('cars').doc(widget.carId).update(updatedData);

    Navigator.pop(context);
  }

  Future<void> _fetchCarDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot carSnapshot =
        await firestore.collection('cars').doc(widget.carId).get();

    if (carSnapshot.exists) {
      Map<String, dynamic> carData = carSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _brandController.text = carData['brand'] ?? '';
        _modelController.text = carData['model'] ?? '';
        _colorController.text = carData['color'] ?? '';
        _yearController.text = (carData['year'] ?? '').toString();
        _seatsController.text = (carData['seats'] ?? '').toString();
        _mileageController.text = (carData['mileage'] ?? '').toString();
        _priceController.text = (carData['price_per_day'] ?? '').toString();
        _descriptionController.text = carData['description'] ?? '';
        _imageUrl = carData['image'];

        if (carData['available_dates'] != null) {
          List<Timestamp> availableDates =
              List<Timestamp>.from(carData['available_dates']);
          setState(() {
            _selectedDate =
                availableDates.map((timestamp) => timestamp.toDate()).toList();
            _dateRangePickerController.selectedDates = _selectedDate;
            _startDate = _selectedDate.first;
            _endDate = _selectedDate.last;
          });
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage
          .ref()
          .child('car_images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(selectedImage!);

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();

        setState(() {
          _imageUrl = imageUrl;
        });
      });
    } else {
      setState(() {
        selectedImage = File(_imageUrl ?? ''); 
      });
    }
  }

  void _showDatePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Date Range Picker'),
          content: Container(
            width: 300.0,
            height: 400.0,
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.multiple,
              initialSelectedRange: PickerDateRange(_startDate, _endDate),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Car Details'),
        backgroundColor: customTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                      labelText: 'Car Brand', border: OutlineInputBorder()),
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
                  decoration: InputDecoration(
                      labelText: 'Model', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _colorController,
                  decoration: InputDecoration(
                      labelText: 'Color', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _showDatePickerDialog(context),
                  child: Text('Pick Dates'),
                  style: ElevatedButton.styleFrom(backgroundColor: customTheme.primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                      labelText: 'Year', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _seatsController,
                  decoration: InputDecoration(
                      labelText: 'Seats', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _mileageController,
                  decoration: InputDecoration(
                      labelText: 'Mileage', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                      labelText: 'Price per Day', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
                style: ElevatedButton.styleFrom(backgroundColor: customTheme.primaryColor),
              ),
              SizedBox(height: 10),
              if (_imageUrl != null && Uri.parse(_imageUrl!).isAbsolute)
                Image.network(
                  _imageUrl!,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateCarDetails,
                child: Text('Update Car'),
                style: ElevatedButton.styleFrom(backgroundColor : customTheme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
