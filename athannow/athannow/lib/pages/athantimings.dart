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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureNamazTimings = fetchNamazTimings();
    futureHadith = fetchHadith();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AthanTimingsPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitialPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkstoreprayeritmings();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AthanNow'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<NamazTimings>(
              future: futureNamazTimings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data found'));
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
                      const SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(3),
                            },
                            children: [
                              _buildTableRow('Prayer', 'Time', isHeader: true),
                              _buildTableRow('Fajr', namazTimings.fajr!,
                                  isOddRow: true),
                              _buildTableRow('Dhuhr', namazTimings.dhuhr!),
                              _buildTableRow('Asr', namazTimings.asr!,
                                  isOddRow: true),
                              _buildTableRow('Maghrib', namazTimings.maghrib!),
                              _buildTableRow('Isha', namazTimings.isha!,
                                  isOddRow: true),
                            ],
                          ),
                        ),
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
                            },
                            child: const Text('Qibla'),
                          ),
                          /*
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InitialPage()),
                              );
                            },
                       child: const Text('Settings'),
                       ),
                       */

                          ElevatedButton(
                            onPressed: () {
                              futureNamazTimings = fetchNamazTimings();
                              futureHadith = fetchHadith();
                              showHadithDialog(context, futureHadith);
                            },
                            child: const Text('Hadiths'),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'Timings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  TableRow _buildTableRow(String name, String time,
      {bool isHeader = false, bool isOddRow = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader
            ? Colors.blueAccent.withOpacity(0.2)
            : (isOddRow ? Colors.grey[200] : Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
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
          padding: const EdgeInsets.all(12.0),
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
