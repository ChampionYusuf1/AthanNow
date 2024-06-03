import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:athannow/storage/storing.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

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
Future<void> calculateprayertimings() async {
  remove("apiurl");

  double? latitude = await get("double", "latitude");
  double? longitude = await get("double", "longitude");
  String? calculationmethod = await get("string", "CalculationMethod");
  String? convertedcalculationmethod = convertcalculation(calculationmethod);
  String? shafaq = await get("string", "Shafaq");
  String? convertedshafaq = convertshafaq(shafaq);
  String? city = await get("string", "city");
  String? country = await get("string", "country");
  String? SchoolOfThought = await get("string", "SchoolOfThought");
  String? convertedschool = convertschool(SchoolOfThought);

  var now = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy');
  String formattedDate = formatter.format(now);

  String url = "http://api.aladhan.com/v1/timings";
  if (latitude != null && longitude != null) {
    url = "$url/$formattedDate?latitude=$latitude&longitude=$longitude";
  } else {
    url = "${url}ByCity/$formattedDate?city=$city&country=$country";
  }
  print(convertedcalculationmethod);
  if (convertedcalculationmethod != null) {
    url = "$url&method=$convertedcalculationmethod";
  }
  if (convertedshafaq != null) {
    url = "$url&shafaq=$convertedshafaq";
  }
  if (convertedschool != null) {
    url = "$url&school=$convertedschool";
  }
  store("string", "apiurl", url);
  print(url);
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

class Hadiths {
  final String? hadithNumber;
  final String? englishNarrator;
  final String? hadithEnglish;
  final String? hadithArabic;
  final String? headingEnglish;

  Hadiths({
    required this.hadithNumber,
    required this.englishNarrator,
    required this.hadithEnglish,
    required this.hadithArabic,
    required this.headingEnglish,
  });
  factory Hadiths.fromJson(Map<String, dynamic> json) {
    return Hadiths(
      hadithNumber: json['hadithNumber'],
      englishNarrator: json['englishNarrator'],
      hadithEnglish: json['hadithEnglish'],
      hadithArabic: json['hadithArabic'],
      headingEnglish: json['headingEnglish'],
    );
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
  await calculateprayertimings();

  String? apiurl = await get("string", "apiurl");

  if (apiurl == null) {
    print("api null error$apiurl");
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

Future<bool> checkapiurl() async {
  String? apiurl = await get("string", "apiurl");
  if (apiurl == null) {
    return false;
  } else {
    return true;
  }
}

// hadith of the day $2y$10$dG7b7sNNJF8UXpUFTePYLeUW8agRqHYytjwwRnDFAwozFgzyPjCYS
//  https://www.hadithapi.com/public/api/hadiths?apiKey=$2y$10$dG7b7sNNJF8UXpUFTePYLeUW8agRqHYytjwwRnDFAwozFgzyPjCYS

Future<int> fetchTotalHadithsPages() async {
  int randomVariable = Random().nextInt(1000) + 1;
  final response = await http.get(
    Uri.parse(
        r'https://hadithapi.com/public/api/hadiths?apiKey=$2y$10$dG7b7sNNJF8UXpUFTePYLeUW8agRqHYytjwwRnDFAwozFgzyPjCYS&paginate=' +
            randomVariable.toString()),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['hadiths'] == null) {
      throw Exception('Invalid JSON structure');
    }
    return jsonResponse['hadiths']['last_page'];
  } else {
    throw Exception('Failed to fetch total pages');
  }
}

Future<Hadiths> fetchHadith() async {
  Random random = Random();
  int totalPages = await fetchTotalHadithsPages();
  int randomPage = random.nextInt(totalPages) + 1;

  final response = await http.get(
    Uri.parse(
        r'https://hadithapi.com/public/api/hadiths?apiKey=$2y$10$dG7b7sNNJF8UXpUFTePYLeUW8agRqHYytjwwRnDFAwozFgzyPjCYS&page=$randomPage'),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['hadiths']['data'] == null) {
      throw Exception('Invalid JSON structure');
    }

    final List<dynamic> hadithsList = jsonResponse['hadiths']['data'];
    if (hadithsList.isEmpty) {
      throw Exception('No hadiths found');
    }

    int randomHadithIndex = random.nextInt(hadithsList.length);
    final randomHadithJson = hadithsList[randomHadithIndex];
    return Hadiths.fromJson(randomHadithJson);
  } else {
    throw Exception('Failed to load Hadith');
  }
}
