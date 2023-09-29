import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_car/pages/home.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Car Brand'),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return 'Please enter the car brand';
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Model'),
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
              TextFormField(
                controller: _seatsController,
                decoration: InputDecoration(labelText: 'Seats'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Mileage'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price per Day'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 10),
              if (selectedImage != null)
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
