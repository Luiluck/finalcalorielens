import 'dart:async';
import 'package:flutter/material.dart';
import 'LogInPage.dart';  // Import LogInPage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Fade animation value
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  // Start the splash screen animation and transition to the next screen
  void _startSplashScreen() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;  // Fade in
      });
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;  // Fade out
      });
    });

    // Transition to the LogInPage after the splash screen fades out
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LogInPage(),  // Navigate to LogInPage
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),  // Fade in/out duration
          child: Image.asset('assets/POPUP.png', width: 200),
        ),
      ),
    );
  }
}
