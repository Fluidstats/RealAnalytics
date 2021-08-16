

class Player {

  String shirtNumber;
  String playerName;
  double posTop;
  double posLeft;
  double sizeH;
  double sizeW;
  bool isActive;

  Player([this.shirtNumber = "", this.playerName = "", this.posTop = 0, this.posLeft = 0, this.sizeH, this.sizeW, this.isActive = false]);

  bool isEmpty() {

    return (shirtNumber == "" && playerName == "");

  }



}