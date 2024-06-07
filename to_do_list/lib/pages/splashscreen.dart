import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_list/pages/weather_login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    splashscreenStart();
  }

  splashscreenStart() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WeatherPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo_Swhite2.png',
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff003940), Color(0xff005b66)],
          stops: [0.25, 0.75],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )),
      ),
    );
  }
}
