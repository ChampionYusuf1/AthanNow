import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class Qiblapage extends StatefulWidget {
  @override
  _QiblapageState createState() => _QiblapageState();
}

class _QiblapageState extends State<Qiblapage> {
  double? _heading;
  Color example = Colors.black;

  @override
  void initState() {
    super.initState();
    _startCompass();
  }

  void _startCompass() {
    FlutterCompass.events!.listen((event) {
      setState(() {
        _heading = event.heading;
        int? test = _heading?.toInt();
        if (test != null && test != 1) {
          example = Colors.green;
        } else {
          example = Colors.black; // Set to a different color for test == 1
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compass Example'),
      ),
      body: Center(
        child: _heading == null
            ? CircularProgressIndicator()
            : Text(
                'Heading: ${_heading!.toStringAsFixed(2)}°',
                style: TextStyle(
                  color: example,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
