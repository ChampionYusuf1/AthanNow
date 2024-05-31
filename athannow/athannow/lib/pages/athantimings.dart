import 'package:flutter/material.dart';
import 'package:athannow/commonfunctions/functins.dart';

class AthanTimingsPage extends StatefulWidget {
  @override
  _AthanTimingsPageState createState() => _AthanTimingsPageState();
}

class _AthanTimingsPageState extends State<AthanTimingsPage> {
  late Future<NamazTimings> futureNamazTimings;

  @override
  void initState() {
    super.initState();
    futureNamazTimings = fetchNamazTimings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Athan Timings'),
      ),
      body: Center(
        child: FutureBuilder<NamazTimings>(
          future: futureNamazTimings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No data found');
            } else {
              final namazTimings = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    _buildTableRow('Prayer', 'Time', isHeader: true),
                    _buildTableRow('Fajr', namazTimings.fajr ?? ''),
                    _buildTableRow('Dhuhr', namazTimings.dhuhr ?? ''),
                    _buildTableRow('Asr', namazTimings.asr ?? ''),
                    _buildTableRow('Maghrib', namazTimings.maghrib ?? ''),
                    _buildTableRow('Isha', namazTimings.isha ?? ''),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  TableRow _buildTableRow(String name, String time, {bool isHeader = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.black : Colors.grey[700],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.black : Colors.grey[700],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
