import 'dart:async';  // Corrected import statement

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/HomeScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homescreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/splash_pic.jpg',
                fit: BoxFit.cover,
                width: width * 0.9,
                height: height * 0.5,
              ),
              SizedBox(height: height * 0.04),
              Text(
                'TOP HEADLINES',
                style: GoogleFonts.anton(
                  letterSpacing: 0.6,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: height * 0.04),
              SpinKitSpinningLines(
                color: Colors.blueAccent,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
