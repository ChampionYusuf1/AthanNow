import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:athannow/commonfunctions/functins.dart';
import 'package:athannow/storage/storing.dart';

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
      await requestLocationPermissionAndLogCoordinates(context);
    });
  }

  final schoolofthoughttext = TextEditingController();
  final calculationmethodtext = TextEditingController();
  final shafaqtext = TextEditingController();
  // only if location is not allowed, or maybe address then
  final latitudetext = TextEditingController();
  final longitudetext = TextEditingController();
  final addresstext = TextEditingController();
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
              height: 20,
            ),
            const Text(
              'School of thought(required)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: schoolofthoughttext,
              decoration: InputDecoration(
                hintText: 'Hanafi, Shafawi,Default Shafawi',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    schoolofthoughttext.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Calculation Method(optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: calculationmethodtext,
              decoration: InputDecoration(
                hintText: 'See settings page for options',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    calculationmethodtext.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Shafaq(optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: shafaqtext,
              decoration: InputDecoration(
                hintText: 'Options: General, Ahmer, Abyad',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    shafaqtext.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                print('Submitted text: ${schoolofthoughttext.text}');
                testingstoringtext(schoolofthoughttext);
                // go to athantimings page
              },
              color: Color(0xFF003238),
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

testingstoringtext(TextEditingController controller) async {
  // final prefs = await SharedPreferences.getInstance();

  // await prefs.setString('testtext', controller.text);
  store("string", "testtext", controller.text);
  print("Test text stored succesfuly");
  String temp = await get("string", "testtext");
  print(temp);
}
