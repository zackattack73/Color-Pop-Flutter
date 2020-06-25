import 'package:flutter/material.dart';
import 'package:color_pop/game_table.dart';
import 'package:color_pop/block_table.dart';
import 'package:bot_toast/bot_toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
        child: MaterialApp(
      navigatorObservers: [BotToastNavigatorObserver()],
      home: ColorPop(),
    ));
  }
}

class ColorPop extends StatefulWidget {
  ColorPop({Key key}) : super(key: key);

  @override
  _ColorPopState createState() => _ColorPopState();
}

class _ColorPopState extends State<ColorPop> with TickerProviderStateMixin {
  GameTable gameTable;
  bool onlyOne = false;
  int milliseconds = 2000;
  int animationMilliseconds = 200;
  int animationReverseMilliseconds = 200;
  Animation<Offset> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    gameTable = GameTable(10, 10);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          gameTable.updateUI();
        });
        animationController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Center(
                child: buildGameTable(),
              ),
              new Positioned(
                child: new Align(
                    alignment: Alignment(0, 0.9),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                      onPressed: () {
                        setState(() {
                          String result = gameTable.movement();
                          result.contains("Score") ? animationController.forward() : null;
                          handlePopup(result);
                        });
                      },
                      child: Text(
                        "Valider",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0, top: 10.0),
                    )),
              ),
              new Positioned(
                  child: new Align(
                alignment: Alignment(0, -0.9),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: gameTable.gameColor,
                              shape: BoxShape.circle,
                            )),
                        Text(
                          "Score : ${gameTable.score}",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                      ],
                    )),
              ))
            ],
          )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => ColorPop());
          Navigator.pushReplacement(context, route);
        },
        child: Icon(Icons.replay),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // Debug button for animation
      /*floatingActionButton: FloatingActionButton(onPressed: () {
          switch (animationController.status) {
            case AnimationStatus.completed:
              animationController.reverse();
              break;
            case AnimationStatus.dismissed:
              animationController.forward();
              break;
            default:
          }
        },child: Icon(Icons.play_arrow),
      backgroundColor: Colors.green,)*/
    );
  }

  buildGameTable() {
    List<Widget> listCol = List();
    for (int row = 0; row < gameTable.countRow; row++) {
      List<Widget> listRow = List();
      for (int col = 0; col < gameTable.countCol; col++) {
        listRow.add(buildBlockTableContainer(row, col));
      }

      listCol.add(Row(mainAxisSize: MainAxisSize.min, children: listRow));
    }

    return Container(child: Column(mainAxisSize: MainAxisSize.min, children: listCol));
  }

  Widget buildBlockTableContainer(int row, int col) {
    BlockTable block = gameTable.getBlockTable(row, col);
    double blockSize = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height ? (MediaQuery.of(context).size.width / gameTable.countRow) : (MediaQuery.of(context).size.height / gameTable.countRow) ;
    Widget containerBackground = new GestureDetector(
        onTap: () {
          setState(() {
            gameTable.blockPressed(row, col);
          });
          print("Block pressed : ${block.row} : ${block.col}");
        },
        child: Container(
            width: blockSize,
            height: blockSize,
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(color: Colors.transparent, border: block.isSelected ? Border.all(width: 1, color: Colors.yellowAccent) : null),
            child: block.transition
                ? SlideTransition(
                    position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, block.transitionLength.toDouble())).animate(animationController),
                    child: Container(
                        width: blockSize,
                        height: blockSize,
                        margin: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: block.color,
                          shape: BoxShape.circle,
                        )))
                : Container(
                    width: blockSize,
                    height: blockSize,
                    margin: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      color: block.color,
                      shape: BoxShape.circle,
                    ))));
    return containerBackground;
  }

  handlePopup(String result) {
    BotToast.showAttachedWidget(
        target: Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2),
        attachedBuilder: (cancel) => (Card(
              color: Colors.white.withOpacity(0.8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "$result",
                          style: TextStyle(color: result.contains("Score") ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 30),
                        )
                      ],
                    )),
              ),
            )),
        onlyOne: onlyOne,
        animationDuration: Duration(milliseconds: animationMilliseconds),
        animationReverseDuration: Duration(milliseconds: animationReverseMilliseconds),
        duration: Duration(milliseconds: milliseconds));
  }
}
