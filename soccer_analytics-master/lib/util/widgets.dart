import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soccer_analytics/res/icons.dart';
import 'game.dart';

class Widgets {

  Widget noGamesYet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Icon(CuIcons.soccer_ball, size: 48, color: Colors.grey,),
          ),
          Text(
            "Es wurden noch keine Spiele angelegt!",
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey
            ),
          ),
          Container(
            height: 96,
          )
        ],
      ),
    );
  }

}