import 'package:flutter/material.dart';
import 'package:secure_id_app/constants/constants.dart';
import 'package:secure_id_app/screens/login_screen.dart';
import 'package:secure_id_app/screens/staff_home_screen.dart';
import 'package:secure_id_app/screens/student_home_screen.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(

        scaffoldBackgroundColor: kBlackColor,
        primarySwatch: Colors.green
      ),
      initialRoute: GetStartedScreen.id,
      routes: {
        GetStartedScreen.id: (context) => GetStartedScreen(),
        // StudentHomeScreen.id: (context) => const StudentHomeScreen(),
        StaffHomeScreen.id: (context)=> const StaffHomeScreen()
      },
    );
  }
}

