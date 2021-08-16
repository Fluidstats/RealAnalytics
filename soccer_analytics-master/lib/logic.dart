import 'package:soccer_analytics/util/game.dart';
import 'package:soccer_analytics/util/move.dart';
import 'package:soccer_analytics/util/player.dart';

class Logic {

  returnStartPlayer(Game game) {
    if(game.moves.isNotEmpty && game.moves.last.finish == Finish.SUCCESSFUL_PASS) {
      return game.moves.last.playerEnd;
    } else {
      return null;
    }
  }

  handelPlayerTap(Game game, Player player, bool langerBall) {
    if(game.moves.isEmpty || (game.moves.isNotEmpty && player != game.moves.last.playerEnd)) {
      game.moves.add(Move(
        playerStart: returnStartPlayer(game),
        playerEnd: player,
        longPass: langerBall,
        finish: Finish.SUCCESSFUL_PASS,
      ));
    }
  }

  handleFehlpass(Game game, bool langerBall) {
    return {
      game.moves.add(Move(
        playerStart: returnStartPlayer(game),
        longPass: langerBall,
        finish: Finish.MISDIRECTED_PASS,
      ))
    };
  }

  handleTorschuss(Game game, bool langerBall) {
    return {
      game.moves.add(Move(
        playerStart: returnStartPlayer(game),
        longPass: langerBall,
        finish: Finish.ONTARGET_SHOT,
      ))
    };
  }

  handleInterception(Game game, bool langerBall) {
    return {
      game.moves.add(Move(
        playerStart: returnStartPlayer(game),
        longPass: langerBall,
        finish: Finish.INTERCEPTION,
      ))
    };
  }





}