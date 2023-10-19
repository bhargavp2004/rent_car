import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_car/pages/addpost.dart';
import 'package:rent_car/pages/cargriditem_user.dart';
import 'package:rent_car/pages/login.dart';
import 'package:rent_car/pages/login_user.dart';
import 'package:rent_car/pages/myposts.dart';
import 'package:rent_car/pages/filter.dart' as Filter_Posts;
import 'theme.dart';
import 'cargridpage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:quantupi/quantupi.dart';

class MyHomePage_User extends StatefulWidget {
  @override
  State<MyHomePage_User> createState() => _MyHomePage_UserState();
}

class _MyHomePage_UserState extends State<MyHomePage_User> {
  // bool isFilter=false;
  // FilterObj filterObj=new FilterObj();
  var buttonColor = customTheme.primaryColor;
  @override
  Widget build(BuildContext context) {
    var filter=Map<String, dynamic>();
    if(ModalRoute.of(context)?.settings.arguments != null){
      filter=ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    }
    // print(filter);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200,
        title: Text('Flutter UI Example'),
        actions: [
          IconButton(onPressed: (){setState(() {Navigator.push(context, CupertinoPageRoute(builder: (context) => Filter_Posts.Filter()));});}, icon: Icon(Icons.filter_alt_rounded, size: 30,)),
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut().then((c){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage_User()));
              });
            },
            icon: Icon(Icons.logout_rounded, size: 30,))
        ],
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var carDocsinit = snapshot.data?.docs;
          var carDocs = filter.isNotEmpty ? carDocsinit?.where((element) {
            final data=element.data();
            final seats = data['seats'] ?? 0;
            final price = data['price_per_day'] ?? 0;
            final available_dates=<Timestamp>[];
            filter?['dates']?.toList().forEach((e){
              available_dates.add(Timestamp.fromDate(e));
            });
            var data_available_dates=<dynamic>[];
            if(data['available_dates']!=null)
              data_available_dates = data['available_dates'] as List<dynamic>;
            // print(data['available_dates']?.toList().contains(available_dates));
            bool flag=false;
            return price<=filter['budget'] && seats>=filter['seats'] && available_dates.every((element) => data_available_dates.contains(element));
          }).toList() : carDocsinit;
          // print(carDocs);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: carDocs?.length,
            itemBuilder: (context, index) {
              if (carDocs != null) {
                var carData = carDocs[index].data() as Map<String, dynamic>;
                // print(carData);
                var imagePath = carData['image'] as String?;
                var carId = carDocs[index].id;

                if (imagePath != null && imagePath.isNotEmpty) {
                  print("Inside IF");
                  var brand = carData['brand'] as String;
                  var model = carData['model'] as String;
                  return CarGridItem_User(
                    carId: carId,
                    brand: brand,
                    model: model,
                    imageURL: imagePath,
                    filter: filter
                  );
                } else {
                  // Handle the case where imagePath is null or empty
                  return Card(
                    child: Center(
                      child: Text(
                        'Invalid Image',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
              }
              // Handle the case where carDocs is null or empty
              return Container();
            },
          );
        },
      ),
      // body: Container(
      //   // Set background color to blue
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         StreamBuilder(
      //           stream:
      //               FirebaseFirestore.instance.collection('cars').snapshots(),
      //           builder: (context, snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return Center(child: CircularProgressIndicator());
      //             }

      //             if (snapshot.hasError) {
      //               return Center(child: Text('Error: ${snapshot.error}'));
      //             }

      //             var carDocs = snapshot.data?.docs;
      //             // print(carDocs);
      //             return GridView.builder(
      //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 2,
      //                 childAspectRatio: 0.7,
      //               ),
      //               itemCount: carDocs?.length,
      //               itemBuilder: (context, index) {
      //                 if (carDocs != null) {
      //                   var carData =
      //                       carDocs[index].data() as Map<String, dynamic>;
      //                   print(carData);
      //                   var imagePath = carData['image'] as String?;
      //                   var carId = carDocs[index].id;

      //                   if (imagePath != null && imagePath.isNotEmpty) {
      //                     print("Inside IF");
      //                     var brand = carData['brand'] as String;
      //                     var model = carData['model'] as String;
      //                     return CarGridItem(
      //                       carId: carId,
      //                       brand: brand,
      //                       model: model,
      //                       imageURL: imagePath,
      //                     );
      //                   } else {
      //                     // Handle the case where imagePath is null or empty
      //                     return Card(
      //                       child: Center(
      //                         child: Text(
      //                           'Invalid Image',
      //                           style: TextStyle(color: Colors.red),
      //                         ),
      //                       ),
      //                     );
      //                   }
      //                 }
      //                 // Handle the case where carDocs is null or empty
      //                 return Container();
      //               },
      //             );
      //           },
      //         ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     Navigator.push(context,
      //         //         MaterialPageRoute(builder: (context) => CarGridPage()));
      //         //   },
      //         //   child: Text('View My Posts'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     Navigator.push(context,
      //         //         MaterialPageRoute(builder: (context) => AddPost()));
      //         //   },
      //         //   child: Text('Add Post'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     // Add your action for "Delete Post" here
      //         //   },
      //         //   child: Text('Delete Post'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     // Add your action for "Update Post" here
      //         //   },
      //         //   child: Text('Update Post'),
      //         //   style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         // ),
      //         ElevatedButton(
      //           onPressed: () {
      //             // Add your action for "logout" here
      //             FirebaseAuth.instance.signOut();
      //             Navigator.push(context,
      //                 MaterialPageRoute(builder: (context) => SignInPage()));
      //           },
      //           child: Text('logout'),
      //           style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

// class UpiPay extends StatefulWidget {
//   const UpiPay({Key? key}) : super(key: key);
//
//   @override
//   State<UpiPay> createState() => _UpiPayState();
// }
//
// class _UpiPayState extends State<UpiPay> {
//   String data = 'Testing plugin';
//
//   String appname = paymentappoptions[0];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<String> initiateTransaction({QuantUPIPaymentApps? app}) async {
//     Quantupi upi = Quantupi(
//       receiverUpiId: 'msjsci2021ema210@okaxis',
//       receiverName: 'kevan',
//       transactionNote: 'Not actual. Just an example.',
//       amount: 10,
//       appname: app,
//     );
//     String response = await upi.startTransaction();
//
//     return response;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isios = !kIsWeb && Platform.isIOS;
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               if (isios)
//                 DropdownButton<String>(
//                   value: appname,
//                   icon: const Icon(Icons.arrow_drop_down),
//                   iconSize: 24,
//                   elevation: 16,
//                   underline: Container(
//                     height: 0,
//                     // color: ,
//                   ),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       appname = newValue!;
//                     });
//                   },
//                   items: paymentappoptions
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                         child: Center(
//                           child: Text(
//                             value,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               if (isios) const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   String value = await initiateTransaction(
//                     app: isios ? appoptiontoenum(appname) : null,
//                   );
//                   setState(() {
//                     data = value;
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 15,
//                   ),
//                 ),
//                 child: const Text(
//                   "Tap to pay",
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   data,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   QuantUPIPaymentApps appoptiontoenum(String appname) {
//     switch (appname) {
//       case 'Amazon Pay':
//         return QuantUPIPaymentApps.amazonpay;
//       case 'BHIMUPI':
//         return QuantUPIPaymentApps.bhimupi;
//       case 'Google Pay':
//         return QuantUPIPaymentApps.googlepay;
//       case 'Mi Pay':
//         return QuantUPIPaymentApps.mipay;
//       case 'Mobikwik':
//         return QuantUPIPaymentApps.mobikwik;
//       case 'Airtel Thanks':
//         return QuantUPIPaymentApps.myairtelupi;
//       case 'Paytm':
//         return QuantUPIPaymentApps.paytm;
//
//       case 'PhonePe':
//         return QuantUPIPaymentApps.phonepe;
//       case 'SBI PAY':
//         return QuantUPIPaymentApps.sbiupi;
//       default:
//         return QuantUPIPaymentApps.googlepay;
//     }
//   }
// }
//
// const List<String> paymentappoptions = [
//   'Amazon Pay',
//   'BHIMUPI',
//   'Google Pay',
//   'Mi Pay',
//   'Mobikwik',
//   'Airtel Thanks',
//   'Paytm',
//   'PhonePe',
//   'SBI PAY',
// ];