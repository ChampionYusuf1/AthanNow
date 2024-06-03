import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:athannow/commonfunctions/functins.dart'; // Ensure this function is in the correct path

class Qiblapage extends StatefulWidget {
  const Qiblapage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QiblapageState createState() => _QiblapageState();
}

// ask for user location on this page.
class _QiblapageState extends State<Qiblapage> {
  double? _heading;
  Color example = Colors.black;
  int? qibladirection;

  @override
  void initState() {
    super.initState();
    _fetchQiblaDirection();
    _startCompass();
  }

  void _startCompass() {
    FlutterCompass.events!.listen((event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
          int? test = _heading?.toInt();
          if (test != null && qibladirection != null) {
            if (test == qibladirection ||
                test == qibladirection! + 1 ||
                test == qibladirection! - 1 ||
                test == qibladirection! + 2 ||
                test == qibladirection! - 2) {
              example = Colors.green;
            } else {
              example = Colors.black;
            }
          } else {
            example = Colors.black;
          }
        });
      }
    });
  }

  void _fetchQiblaDirection() async {
    try {
      Qibladirection qiblaDirection = await fetchQiblaDirection();
      if (mounted) {
        setState(() {
          qibladirection = qiblaDirection.direction?.toInt();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          print('Error fetching Qibla direction: $e');
        });
      }
    }
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
