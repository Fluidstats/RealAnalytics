import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:soccer_analytics/csv.dart';
import 'package:soccer_analytics/newGame.dart';
import 'package:soccer_analytics/play.dart';
import 'package:soccer_analytics/res/icons.dart';
import 'package:soccer_analytics/splashscreen.dart';
import 'package:soccer_analytics/util/game.dart';
import 'package:soccer_analytics/util/widgets.dart';
import 'package:soccer_analytics/util/player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer Analytics',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/': {
            return MaterialPageRoute(builder: (context) => MySplashScreen());
          }
          case '/ListGames': {
            return MaterialPageRoute(builder: (context) => ListGames());
          }
          case '/NewGame': {
            return MaterialPageRoute(builder: (context) => NewGame());
          }
          case '/Play': {
            final Game game = settings.arguments;
            return MaterialPageRoute(builder: (context) => Play(game: game,));
          }
          default: return null;
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class ListGames extends StatefulWidget {
  @override
  _ListGamesState createState() => _ListGamesState();
}

class _ListGamesState extends State<ListGames> {

  List<Game> games = List<Game>();

  _addGame() async {

    dynamic players = await Navigator.pushNamed(context, '/NewGame');

    if(players != null) {
      setState(() {
        games.add(Game(players));
      });
      Navigator.pushNamed(context, "/Play", arguments: games.last).then((value) => {
        setState(() {
          games.last.name += " ";
          games.last.name = games.last.name.substring(0, games.last.name.length - 1);
        }),
        CSV().getGameCSV(games.last),
      });

    }

  }

  Widget buildList(List<Game> games) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(height: 0),
        itemCount: games.length,
        itemBuilder: (context, i) {
          return buildTiles(context, games[i]);
        }
    );
  }

  Future<dynamic> getCache() async {
    var temp = await CSV().getGames();
    return temp;
  }

  @override
  void initState() {
    super.initState();
    getCache().then((value) => {
      initGames(value),
    });
  }

  initGames(value) {
    setState(() {
      games = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer Analytics"),
      ),
      body: games.length > 0 ? buildList(games) : Widgets().noGamesYet(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Neues Spiel',
        child: Icon(Icons.add),
        onPressed:  _addGame,
      ),
    );
  }

  Widget buildTiles(BuildContext context, Game game) {
    return ListTile(
      leading: IconButton(icon: Icon(Icons.play_arrow), onPressed: () {
        Navigator.pushNamed(context, "/Play", arguments: game).then((value) {
          setState(() {
            game.name += " ";
            game.name = game.name.substring(0, game.name.length - 1);
          });
          CSV().getGameCSV(game);
        });
      }),
      title: Text(game.name),
      subtitle: Text("Züge: ${game.moves.length}"),
      trailing: PopupMenuButton<int>(
        tooltip: 'Zeige Menü',
        onSelected: (value) {
          switch (value) {
            case 1: {
              _showRename(game);
              break;
            }
            case 2: {
              _share(game);
              break;
            }
            case 3: {
              _showDelete(game);
              break;
            }
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Platform.isIOS ? Icon(CupertinoIcons.pen) : Icon(Icons.edit),
                  ),
                  Text('Umbenennen'),
                ],
              )
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Platform.isIOS ? Icon(CupertinoIcons.share_solid) : Icon(Icons.share),
                ),
                Text('Teilen'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Platform.isIOS ? Icon(CupertinoIcons.delete) : Icon(Icons.delete),
                ),
                Text('Löschen'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showDelete(Game game) {
    Widget saveButton = FlatButton(
      child: Text("Löschen"),
      onPressed: () {
        CSV().remove(game);
        setState(() {
          games.removeAt(games.indexOf(game));
        });
        Navigator.pop(context);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Abbruch"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Löschen"),
      content: Text(
        "Soll dieses Spiel wirklich dauerhaft gelöscht werden?",
      ),
      actions: [
        cancelButton,
        saveButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showRename(Game game) {
    final _formKey = GlobalKey<FormState>();
    final validChars = RegExp(r'^[0-9a-zA-Z_\-. ]+$');
    Widget saveButton = FlatButton(
      child: Text("Speichern"),
      onPressed: () {
        if(_formKey.currentState.validate()) {
          _formKey.currentState.save();
          Navigator.pop(context);
        }
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Abbruch"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Umbenennen"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: game.name,
          maxLines: 1,
          validator: (value) {
            if (!validChars.hasMatch(value)) {
              return 'Bitte keine Sonderzeichen verwenden';
            }
            if (games.any((element) => element.name == value)) {
              return 'Dieser Name existiert schon';
            }
            return null;
          },
          onSaved: (String value) {
            CSV().rename(game.name, value);
            setState(() {
              game.name = value;
            });
          },
        ),
      ),
      actions: [
        cancelButton,
        saveButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _share(Game game) async {
    String path = await CSV().share(game);
    Share.shareFiles([path]).then((value) => {
      File(path).delete(),
    });
  }

}
