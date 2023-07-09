import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unicard_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api_services.dart';
import 'card_detais.dart';
import 'login_screen.dart';
import 'new_id_request.dart';

class StudentHomeScreen extends StatefulWidget {
  // static String id = 'student_homescreen';

  var username, password, token;

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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CardDetailsPage(loggedInStudentCode: widget.username,),
                                      ),
                                    );
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
                                    // _request_ID_Instructions_Dialog(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewIDRequestPage(studentCode: '',),
                                      ),
                                    );
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
      ),
    );
  }

  ///---- DIALOG FUNCTIONS -------

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
                Text('1. You should purchase control number for loss report.'
                    '\n2. Upload a loss report.'
                    '\n3. Pay control number for new ID.'
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

