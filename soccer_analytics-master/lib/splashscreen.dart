import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soccer_analytics/main.dart';
import 'package:soccer_analytics/res/colors.dart';
import 'package:soccer_analytics/res/icons.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {

    Navigator.popAndPushNamed(context, '/ListGames');

  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(CuIcons.soccer_ball, size: 96, color: Colors.black.withOpacity(1),),
                    Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Text(
                        'Soccer Analytics',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}