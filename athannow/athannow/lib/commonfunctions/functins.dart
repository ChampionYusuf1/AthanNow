import 'package:flutter/cupertino.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;

void requestLocationPermissionAndLogCoordinates(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Location Permission'),
        content: Text('My App wants to access your location.'),
        actions: [
          CupertinoDialogAction(
            child: Text('Deny'),
            onPressed: () {
              print('Deny pressed');
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('Allow'),
            onPressed: () async {
              print('Allow pressed');
              Navigator.of(context).pop();
              await getLocationPermission(context);
              await getUserLocation(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> getLocationPermission(BuildContext context) async {
  loc.Location location = loc.Location();
  bool serviceEnabled;
  loc.PermissionStatus permissionStatus;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      print('Location services not enabled');
      return;
    }
  }

  permissionStatus = await location.hasPermission();
  if (permissionStatus == loc.PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();
    if (permissionStatus != loc.PermissionStatus.granted) {
      print('Location permission denied');
      return;
    }
  }
}

Future<void> getUserLocation(BuildContext context) async {
  try {
    geo.Position position = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;

    // Log the latitude and longitude values
    print('Latitude: $latitude');
    print('Longitude: $longitude');
  } catch (e) {
    print('Error getting location: $e');
  }
}
