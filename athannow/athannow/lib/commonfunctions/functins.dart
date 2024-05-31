import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:athannow/storage/storing.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// this widget is the intial location permission widget
Future<void> requestLocationPermissionAndLogCoordinates(
    BuildContext context) async {
  bool location = await isDataAlreadyHere();
  print("Location: $location");

  if (!location) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Location Permission'),
          content: const Text('AthanNow wants to access your location.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Deny'),
              onPressed: () {
                print('Deny pressed');
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Allow'),
              onPressed: () async {
                print('Allow pressed');
                Navigator.of(context, rootNavigator: true).pop();
                await handleLocationPermission(context);
              },
            ),
          ],
        );
      },
    );
  } else {
    print("Location already stored");
    //  removeLocationData();
  }
}

// just future logs for handling location permission
Future<void> handleLocationPermission(BuildContext context) async {
  print('Handling location permission');
  try {
    await getLocationPermission();
    print('Location permission handled');
    await getUserLocation();
    print('Location retrieved successfully');
  } catch (e) {
    print('Error during permission handling or location retrieval: $e');
  }
}

// permission for getlocationpermission
Future<void> getLocationPermission() async {
  print('Requesting location permission');
  loc.Location location = loc.Location();
  bool serviceEnabled;
  loc.PermissionStatus permissionStatus;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    print('Location service not enabled, requesting enablement');
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      print('Location service not enabled by user');
      return;
    }
  }
  permissionStatus = await location.hasPermission();
  if (permissionStatus == loc.PermissionStatus.denied) {
    print('Location permission denied, requesting permission');
    permissionStatus = await location.requestPermission();
    if (permissionStatus != loc.PermissionStatus.granted) {
      print('Location permission denied by user');
      return;
    }
  }
  print('Location permission granted');
}

// getting user location
Future<void> getUserLocation() async {
  print('Requesting user location');
  try {
    geo.Position position = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;

    // Log the latitude and longitude values
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    // store latitude and longitude
    await storeLocationData(latitude, longitude);
  } catch (e) {
    print('Error getting location: $e');
  }
}

// storing location data
Future<void> storeLocationData(double latitude, double longitude) async {
  store("double", "latitude", latitude.toString());
  store("double", "longitude", longitude.toString());
  print("Memory stored correctly");
}

// checking if data is alreadyhere to see for permissions are needed
Future<bool> isDataAlreadyHere() async {
  double? latitude = await get("double", "latitude");
  double? longitude = await get("double", "longitude");
  print('Latitude memory check: $latitude');
  print('Longitude memory check: $longitude');
  if (latitude == null || longitude == null) {
    return false;
  }
  return true;
}

bool testingwidget(bool test) {
  Widget myWidget = Container(
    color: Colors.blue,
    child: Text(
      'Testing Widget',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  );
  print('Testing widget created');
  return true;
  // Use myWidget in your UI
}

//https://aladhan.com/prayer-times-api#GetCalendar

// athan timings api with latitude and longitude
//https://api.aladhan.com/v1/calendar/2017/4?latitude=51.508515&longitude=-0.1254872&method=2&shafaq=general&school=0
// http://api.aladhan.com/v1/timings/17-07-2007?latitude=51.508515&longitude=-0.1254872&method=2
void calculateprayertimings() async {
  double? latitude = await get("double", "latitude");
  double? longitude = await get("double", "longitude");
  // need to change calculation method to 0-1,2,3, etc
  String? calculationmethod = await get("string", "CalculationMethod");
  String? convertedcalculationmethod = convertcalculation(calculationmethod);
  // converted shafaq
  String? shafaq = await get("string", "Shafaq");
  String? convertedshafaq = convertshafaq(shafaq);

  // getting city and state
  String? city = await get("string", "city");
  String? country = await get("string", "country");
  // school of thought
  String? SchoolOfThought = await get("string", "SchoolOfThought");
  String? convertedschool = convertschool(SchoolOfThought);

  // getting new date
  var now = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy');
  String formattedDate = formatter.format(now);

// basic api url
  String? http = "http://api.aladhan.com/v1/timings/$formattedDate?";

// need to check if the no calculation method is found, then dont include it,
  if (latitude != null && longitude != null) {
    http = "${http}latitude=$latitude&longitude=$longitude";
  } else if (city != null && country != null) {
    http = "${http}city=$city&state=$country";
  } else {
    print(
        "no longitude lattiude city or state found cannot finish calculations these are requireds");
  }
  if (calculationmethod != null) {
    http = "$http&method=$convertedcalculationmethod";
  }
  if (shafaq != null) {
    http = "$http&shafaq=$convertedshafaq";
  }
  if (SchoolOfThought != null) {
    http = "$http&school=$convertedschool";
  }
  store("string", "apiurl", http);
  // String apiUrl ="$http$formattedDate?latitude=$latitude&longitude=$longitude&method=$convertedcalculationmethod&shafaq=$convertedshafaq&school=$convertedschool";
  // print(apiUrl);
  print(http);
}

String? convertcalculation(String? calc) {
  if (calc == "Shia Ithna-Ashari") {
    return "0";
  } else if (calc == "University of Islamic Sciences, Karachi") {
    return "1";
  } else if (calc == "Islamic Society of North America") {
    return "2";
  } else if (calc == "Muslim World League") {
    return "3";
  } else if (calc == "Umm Al-Qura University, Makkah") {
    return "4";
  } else if (calc == "Egyptian General Authority of Survey") {
    return "5";
  } else if (calc == "Institute of Geophysics, University of Tehran") {
    return "7";
  } else if (calc == "Gulf Region") {
    return "8";
  } else if (calc == "Kuwait") {
    return "9";
  } else if (calc == "Qatar") {
    return "10";
  } else if (calc == "Majlis Ugama Islam Singapura, Singapore") {
    return "11";
  } else if (calc == "Union Organization islamic de France") {
    return "12";
  } else if (calc == "Diyanet İşleri Başkanlgl, Turkey") {
    return "13";
  } else if (calc == "Spiritual Administration of Muslims of Russia") {
    return "14";
  } else if (calc ==
      "Moonsighting Committee Worldwide (also requires shafaq parameter)") {
    return "15";
  } else if (calc == "Dubai (unofficial)") {
    return "16";
  } else {
    return null;
  }
}

String? convertshafaq(String? shafaq) {
  if (shafaq == "Ahmer") {
    return "ahmer";
  } else if (shafaq == "General") {
    return "general";
  } else if (shafaq == "Abyad") {
    return "abyad";
  } else {
    return "general";
  }
}

String? convertschool(String? school) {
  if (school == "Hanafi") {
    return "1";
  } else if (school == "Shafawi") {
    return "0";
  } else {
    return "0";
  }
}

class NamazTimings {
  final String? fajr;
  final String? dhuhr;
  final String? asr;
  final String? maghrib;
  final String? isha;

  NamazTimings({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory NamazTimings.fromJson(Map<String, dynamic> json) {
    return NamazTimings(
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }
}

Future<NamazTimings> fetchNamazTimings() async {
  calculateprayertimings();
  String? apiurl = await get("string", "apiurl");

  if (apiurl == null) {
    throw Exception('API URL is null');
  }

  print("apiurl: $apiurl");
  final response = await http.get(Uri.parse(apiurl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (jsonResponse['data'] == null ||
        jsonResponse['data']['timings'] == null) {
      throw Exception('Invalid JSON structure');
    }

    return NamazTimings.fromJson(jsonResponse['data']['timings']);
  } else {
    throw Exception('Failed to load Namaz timings');
  }
}


//athan timings with city and country
