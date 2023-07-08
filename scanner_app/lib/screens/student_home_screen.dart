import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scanner_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api_services.dart';
import 'login_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  // static String id = 'student_homescreen';

  String? username, password, token;

  StudentHomeScreen({this.username, this.password, this.token});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool isFrontSide = true;

  Future<void> _back() async {
    await _logout();
    Navigator.pushReplacementNamed(context, GetStartedScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.username}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kBlackColor,
          elevation: 0,
          leading: IconButton(
            onPressed: _back,
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ),
        body: Center(
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
                  radius: 80,
                  child: Image.asset('images/Qr_id.png'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              ///The Container Card
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 81, 79, 86),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 81, 79, 86),
                      // blurRadius: 1,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              radius: 40,
                              child: GestureDetector(
                                onTap: () {
                                  fetchStudentInfo(context);
                                  // _view_ID_Dialog(context);
                                },
                                child: const Icon(
                                  Icons.visibility,
                                  size: 50,
                                  color: kBlackColor,
                                ),
                              ),
                            )),
                        const Text(
                          'View ID',
                          style: TextStyle(
                              color: kPaleWhiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              child: GestureDetector(
                                onTap: () {
                                  print('=====REQUESTING ID=====');
                                  _request_ID_Instructions_Dialog(context);
                                },
                                child: const Icon(
                                  Icons.add_card,
                                  size: 50,
                                  color: kBlackColor,
                                ),
                              ),
                              radius: 40,
                            )),
                        const Text(
                          'Reques ID',
                          style: TextStyle(
                              color: kPaleWhiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                ),
              ),
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
    );
  }

  ///---- DIALOG FUNCTIONS -------

  void _view_ID_Dialog(BuildContext context, var student_credentials) {
    isFrontSide == true
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // title: Text('Identity Card'),
                content: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      // color: Colors.black,
                      child: Center(
                        child: Column(children: [
                          OurIdText(
                            title: 'NATIONAL INSTITUTE OF TRANSPORT',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OurIdText(
                            title: 'STUDENT IDENTITY CARD',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'images/IMG-20221231-WA0009_1.jpg',
                            scale: 3,
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 250,
                      // color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OurIdText(
                            title: 'Programme:',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          OurIdText(
                            title: '${student_credentials['programme']}',
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OurIdText(
                            title: 'Name:',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          OurIdText(
                            title: '${student_credentials['name']}',
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OurIdText(
                            title: 'Registration Number:',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          OurIdText(
                            title: '${student_credentials['student_code']}',
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OurIdText(
                            title: 'Signature:',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          OurIdText(
                            title: '${student_credentials['signature']}',
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OurIdText(
                            title: 'Exp_Date:',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          OurIdText(
                            title: '${student_credentials['exp_date']}',
                            textAlign: TextAlign.start,
                            color: Colors.pinkAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (isFrontSide == true) {
                        isFrontSide = !isFrontSide;
                        print('???????????????????? $isFrontSide ?????????');

                        setState(() {
                          Navigator.pop(context);
                          _view_ID_Dialog(context, outside_boy);
                        });
                      }
                    },
                    child: const Text('View Back'),
                  ),
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
            })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // title: Text('Identity Card'),
                content: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      // color: Colors.black,
                      child: Center(
                        child: Column(children: [
                          OurIdText(
                            title: 'National Institute of Transport',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OurIdText(
                            title: 'Official Student Identification',
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Image.asset(
                              'images/qr_code_demo.jpeg',
                              scale: 1.2,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: 250,
                      // color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OurIdText(
                              title:
                                  '1. This is an institute property and not transferable',
                              textAlign: TextAlign.start,
                              fontsize: 12),
                          SizedBox(
                            height: 7,
                          ),
                          OurIdText(
                              title:
                                  '2. Use of this card is subject to the cardholder agreement',
                              textAlign: TextAlign.start,
                              fontsize: 12),
                          SizedBox(
                            height: 7,
                          ),
                          OurIdText(
                              title:
                                  '3. For lost or stolen card report to the nearest police station',
                              textAlign: TextAlign.start,
                              fontsize: 12),
                          SizedBox(
                            height: 7,
                          ),
                          OurIdText(
                              title:
                                  '4. This card must be returned to the Dean Office on terminating the course',
                              textAlign: TextAlign.start,
                              fontsize: 12),
                          SizedBox(
                            height: 7,
                          ),
                          OurIdText(
                              title:
                                  '5. This card must be worn at all official times',
                              textAlign: TextAlign.start,
                              fontsize: 12),
                          SizedBox(
                            height: 7,
                          ),
                          OurIdText(
                              title: '  Contact',
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
                              fontsize: 12),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OurIdText(
                                  title:
                                      'Rector \nP.O Box 705. Dar es Salaam \nTell.(255)2222400846 \nEmail: rector@nit.ac.tz \nWebsite: www.nit.ac.tz',
                                  textAlign: TextAlign.start,
                                  fontsize: 10.6,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  OurIdText(
                                      title: '________________',
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 10),
                                  OurIdText(
                                      title: 'Rector Signature',
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 10),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (isFrontSide == false) {
                        isFrontSide = !isFrontSide;
                        print('???????????????????? $isFrontSide ?????????');

                        setState(() {
                          Navigator.pop(context);
                          _view_ID_Dialog(context, outside_boy);
                          // _request_ID_Instructions_Dialog(context);
                        });
                      }
                    },
                    child: const Text('View Front'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Perform printing action
                      // Navigator.pop(context);
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

  void _request_ID_Instructions_Dialog(BuildContext context) {
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
                      _request_ID_Instructions_Dialog(context);
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

  var outside_boy;

  ///FUNCTIONS CALLING API
  void fetchStudentInfo(BuildContext context) async {
    String studentCode = '${widget.username!.replaceAll('/', '_')}';
    print(
        '----------------------PRINTING STUDENT CODE-------------------------------\n \n \n');
    print('${studentCode}');
    print(
        '\n \n \n--------------------------------------------------------------------');

    var res = await ApiServices()
        .authenticatedGetRequest('/cardDetails/$studentCode/');

    var body = jsonDecode(res.body);
    print(
        '----------------------PRINTING BODY CONTENTS-------------------------------\n \n \n');
    print('${body.toString()}');

    print(
        '\n \n \n -----------------------------------------------------------------');
    outside_boy = body;
    _view_ID_Dialog(context, body);
  }
}

class OurIdText extends StatelessWidget {
  String? title;
  double? fontsize;
  TextAlign? textAlign;
  FontWeight? fontWeight;
  Color? color;

  OurIdText({
    required this.title,
    this.fontsize,
    this.textAlign,
    this.fontWeight,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$title",
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
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

