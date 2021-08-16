import 'dart:io';
import 'package:intl/intl.dart';
import 'package:soccer_analytics/util/player.dart';

import 'move.dart';

class Game {

  String name = "";
  List<Move> moves;
  List<Player> players;

  Game([List<Player> players, moves, name]) {
    if(name == null) {
      this.name = "${DateFormat('dd.MM.yyyy - HH.mm.ss').format(DateTime.now())} Uhr";
    } else {
      this.name = name;
    }
    if(moves == null) {
      this.moves = List<Move>();
    } else {
      this.moves = moves;
    }
    this.players = players;
  }

}