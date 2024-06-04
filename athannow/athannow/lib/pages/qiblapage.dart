import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:athannow/commonfunctions/functins.dart'; // Ensure this function is in the correct path

class Qiblapage extends StatefulWidget {
  const Qiblapage({super.key});

  @override
  _QiblapageState createState() => _QiblapageState();
}

class _QiblapageState extends State<Qiblapage> {
  double? _heading;
  int? qibladirection;
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    requestLocationPermissionAndLogCoordinates(context).then((_) {
      _fetchQiblaDirection();
      _startCompass();
    });
  }

  void _startCompass() {
    FlutterCompass.events!.listen((event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
          _updateBackgroundColor();
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
          _updateBackgroundColor();
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

  void _updateBackgroundColor() {
    if (_heading != null && qibladirection != null) {
      int? test = _heading?.toInt();
      if (test != null &&
          (test >= qibladirection! - 4 && test <= qibladirection! + 4)) {
        backgroundColor = Colors.green;
      } else {
        backgroundColor = Colors.white;
      }
    } else {
      backgroundColor = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass Example'),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: backgroundColor,
        child: Center(
          child: _heading == null || qibladirection == null
              ? const CircularProgressIndicator()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    // Kaaba image
                    Image.asset(
                      'assets/kaaba.png',
                      height: 50,
                      width: 50,
                    ),
                    // Rotating arrow

                    Transform.rotate(
                      angle: ((_heading! - qibladirection!) *
                          (3.141592653589793 / 180)),
                      child: Image.asset(
                        'assets/arrow.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
