import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:athannow/storage/storing.dart';

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
