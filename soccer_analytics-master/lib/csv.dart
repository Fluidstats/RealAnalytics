import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soccer_analytics/util/game.dart';
import 'package:soccer_analytics/util/move.dart';
import 'package:soccer_analytics/util/player.dart';

class CSV {

  String filePath;
  String name;

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/$name.csv';
    return File('$path/$name.csv').create();
  }

  Future<File> get _oldFile async {
    final path = await _localPath;
    filePath = '$path/$name.csv';
    return File('$path/$name.csv');
  }

  Future<String> get _path async {
    final path = await _localPath;
    filePath = '$path/$name.csv';
    return filePath;
  }

  Future<String> getCSV(Game game) async {
    name = game.name;
    return _path;
  }

  getMovesCSV(Game game) async {
    List<List<dynamic>> csvRaw = List();

    game.moves.forEach((element) {
      csvRaw.add([
        element.playerStart == null ? "" : (element.playerStart.shirtNumber ??= ""),
        element.playerStart == null ? "" : (element.playerStart.playerName ??= ""),
        element.playerEnd == null ? "" : (element.playerEnd.shirtNumber ??= ""),
        element.playerEnd == null ? "" : (element.playerEnd.playerName ??= ""),
        element.longPass ? "Ja" : "Nein",
        getFinishes(element.finish),
      ]);
    });

    return csvRaw;
  }

  getGameCSV(Game game) async {
    List<List<dynamic>> csvPlayer = List();
    List<List<dynamic>> csvMoves;
    List<List<dynamic>> csvFin = List();

    game.players.forEach((element) {
      csvPlayer.add([
        "${element.shirtNumber}",
        "${element.playerName}",
        "${element.posTop}",
        "${element.posLeft}",
        "${element.sizeH}",
        "${element.sizeW}",
        "${element.isActive}",
      ]);
    });

    csvMoves = await getMovesCSV(game);

    csvPlayer.add(null); // SPLIT-Indicator
    csvFin.addAll(csvPlayer);
    csvFin.addAll(csvMoves);

    name = game.name;

    File f = await _localFile;

    String csv = const ListToCsvConverter().convert(csvFin);
    f.writeAsString(csv);

  }

  rename(String oldName, String newName) async {

    name = oldName;
    File f = await _oldFile;
    name = newName;
    f.rename(await _path);

  }

  remove(Game game) async {

    name = game.name;
    File f = await _oldFile;
    f.delete();

  }

  getFinishes(Finish finish) {
    switch (finish) {
      case Finish.MISDIRECTED_PASS:
        return "Fehlpass";
        break;
      case Finish.SUCCESSFUL_PASS:
        return "Erfolgreich";
        break;
      case Finish.ONTARGET_SHOT:
        return "Torschuss";
        break;
      case Finish.INTERCEPTION:
        return "Interception";
        break;
    }
  }

  setFinishes(String finish) {
    switch (finish) {
      case "Fehlpass":
        return Finish.MISDIRECTED_PASS;
        break;
      case "Erfolgreich":
        return Finish.SUCCESSFUL_PASS;
        break;
      case "Torschuss":
        return Finish.ONTARGET_SHOT;
        break;
      case "Interception":
        return Finish.INTERCEPTION;
        break;
    }
  }


  Future<List<Game>>getGames() async {
    List<Game> games = List<Game>();
    List dir;

    final directory = (await getApplicationSupportDirectory()).path;
    dir = Directory(directory).listSync();

    for(var element in dir) {
      List playerAsList = List();
      List<Player> playerAsPlayer = List<Player>();
      List movesAsList = List();
      List<Move> movesAsMove = List<Move>();
      int split;
      var fields = await getFields(element);
      fields.forEach((element) {
        if(element.toString() == "[]") {
          split = fields.indexOf(element);
        }
      });
      playerAsList.addAll(fields.sublist(0, split));
      playerAsList.forEach((element) {
        playerAsPlayer.add(Player(
          element[0].toString(),
          element[1],
          element[2] as double,
          element[3] as double,
          element[4] as double,
          element[5] as double,
          element[6] == "true" ? true : false,
        ));
      });

      movesAsList.addAll(fields.sublist(split + 1, fields.length));
      movesAsList.forEach((element) {
        movesAsMove.add(Move.fromSave(
          element[0],
          element[1],
          element[2],
          element[3],
          element[4] == "Ja" ? true : false,
          setFinishes(element[5]),
        ));
      });

      games.add(Game(
        playerAsPlayer,
        movesAsMove,
        element.path.split("/").last.substring(0, element.path.split("/").last.length - 4),
      ));

    }

    return games;
  }

  Future<dynamic> getFields(element) async {
    final input = File(element.path).openRead();
    return (await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList());
  }

  share(Game game) async {
    int split;

    name = game.name;
    File old = await _oldFile;
    final input = old.openRead();
    var list = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    list.forEach((element) {
      if(element.toString() == "[]") {
        split = list.indexOf(element);
      }
    });

    list = list.sublist(split + 1, list.length);
    list.insert(0, ["Nr. Start", "Spieler Start", "Nr. Ende", "Spieler End", "Langer Pass", "Finish"]);

    name = "Meine Analyse - $name";
    File f = await _localFile;
    String csv = const ListToCsvConverter().convert(list);
    f.writeAsString(csv);

    return filePath;
  }

}