import 'dart:async';

import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/presentation/pages/auth_page.dart';
import 'package:akib_pos/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuthStatus();
  }

  void _navigateBasedOnAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    bool isLoggedIn = _authSharedPref.isLoggedIn();

    if (mounted) {
      print("loginkahh${_authSharedPref.isLoggedIn()}");
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait = height > width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Image.asset(
          !isPortrait ? 'assets/identity/splash_screen.png'  :'assets/identity/splash_screen_portrait.png',
          fit: isPortrait ? BoxFit.cover : BoxFit.cover,
        ),
      ),
    );
  }
}