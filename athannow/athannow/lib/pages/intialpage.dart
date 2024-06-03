import 'package:athannow/pages/athantimings.dart';
import 'package:flutter/material.dart';
import 'package:athannow/commonfunctions/functins.dart';
import 'package:athannow/storage/storing.dart';
//import 'package:athannow/pages/intialpage.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String? selectedSchoolOfThought;
  String? selectedCalculationMethod;
  String? selectedShafaq;

  final List<String> schoolOfThoughtOptions = [
    'Hanafi',
    'Shafawi',
  ];
  final List<String> selectedCalculationMethodOptions = [
    'Closest to your location',
    'University of Islamic Sciences, Karachi', //1
    'Islamic Society of North America', //2
    'Muslim World League', //3
    'Umm Al-Qura University, Makkah', //4
    'Egyptian General Authority of Survey', //5
    'Institute of Geophysics, University of Tehran', //7
    'Gulf Region', //8
    'Kuwait', //9
    'Qatar', //10
    'Majlis Ugama Islam Singapura, Singapore', //11
    'Union Organization islamic de France', //12
    'Diyanet İşleri Başkanlgl, Turkey', //13
    'Spiritual Administration of Muslims of Russia', //14
    'Moonsighting Committee Worldwide', //15 need shafaq
    'Dubai (unofficial)', //16
    'Shia Ithna-Ashari' //0
  ];
  final List<String> shafaqOptions = [
    'General',
    'Ahmer',
    'Abyad',
  ];

  final citytext = TextEditingController();
  final countrytext = TextEditingController();

  Future<bool> fetchData() async {
    double? test = await get("double", "latitude");
    return test != null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500)); // Adding a delay
      await requestLocationPermissionAndLogCoordinates(context);
    });
  }

// NEED TO ADD SETTINGS PAGE IS LATITUDE LONGITUDE IS ENABLES BUT WANT TO USE A CERTAIN CITY OR ADDRESS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              'School of thought (required)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // DROPDOWN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select School of Thought'),
                value: selectedSchoolOfThought,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSchoolOfThought = newValue!;
                  });
                },
                items: schoolOfThoughtOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Calculation Method (optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Calculation Method'),
                value: selectedCalculationMethod,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCalculationMethod = newValue!;
                  });
                },
                items: selectedCalculationMethodOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Shafaq (optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Shafaq'),
                value: selectedShafaq,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedShafaq = newValue!;
                  });
                },
                items: shafaqOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            FutureBuilder<bool>(
              future: fetchData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator while waiting for the future
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && !snapshot.data!) {
                  // If location is not stored, show additional text fields
                  return Column(
                    children: [
                      const Text(
                        'Please Enter the City you live in.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: citytext,
                        decoration: InputDecoration(
                          hintText: 'Ex: Chicago',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              citytext.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Please enter the country you live in',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: countrytext,
                        decoration: InputDecoration(
                          hintText: 'Ex: United States',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              countrytext.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                } else {
                  return Container(); // Return an empty container if location is stored
                }
              },
            ),
            MaterialButton(
              onPressed: () async {
                if (selectedSchoolOfThought != null) {
                  store("string", "SchoolOfThought", selectedSchoolOfThought!);
                }
                if (selectedCalculationMethod != null) {
                  store("string", "CalculationMethod",
                      selectedCalculationMethod!);
                }
                if (selectedShafaq != null) {
                  store("string", "Shafaq", selectedShafaq!);
                }

                if (!await fetchData()) {
                  store("string", "city", citytext.text);
                  store("string", "country", countrytext.text);
                  store("string", "SchoolOfThought", selectedSchoolOfThought!);
                  store("string", "CalculationMethod",
                      selectedCalculationMethod!);
                  store("string", "Shafaq", selectedShafaq!);
                }
                // NEED TO FIGURE OUT HOW TO MAKE THIS NULL

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AthanTimingsPage()),
                );
                // go to athantimings page
              },
              color: const Color(0xFF003238),
              child: const Text('Calculate Timings',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      //over here need to add the settings page etc etc.
    );
  }
}
