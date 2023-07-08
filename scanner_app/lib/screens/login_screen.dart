import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scanner_app/api/api_services.dart';
import 'package:scanner_app/constants/constants.dart';
import 'package:scanner_app/screens/staff_home_screen.dart';
import 'package:scanner_app/screens/student_home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GetStartedScreen extends StatefulWidget {
  static String id = '/getStartedScreen';

  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  ApiServices? apiServices;
  bool obsecureText = true;

  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    apiServices = ApiServices();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 20, 20, 22),
                    radius: 80,
                    child: Image.asset('images/Qr_id.png'),
                  ),
                ),
                Text(
                  'Login',
                  style: kLargeTextStyle.copyWith(color: kGreenColor),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: const TextStyle(color: kGreenColor),
                          controller: userNameController,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Username Field must not be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_2_rounded,
                              color: kGreenColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: const BorderSide(
                                  width: 3, color: kGreenColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 5.0,
                                  style: BorderStyle.solid,
                                  strokeAlign: BorderSide.strokeAlignInside),
                            ),
                            hintText: 'Enter username',
                            hintStyle: const TextStyle(color: kGreenColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: const TextStyle(color: kGreenColor),
                          controller: userPasswordController,
                          obscureText: obsecureText,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Password Field must not be empty';
                            } else if (input.length < 3) {
                              return 'Password must be of 8 or more digits';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock_outline_sharp,
                              color: kGreenColor,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  obsecureText = !obsecureText;
                                });
                              },
                              child: obsecureText
                                  ? const Icon(
                                Icons.visibility_off,
                                color: kGreenColor,
                              )
                                  : const Icon(
                                Icons.visibility,
                                color: kGreenColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: const BorderSide(
                                  width: 3, color: kGreenColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: const BorderSide(
                                  width: 5.0,
                                  style: BorderStyle.solid,
                                  strokeAlign: BorderSide.strokeAlignInside),
                            ),
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(color: kGreenColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: MaterialButton(
                          elevation: 5,
                          color: Colors.green,
                          height: 50,
                          minWidth: 500,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          onPressed: () {
                            if (_validate()) {
                              _submit();
                            }
                          },
                          child: const Text(
                            'Login',
                            style:
                            TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
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

  bool _validate() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  void _submit() async {
    var data = {
      'username': userNameController.text,
      'password': userPasswordController.text,
    };

    var res =
    await apiServices?.authenticationPostRequest(data, '/user/login/');

    if (res != null) {
      var body = json.decode(res.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = body['token'];
      String role = body['role'];

      await prefs.setString('token', token);
      await prefs.setString('role', role);

      _navigateToHomeScreen(role);
    }
  }

  void _navigateToHomeScreen(String role) {
    if (role == 'student') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentHomeScreen(),
        ),
      );
    } else if (role == 'staff') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StaffHomeScreen(),
        ),
      );
    }
  }
}

