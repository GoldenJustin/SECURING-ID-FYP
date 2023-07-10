import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:unicard_frontend/screens/payment_screen.dart';

import '../constants/constants.dart';

class LossReportUploadPage extends StatefulWidget {
  final String studentCode;

  LossReportUploadPage({required this.studentCode});

  @override
  _LossReportUploadPageState createState() => _LossReportUploadPageState();
}

class _LossReportUploadPageState extends State<LossReportUploadPage> {
  String? _filePath;
  Future<String?>? _fetchStudentSignature;

  @override
  void initState() {
    super.initState();
    _fetchStudentSignature = fetchStudentSignature();
    _openFilePicker();
  }

  Future<String?> fetchStudentSignature() async {
    final modifiedStudentCode = widget.studentCode.replaceAll('/', '_');
    final url = Uri.parse('http://192.168.1.161:8000/universal/$modifiedStudentCode/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final studentSignature = responseData['signature'] ?? 'Unknown'; // Provide a default value
      return studentSignature;
    } else {
      throw Exception('Failed to fetch student details');
    }
  }

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_filePath == null) {
      return; // No file selected, handle error or show a message
    }

    final url = Uri.parse('http://192.168.1.161:8000/upload/${widget.studentCode.replaceAll('/', '_')}/');

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', _filePath!));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final parsedData = jsonDecode(responseData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kPaleWhiteColor,
            title: Text('Upload Status'),
            content: Text(parsedData.toString()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakePaymentPage(loggedInStudentCode: widget.studentCode),
                    ),
                  );
                },
                child: Text('Proceed with Payments'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Status'),
            content: Text('Failed to upload file'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Retry logic or show an error message
                },
                child: Text('Retry'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaleWhiteColor,
      appBar: AppBar(
        title: Text('Upload Loss Report'),
      ),
      body: FutureBuilder<String?>(
        future: _fetchStudentSignature,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to fetch student details'));
          } else {
            final studentSignature = snapshot.data ?? 'Unknown'; // Provide a default value
            return Column(
              children: [
                Container(
                  color: Colors.green[200],
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signature: $studentSignature',
                            style: TextStyle(fontSize: 19.0,
                            fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Loss Report',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _uploadFile,
                        child: Text('Upload File'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
