import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/constants.dart';

class CardDetailsPage extends StatefulWidget {
  final String loggedInStudentCode; // Student code of the logged-in user

  CardDetailsPage({Key? key, required this.loggedInStudentCode}) : super(key: key);

  @override
  _CardDetailsPageState createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  String programme = '';
  String name = '';
  String studentCode = '';
  String signature = '';
  String expDate = '';
  String photo = '';
  String qrcode = '';
  String payment = '';
  var modifiedStudentCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCardDetails();
  }

  Future<void> fetchCardDetails() async {
    setState(() {
      modifiedStudentCode = widget.loggedInStudentCode.replaceAll('/', '_');
    });

    final url = Uri.parse(
        'http://192.168.1.161:8000/cardDetails/$modifiedStudentCode/');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(
          '==============data coming===========================\n\n\n\n${response
              .body}\n\n\n\n===================end of coming data====================');
      if (responseData != null) {
        setState(() {
          programme = responseData['programme'];
          name = responseData['name'];
          studentCode = responseData['student_code'];
          signature = responseData['signature'];
          expDate = responseData['exp_date'];
          photo = responseData['avatar_url'];
          qrcode = responseData['qrcode_url'];
          payment = responseData['payment_status'];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed');
    }
  }

  Widget buildCardDetails() {
    if (isLoading) {
      return AlertDialog(
        title: Text('Payment Required'),
        content: Text('Please make the payment to view the card details.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    } else if(programme.isNotEmpty &&
        name.isNotEmpty &&
        studentCode.isNotEmpty &&
        signature.isNotEmpty &&
        expDate.isNotEmpty &&
        photo.isNotEmpty &&
        qrcode.isNotEmpty) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text(
                        'NATIONAL INSTITUTE OF TRANSPORT \n\nSTUDENT IDENTITY CARD',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Image.network(
                        photo,
                        scale: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Programme:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            programme,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Name:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            name,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Student Code:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            studentCode,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Signature:',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    signature,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    'Expiration Date:',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    expDate,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.network(
                                  qrcode,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text('Failed'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPaleWhiteColor,
        appBar: AppBar(
          title: const Text(
            'YOUR CARD',
            style: TextStyle(),
          ),
        ),
        body: buildCardDetails(),
      ),
    );
  }
}
