import 'package:flutter/material.dart';
import 'package:unicard_frontend/constants/constants.dart';
import 'package:unicard_frontend/screens/login_screen.dart';
import 'package:unicard_frontend/screens/staff_home_screen.dart';
import 'package:unicard_frontend/screens/student_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIT e-Card',
      theme: ThemeData(

        scaffoldBackgroundColor: kBlackColor,
        primarySwatch: Colors.green
      ),
      initialRoute: GetStartedScreen.id,
      routes: {
        GetStartedScreen.id: (context) => const GetStartedScreen(),
        // StudentHomeScreen.id: (context) => const StudentHomeScreen(),
        // StaffHomeScreen.id: (context)=> StaffHomeScreen()
      },
    );
  }
}

