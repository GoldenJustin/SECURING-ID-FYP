import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:secure_id_app/api/api_services.dart';
import 'package:secure_id_app/constants/constants.dart';
import 'package:secure_id_app/screens/staff_home_screen.dart';
import 'package:secure_id_app/screens/student_home_screen.dart';

class GetStartedScreen extends StatefulWidget {
  static String id = '/getStartedScreen';

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
    // TODO: implement initState
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
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      ///Username Textfield
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

                      ///Password Textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: const TextStyle(color: kGreenColor),
                          controller: userPasswordController,
                          obscureText: obsecureText,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Password Field must not be empty';
                            } else if (input.length < 3)
                              return 'Password must be of 8 or more digit';
                            else
                              return null;
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
                                      )),
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

                      ///Button to login
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
                            ;

                            // Navigator.pushNamed(context, StudentHomeScreen.id);
                            // Navigator.pushNamed(context, StaffHomeScreen.id);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                // Icon(Icons.app_registration, size: 45, color: Colors.white,),
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
      'password': userPasswordController.text
    };

    var res = await ApiServices().authenticationPostRequest(data, '/user/login/');

    if (res != null) {
      var body = json.decode(res.body);

      print('--------------------BODY----------------------------');
      print(body);
      print('--------------------BODY----------------------------');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => StudentHomeScreen(
                  username: body['username'],
                  password: body['password'],
                  token: body['token'])));
    }
  }
}
