import 'dart:io';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soccer_analytics/logic.dart';
import 'package:soccer_analytics/util/player.dart';
import 'package:soccer_analytics/util/game.dart';

class Play extends StatefulWidget {

  final Game game;
  const Play ({ Key key, this.game }): super(key: key);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {

  final String torbereich = 'assets/16er.svg';
  final String mittelfeldring = 'assets/mittelfeldring.svg';
  List<bool> _langerBall = [false];
  List<GlobalKey> _keysOfPlayers;
  GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight;
  double _appStatusBarSize;
  bool _editingMode = false;

  _afterLayout(_) {
    _appStatusBarSize = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

    var _sizeTemp = _bottomBarKey.currentContext.findRenderObject() as RenderBox;
    _bottomBarHeight = _sizeTemp.size.height;

    if(!widget.game.players.every((element) => element.sizeW != null && element.sizeH != null)) {
      widget.game.players.forEach((element) {
        var _sizeTemp = _keysOfPlayers[widget.game.players.indexOf(element)].currentContext.findRenderObject() as RenderBox;
        element.sizeH = _sizeTemp.size.height;
        element.sizeW = _sizeTemp.size.width;
      });
    }

    if(widget.game.players.every((element) => element.posLeft == 0 && element.posTop == 0)) {
      _organizePlayerWidgets();
    }

  }

  _organizePlayerWidgets() {
    List<Size> posPos = List<Size>();
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 4, (MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 2));

    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 3, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 4 * 2) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 8)));
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 3, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 4 * 3) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 8)));
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 3, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 4 * 1) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 8)));
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 3, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 4 * 4) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 8)));

    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 2, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 3 * 2) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 6)));
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 2, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 3 * 1) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 6)));
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 2, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 3 * 3) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 6)));

    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 1, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 3 * 2) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 6)));
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 1, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 3 * 1) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 6)));
    posPos.add(Size(MediaQuery.of(context).size.width / 4 * 1, ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 3 * 3) - ((MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 90) / 6)));
    
    
    widget.game.players.forEach((element) {
      if(widget.game.players.length > posPos.length) {
        int wechselspielerPlaetze = widget.game.players.length - posPos.length;
        for(int j = 0; j < wechselspielerPlaetze; j++) {
          switch (j % 3) {
            case 0:
              posPos.add(Size(MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 8, MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 45));
              break;
            case 1:
              posPos.add(Size(MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 8 - 100, MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 45));
              break;
            case 2:
              posPos.add(Size(MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 8 + 100, MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - 45));
              break;
          }
        }
      }

      setState(() {
        element.posTop = posPos[widget.game.players.indexOf(element)].height - element.sizeH / 2; // element.sizeH / 2 ===> to center anchorpoint
        element.posLeft = posPos[widget.game.players.indexOf(element)].width - (MediaQuery.of(context).size.width / 8) - element.sizeW / 2; // element.sizeW / 2 ===> to center anchorpoint
      });

    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keysOfPlayers = List.generate(widget.game.players.length, (index) => GlobalKey());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: Platform.isIOS ? true : false,
        title: Text("${widget.game.name}"),
        backgroundColor: _editingMode ? Theme.of(context).primaryColor.withOpacity(0.5) : Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: _editingMode ? Icon(Icons.check) : Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _editingMode = !_editingMode;
              });
            }
          ),
        ],
      ),
      body: _content(),
    );
  }

  _content() {
    return Column(
      children: [
        Expanded(
          child: _stack(),
        ),
        _bottomBar(),
      ],
    );
  }

  _stack() {
    return Stack(
      children: [
        Container(color: Colors.green),
        _field(),
        _player(),
      ],
    );
  }

  _player() {
      List<Widget> _playerWidgets = List.generate(widget.game.players.length, (index) => _playerDraggable(widget.game.players[index]));
      return Container(
        child: Stack(
          children: _playerWidgets,
        ),
      );
  }

  _field() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  mittelfeldring,
                  height: MediaQuery.of(context).size.height / 7.5,
                ),
                SvgPicture.asset(
                  torbereich,
                  height: MediaQuery.of(context).size.height / 3 ,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              width: 300,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 4, color: Colors.white),
                  right: BorderSide(width: 4, color: Colors.white),
                  top: BorderSide(width: 4, color: Colors.white),
                ),
              ),
              child: Center(
                child: Text(
                  "Auswechselbank",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomBar() {
    return Align(
      child: Container(
        key: _bottomBarKey,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]
        ),
        height: 80,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            _flatButton("Fehlpass", _editingMode || widget.game.moves.isEmpty || Logic().returnStartPlayer(widget.game) == null ? null : () {
              Logic().handleFehlpass(widget.game, _isLangerBall());
              _clearUp();
            }),
            _flatButton("Torschuss", _editingMode || widget.game.moves.isEmpty || Logic().returnStartPlayer(widget.game) == null ? null : () {
              Logic().handleTorschuss(widget.game, _isLangerBall());
              _clearUp();
            }),
            _flatButton("Interception", _editingMode || widget.game.moves.isEmpty || Logic().returnStartPlayer(widget.game) == null ? null : () {
              Logic().handleInterception(widget.game, _isLangerBall());
              _clearUp();
            }),
            ToggleButtons(
              fillColor: Theme.of(context).primaryColor,
              renderBorder: false,
              selectedColor: Colors.white,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 80,
                  child: Center(
                    child: Text(
                      "Langer Ball",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              isSelected: _langerBall,
              onPressed: _editingMode || widget.game.moves.isEmpty ? null : (i) => {
              setState(() {
               _langerBall[i] = !_langerBall[i];
              }),
              },
            )
          ],
        )
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  _isLangerBall() {
    bool temp = _langerBall[0];
    setState(() {
      _langerBall[0] = false;
    });
    return temp;
  }

  _flatButton(name, function()) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: 80,
      child: FlatButton(
        child: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        onPressed: function,
      ),
    );
  }

  _clearUp() {
    setState(() {
      widget.game.players.forEach((element) {element.isActive = false;});
    });
  }

  _playerDraggable(Player player) {
    return Draggable(
        key: _keysOfPlayers[widget.game.players.indexOf(player)],
        maxSimultaneousDrags: _editingMode ? 1 : 0,
        child: Container(
          padding: EdgeInsets.only(top: player.posTop, left: player.posLeft),
          child: _playerButtons(player),
        ),
        feedback: Container(
          padding: EdgeInsets.only(top: player.posTop, left: player.posLeft),
          child: _playerButtons(player),
        ),
        childWhenDragging: Container(
          padding: EdgeInsets.only(top: player.posTop, left: player.posLeft),
          child: Container(),
        ),
        onDragEnd: (drag) {
          setState(() {
            if(player.posTop + drag.offset.dy < _appStatusBarSize) {
              player.posTop = 0;
            } else if (player.posTop + drag.offset.dy > MediaQuery.of(context).size.height - _bottomBarHeight - player.sizeH) {
              player.posTop = MediaQuery.of(context).size.height - _appStatusBarSize - _bottomBarHeight - player.sizeH;
            } else {
              player.posTop = player.posTop + drag.offset.dy - _appStatusBarSize;
            }
            if(player.posLeft + drag.offset.dx < 0) {
              player.posLeft = 0;
            } else if (player.posLeft + drag.offset.dx > MediaQuery.of(context).size.width - player.sizeW) {
              player.posLeft = MediaQuery.of(context).size.width - player.sizeW;
            } else {
              player.posLeft = player.posLeft + drag.offset.dx;
            }
          });
        },
    );
  }

  _playerButtons(Player player) {
    return ShakeAnimatedWidget(
      enabled: _editingMode,
      duration: Duration(milliseconds: 200),
      shakeAngle: Rotation.deg(z: 3),
      child: GestureDetector(
        onTap: _editingMode ? null : () {
          Logic().handelPlayerTap(widget.game, player, _isLangerBall());
          _clearUp();
          setState(() {
            player.isActive = true;
          });
        },
        child: Container(
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: player.isActive ? Colors.red : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                      )
                    ],
                  ),
                  child: Center(
                      child: Text(
                        player.shirtNumber,
                        style: TextStyle(
                            fontSize: 16,
                            color: player.isActive ? Colors.white : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Color(0xfff2f2f2),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      player.playerName,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
