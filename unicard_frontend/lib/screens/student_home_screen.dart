import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unicard_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:unicard_frontend/screens/upload_loss_report_screen.dart';
import '../api/api_services.dart';
import 'card_detais.dart';
import 'login_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  // static String id = 'student_homescreen';

  var username, password, token, loggedInStudentCode;

  StudentHomeScreen({Key? key, this.username, this.password, this.token});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {


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
                                        builder: (context) => CardDetailsPage(
                                          loggedInStudentCode: widget.username,
                                        ),
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
      ),
    );
  }

  ///---- DIALOG FUNCTIONS -------

  void _request_ID_Instructions_Dialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kPaleWhiteColor,
            title: const Text('Instructions'),
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Reduce the vertical size of the column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Before requesting an ID, you have to upload a loss report and pay for New ID fees Tshs. 20000/=.',                  style: TextStyle(fontWeight: FontWeight.w600),
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
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LossReportUploadPage(
                                  studentCode: widget.username,
                                ),
                              ),
                            );
                      },
                    child: const Text('Upload'),
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
        '\n\n\n\n--------------PRINTING STUDENT CODE-------${studentCode}------------------------\n \n \n');

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

//

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
