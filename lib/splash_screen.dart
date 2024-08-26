import 'dart:async';

import 'package:akib_pos/features/auth/presentation/pages/auth_page.dart';
import 'package:akib_pos/features/home/home_screen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      // TODO: Check Authenticated User
      if (mounted) {
        Navigator.pushReplacement(
          context,
          // MaterialPageRoute(builder: (context) => HomeScreen()),
          MaterialPageRoute(builder: (context) => AuthPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width  = MediaQuery.of(context).size.width;
    double height  = MediaQuery.of(context).size.height;
    bool isPortrait = false;
    if(height > width) isPortrait = true;

    return Scaffold(
      body: Container(
        width: double.infinity,
          child: Image.asset('assets/identity/splash_screen.png', fit: isPortrait ? BoxFit.cover : BoxFit.fitWidth,)
      ),
    );
  }
}