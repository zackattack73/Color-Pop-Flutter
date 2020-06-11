import 'package:flutter/material.dart';

class Animate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimationPage(),
    );
  }
}

class AnimationPage extends StatefulWidget {
  AnimationPage({Key key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  Animation<Offset> animation;
  AnimationController animationController;

  double blockSize = 100;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1)).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black,
          child: Center(
              child: Column(
            children: <Widget>[
              Container(
                  width: blockSize,
                  height: blockSize,
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(color: Colors.transparent),
                  child: SlideTransition(
                      position: animation,
                      child: new Container(
                          width: blockSize,
                          height: blockSize,
                          margin: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          )))),
              Container(
                  width: blockSize,
                  height: blockSize,
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(color: Colors.transparent),
                  child: SlideTransition(
                      position: animation,
                      child: Container(
                          width: blockSize,
                          height: blockSize,
                          margin: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          )))),
              Container(
                  width: blockSize,
                  height: blockSize,
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(color: Colors.transparent),
                  child: Container(
                      width: blockSize,
                      height: blockSize,
                      margin: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      )))
            ],
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switch (animationController.status) {
            case AnimationStatus.completed:
              animationController.reverse();
              break;
            case AnimationStatus.dismissed:
              animationController.forward();
              break;
            default:
          }
        },
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.green,
      ),
    );
  }
}
