import 'package:flutter/material.dart';
import 'package:secure_id_app/constants/constants.dart';

class StudentHomeScreen extends StatelessWidget {
  // static String id = 'student_homescreen';

  String? username, password, token;

  StudentHomeScreen({this.username, this.password, this.token});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$username',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kBlackColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
                                  _view_ID_Dialog(context);
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
                                  _request_ID_Instructions(context);
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
