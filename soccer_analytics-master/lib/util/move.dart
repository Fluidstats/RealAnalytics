import 'package:flutter/cupertino.dart';
import 'package:soccer_analytics/util/player.dart';

class Move {

  Player playerStart;
  Player playerEnd;
  bool longPass;
  Finish finish;

  Move({this.playerStart, this.playerEnd, this.longPass, this.finish});

  Move.fromSave(startNr, startName, endNr, endName, langerPass, finish) {
    this.playerStart = Player(startNr.toString(), startName);
    this.playerEnd = Player(endNr.toString(), endName);
    this.longPass = langerPass;
    this.finish = finish;
  }

}

enum Finish {

  MISDIRECTED_PASS,
  SUCCESSFUL_PASS,
  ONTARGET_SHOT,
  INTERCEPTION,

}