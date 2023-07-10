import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/constants.dart';
import 'student_home_screen.dart';

class MakePaymentPage extends StatefulWidget {
  final String loggedInStudentCode; // Student code of the logged-in user

  MakePaymentPage({Key? key, required this.loggedInStudentCode})
      : super(key: key);

  @override
  _MakePaymentPageState createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  TextEditingController _paymentAmountController = TextEditingController();

  @override
  void dispose() {
    _paymentAmountController.dispose();
    super.dispose();
  }

  void _makePayment() async {
    final paymentAmount = double.parse(_paymentAmountController.text);

    final modifiedStudentCodeInput =
        widget.loggedInStudentCode.replaceAll('/', '_');
    final url = Uri.parse(
        'http://192.168.1.161:8000/payment/$modifiedStudentCodeInput/');
    final response = await http
        .post(url, body: {'payment_amount': paymentAmount.toString()});

    final responseData = jsonDecode(response.body);
    final status = responseData['status'];
    print('Payment status: $status');

    String dialogueTitle;
    String dialogueContent;
    if (paymentAmount < 20000) {
      dialogueTitle = 'Request Received';
      dialogueContent =
          'Request received, but you will get your ID once you complete the payment';
    } else {
      dialogueTitle = 'Request Approved';
      dialogueContent =
          'Congratulations! Your request has been approved\n '
              'Please visit the offices to get your New id\n '
              'You can navigate to VIEW ID from home page';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogueTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Amount: $paymentAmount'),
              SizedBox(height: 8.0),
              Text(dialogueContent),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Go Home'),
              onPressed: () {
                // Perform action when "Go Home" button is pressed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentHomeScreen(
                      username: widget.loggedInStudentCode,
                      password: '', // Add the password if needed
                      token: '', // Add the token if needed
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );

    // Handle the payment status response or perform any necessary actions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaleWhiteColor,
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Payment Amount:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _paymentAmountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _makePayment,
                child: Text('Make Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
