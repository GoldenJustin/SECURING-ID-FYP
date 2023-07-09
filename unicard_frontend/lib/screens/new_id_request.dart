import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewIDRequestPage extends StatefulWidget {
  final String studentCode;

  NewIDRequestPage({required this.studentCode});

  @override
  _NewIDRequestPageState createState() => _NewIDRequestPageState();
}

class _NewIDRequestPageState extends State<NewIDRequestPage> {
  String message = '';

  Future<void> sendNewIDRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final modifiedStudentCode = widget.studentCode.replaceAll('/', '_');
    final url = 'http://192.168.1.161:8000/api/new-id-request/$modifiedStudentCode/';

    try {
      final response = await http.get(
        Uri.parse(Uri.encodeFull(url)), // Add Uri.encodeFull() to handle special characters in the URL
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          message = 'ID request sent successfully.';
        });
        // Perform any additional actions based on the response if needed
      } else {
        setState(() {
          message = 'Failed to send ID request.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New ID Request'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: sendNewIDRequest,
              child: Text('Send New ID Request'),
            ),
            SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
