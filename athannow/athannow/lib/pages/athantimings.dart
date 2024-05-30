// athan_timings_page.dart
import 'package:flutter/material.dart';
import 'package:athannow/commonfunctions/functins.dart';

class AthanTimingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    calculateprayertimings();
    return Scaffold(
      appBar: AppBar(
        title: Text('Athan Timings'),
      ),
      body: const Center(
        child: Text('This is the Athan Timings page!'),
      ),
    );
  }
}
