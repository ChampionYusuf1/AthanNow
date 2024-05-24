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

  final _textController = TextEditingController();

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
              'Static text above the text boxes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'This is the hint text',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Static text above the text boxes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'This is the hint text',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                print('Submitted text: ${_textController.text}');
                testingstoringtext(_textController);
              },
              color: Colors.blue,
              child: const Text('Post', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
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
