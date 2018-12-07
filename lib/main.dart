import 'package:flutter/material.dart';
import 'FancyFab.dart';

void main() => runApp(MaterialApp(home: MyApp()));
List<Offset> _points = <Offset>[];
var color = Colors.red;
class MyApp extends StatelessWidget {
  final ChildCallback mChildCallBack;

  MyApp({this.mChildCallBack});

  Widget floatingButton;
  Signature _signature = new Signature();

  Widget build(BuildContext context) {
    Widget fancyFab = FancyFab(
      onPressed: (int type) {
        switch(type){
          case 0:
            _points.removeLast();
            _signature._signatureState = new SignatureState();
            break;
          case 1:
            _points.clear();
            _signature._signatureState = new SignatureState();
            break;
          case 2:
            color = Colors.blue;
            _signature._signatureState = new SignatureState();
            break;
        }
      },
      icon: Icons.details,
    );

    return Scaffold(body: _signature, floatingActionButton: fancyFab);
  }
}

class Signature extends StatefulWidget {
  SignatureState _signatureState = new SignatureState();

  SignatureState createState() => _signatureState;
}

class SignatureState extends State<Signature> {
  SignaturePainter _signaturePainter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject();
          Offset localPosition =
              renderBox.localToGlobal(details.globalPosition);
          _points = List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: CustomPaint(
        painter: _signaturePainter = SignaturePainter(_points),
        size: Size.infinite,
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;


  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}
