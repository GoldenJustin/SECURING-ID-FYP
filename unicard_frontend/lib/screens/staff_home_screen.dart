import 'package:flutter/material.dart';
import 'package:unicard_frontend/constants/constants.dart';
import 'package:unicard_frontend/screens/login_screen.dart';
import 'package:unicard_frontend/screens/qr_code_scanner.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StaffHomeScreen extends StatefulWidget {
  static String id = 'staff_homescreen';
  var username, password, token;

   StaffHomeScreen({Key? key, this.username, this.password, this.token}) : super(key: key);

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {

 Future<void> _back() async {
    await _logout();
    Navigator.pushReplacementNamed(context, GetStartedScreen.id);
 }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlackColor,
          elevation: 0,
          leading: IconButton(
            onPressed: _back,
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),

                ///The Logo
                Center(
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 20, 20, 22),
                    radius: 75,
                    child: Image.asset('images/Qr_id.png'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                ///The Container Card
                Container(
                    width: 300,
                    height: 240,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(67, 81, 79, 86),
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 81, 79, 86),
                          // blurRadius: 1,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                         Text(
                          'Staff ${widget.username}',
                          style: TextStyle(fontSize: 23, color: kPaleWhiteColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 23),
                          child: Text(
                              'This postal helps you to verify students by securing their QR code. Tap to scan!',
                              style: TextStyle(fontSize: 20, color: kPaleWhiteColor)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CircleAvatar(
                          radius: 35,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QRCodeScannerPage(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 58,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'NIT',
                        style: kLargeTextStyle.copyWith(color: kGreenColor),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'SECURED',
                        style: kMediumTextStyle.copyWith(color: kGreenColor),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        'ID CARD',
                        style: kMediumTextStyle.copyWith(
                            color: kPaleWhiteColor, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _view_ID_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('Identity Card'),
            content: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'Front Side',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'Back Side',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Perform printing action
                  Navigator.pop(context);
                },
                child: const Text('Print'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Perform cancel action
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  void _request_ID_Instructions(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Instructions'),
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Reduce the vertical size of the column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Here are steps to follow:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('1. You should purchase control number for loss report.'),
                SizedBox(
                  height: 10,
                ),
                Text('2. Upload a loss report.'),
                SizedBox(
                  height: 10,
                ),
                Text('3. Pay control number for new ID.'),
              ],
            ),
            actions: [
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Perform next action
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Perform cancel action
                      Navigator.pop(context);
                      _control_Number_Dialog(context);
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void _control_Number_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Control Number'),
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Reduce the vertical size of the column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Your control number is  B11122. Pay 10,000/= to get loss report',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ],
            ),
            actions: [
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Perform next action
                      Navigator.pop(context);
                      _request_ID_Instructions(context);
                    },
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Perform cancel action
                      Navigator.pop(context);
                      _control_Number_Payment_Dialog(context);
                    },
                    child: const Text('Pay'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void _control_Number_Payment_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Control Number Payment'),
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Reduce the vertical size of the column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Payment Successful! \n \nYour Registration Number is: \n NIT/BIT/2020/1214 \n\nPlease visit the registration office to pick up your hard copy ID',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ],
            ),
            actions: [
              ButtonBar(
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Perform next action
                  //     Navigator.pop(context);
                  //     _request_ID_Instructions(context);
                  //   },
                  //   child: const Text('Back'),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      // Perform cancel action
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Future<void> _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  final response = await http.post(
    Uri.parse('http://192.168.1.161:8000/user/logout/'),
    body: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData['status']);

    await prefs.remove('token');
    await prefs.remove('role');

    // Perform any necessary navigation or screen updates after logout
  } else {
    print('Logout failed. Status code: ${response.statusCode}');
  }
}