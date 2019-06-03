import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animation/src/widgets/cat.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    catAnimation = Tween(begin: -30.0, end: -150.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );

    boxController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    boxAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(CurvedAnimation(
      parent: boxController,
      curve: Curves.easeIn,
    ));

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation!'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          left: 20.0,
          right: 20.0,
          top: catAnimation.value,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return AnimatedBuilder(
      animation: boxAnimation,
      builder: (context, child) {
        return Positioned(
          left: 3.0,
          child: Transform.rotate(
            child: Container(
              height: 10.0,
              width: 100.0,
              color: Colors.brown,
            ),
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
          ),
        );
      },
    );
  }

  Widget buildRightFlap() {
    return AnimatedBuilder(
      animation: boxAnimation,
      builder: (context, child) {
        return Positioned(
          right: 3.0,
          child: Transform.rotate(
            child: Container(
              height: 10.0,
              width: 100.0,
              color: Colors.brown,
            ),
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
          ),
        );
      },
    );
  }
}
