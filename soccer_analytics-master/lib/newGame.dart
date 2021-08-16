import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:soccer_analytics/util/player.dart';

class NewGame extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {

  var lastKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  List<Player> player = List<Player>.generate(1, (index) => Player());
  List<bool> _validiate = List.generate(1, (index) => true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Neues Spiel anlegen"),
        actions: [
          FlatButton(
            child: Text(
              "Speichern",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              player.forEach((element) {
                if(element.playerName == "" || element.shirtNumber == "") {
                  setState(() {
                    _validiate[player.indexOf(element)] = false;
                  });
                } else {
                  setState(() {
                    _validiate[player.indexOf(element)] = true;
                  });
                }
              });
              if(_validiate.every((element) => element == true)) {
                Navigator.pop(context, player);
              }
            },
          ),
        ],
      ),
      body: buildList(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Spieler hinzufügen",
        onPressed: () {
          lastKey = GlobalKey();
          setState(() {
            _validiate.add(true);
            player.add(Player());
          });
          SchedulerBinding.instance.addPostFrameCallback((_) => scrollToEnd());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void scrollToEnd() async {
    await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut);
    Scrollable.ensureVisible(lastKey.currentContext);
  }

  Widget buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: player.length,
      itemBuilder: (context, i) {
        return buildTiles(player.indexOf(player[i]));
      }
    );
  }

  Widget buildTiles(int i) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          player.removeAt(i);
          _validiate.removeAt(i);
          player.forEach((element) {
            if(element.playerName == "" || element.shirtNumber == "") {
              setState(() {
                _validiate[player.indexOf(element)] = false;
              });
            } else {
              setState(() {
                _validiate[player.indexOf(element)] = true;
              });
            }
          });
        });
      },
      background: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
      ),
      child: Card(
        color: _validiate[i] ? Colors.white : Color(0xffff4d4d),
        child: ListTile(
          key: i == player.length - 1 ? lastKey : null,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Spieler ${i+1}:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 60),
                      child: TextFormField(
                        autofocus: i == player.length - 1 ? true : false,
                        onChanged: (shirtNumber) {
                          player[i].shirtNumber = shirtNumber;
                        },
                        initialValue: player[i].shirtNumber,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Nr.",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          counterText: "",
                        ),
                      ),
                    ),
                    Container(width: 20),
                    Container(
                      width: 160,
                      child: TextFormField(
                        onChanged: (playerName) {
                          player[i].playerName = playerName;
                        },
                        initialValue: player[i].playerName,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
