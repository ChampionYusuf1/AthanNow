import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:athannow/commonfunctions/functins.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500)); // Adding a delay
      requestLocationPermissionAndLogCoordinates(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Static Text',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter text',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Some Text',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
