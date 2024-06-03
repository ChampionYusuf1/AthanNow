import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class Qiblapage extends StatefulWidget {
  @override
  _QiblapageState createState() => _QiblapageState();
}

class _QiblapageState extends State<Qiblapage> {
  double? _heading;

  @override
  void initState() {
    super.initState();
    _startCompass();
  }

  void _startCompass() {
    FlutterCompass.events!.listen((event) {
      setState(() {
        _heading = event.heading;
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
            : Text('Heading: ${_heading!.toStringAsFixed(2)}°'),
      ),
    );
  }
}
