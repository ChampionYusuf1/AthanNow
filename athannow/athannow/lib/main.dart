import 'package:flutter/material.dart';
import 'package:athannow/pages/intialpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //testinggrabbingsharedpref();
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: InitialPage(),
      ),
    );
  }
}

/**
 * 
 * void testinggrabbingsharedpref() async {
  final prefs = await SharedPreferences.getInstance();
  final String? text = prefs.getString('testtext');
  print("MAin function grabbing text value");
  print(text);
}

 */

