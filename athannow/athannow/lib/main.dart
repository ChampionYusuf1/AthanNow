import 'package:flutter/material.dart';
import 'package:athannow/pages/intialpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AthanNow'),
        ),
        body: const InitialPage(),
      ),
    );
  }
}
