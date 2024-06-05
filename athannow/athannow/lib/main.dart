import 'package:flutter/material.dart';
import 'package:athannow/pages/intialpage.dart';
import 'package:athannow/pages/athantimings.dart';
import 'package:athannow/commonfunctions/functins.dart'; // Ensure this function is in the correct path

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkApiUrl() async {
    return await checkapiurl(); // This function checks if the API URL is stored
  }

  @override
  Widget build(BuildContext context) {
    //  removealldata();
    return MaterialApp(
      title: 'Athan Now',
      home: FutureBuilder<bool>(
        future: checkApiUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return AthanTimingsPage();
          } else {
            return InitialPage();
          }
        },
      ),
    );
  }
}
