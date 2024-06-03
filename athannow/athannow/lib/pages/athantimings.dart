import 'package:flutter/material.dart';
import 'package:athannow/commonfunctions/functins.dart';
import 'package:athannow/pages/intialpage.dart';
import 'package:athannow/commonfunctions/hadith_dialog.dart'; // Import the Hadith dialog
import 'package:athannow/pages/qiblapage.dart';

class AthanTimingsPage extends StatefulWidget {
  @override
  _AthanTimingsPageState createState() => _AthanTimingsPageState();
}

class _AthanTimingsPageState extends State<AthanTimingsPage> {
  late Future<NamazTimings> futureNamazTimings;
  late Future<Hadiths> futureHadith;

  @override
  void initState() {
    super.initState();
    futureNamazTimings = fetchNamazTimings();
    futureHadith = fetchHadith();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AthanNow'),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 1, 20, 1),
        child: FutureBuilder<NamazTimings>(
          future: futureNamazTimings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found'));
            } else {
              final namazTimings = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Prayer Timings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      _buildTableRow('Prayer', 'Time', isHeader: true),
                      _buildTableRow('Fajr', namazTimings.fajr!),
                      _buildTableRow('Dhuhr', namazTimings.dhuhr!),
                      _buildTableRow('Asr', namazTimings.asr!),
                      _buildTableRow('Maghrib', namazTimings.maghrib!),
                      _buildTableRow('Isha', namazTimings.isha!),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Qiblapage()),
                          );
                          // Qibla Direction button does nothing for now
                        },
                        child: Text('Qibla'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to InitialPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InitialPage()),
                          );
                        },
                        child: Text('Settings'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Show a dialog with a Hadith message
                          showHadithDialog(context, futureHadith);
                        },
                        child: Text('Hadith'),
                      ),
                    ],
                  ),
                ],
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
          padding: const EdgeInsets.all(16.0),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.black : Colors.grey[700],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 18,
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
