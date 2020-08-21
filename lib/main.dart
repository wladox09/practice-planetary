// import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Graph',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScreenWidget(),
    );
  }
}

class ScreenWidget extends StatefulWidget {
  @override
  _ScreenWidgetState createState() => _ScreenWidgetState();
}

class _ScreenWidgetState extends State<ScreenWidget> {
  List<Body> normalBodies = [];
  Body pointInConsideration;
  int nodeActive;
  bool _dragging = false;

  bool _insideNode(double x, double y, double xPos, double yPos) {
    double distance = sqrt(pow(x - xPos, 2) + pow(y - yPos, 2));
    print(distance);
    if (distance <= 20) return true;
    return false;
  }

  void _handleLongPress(LongPressStartDetails details) {
    print(details.globalPosition);
    print('nodes:');
    for (var i = 0; i < normalBodies.length; i++) {
      var node = normalBodies[i];
      print(node.center);
      var isActive = _insideNode(node.center.dx, node.center.dy,
          details.globalPosition.dx, details.globalPosition.dy);
      if (isActive == true) {
        nodeActive = i;
        _dragging = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _handleLongPress,
      onTapUp: (event) {
        pointInConsideration = Body(event.globalPosition, Offset.zero);
        normalBodies.add(pointInConsideration);
        setState(() {});
      },
      onLongPressMoveUpdate: (event) {
        // print(nodeActive);
        if (_dragging == true && nodeActive != null) {
          // print(event.globalPosition);
          // print(normalBodies[nodeActive]);
          normalBodies[nodeActive].center = event.globalPosition;
          setState(() {});
        }
      },
      onLongPressEnd: (event) {
        // print(event.globalPosition);
        _dragging = false;
        nodeActive = null;
      },
      child: Stack(
        children: <Widget>[
          Container(
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: Painter(normalBodies),
            ),
          ),
        ],
      ),
    );
  }
}

class Body {
  Offset center;
  Offset velocity;
  double gravity;
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  Body(this.center, this.velocity, {this.gravity = 0.0});
}

class Painter extends CustomPainter {
  List<Body> normalBodies;

  Painter(this.normalBodies);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = Colors.white);

    for (var body in normalBodies) {
      canvas.drawCircle(body.center, 20.0, Paint()..color = body.color);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
