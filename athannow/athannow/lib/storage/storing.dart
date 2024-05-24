import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:athannow/commonfunctions/functins.dart';
import 'package:shared_preferences/shared_preferences.dart';

// a few things we want to do here
/**
 * Firstly, store all neccesary information for prayer timings
 * and we want to make all of these actually into either one function or seperate
 * 
 * latitude OR address OR city
 * longitude OR address OR city
 * 
 * month
 * year
 * method
 * shafaq
 * tune
 * midnight mode
 * timezone string
 * latitude adjustment method
 * adjustment
 * iso8601
 */

/*  store data
Future<void> storeLocationData(double latitude, double longitude) async {
  final userPreference = await SharedPreferences.getInstance();

  await userPreference.setDouble('latitude', latitude);
  await userPreference.setDouble('longitude', longitude);
  print("Memory stored correctly");
}
removing data
Future<void> removeLocationData() async {
  final userPreference = await SharedPreferences.getInstance();
  await userPreference.remove('latitude');
  await userPreference.remove('longitude');
  print("Memory removed correctly");
}
reading data
Future<void> ReadLocationData() async {
  final userPreference = await SharedPreferences.getInstance();
  final String? latitude = await userPreferece.get('latitude');
  final String? longitude = await userPreferece.get('longitude');
  print("Memory read");
}
 */

//dynamic method to store a variable

void store(String variable, String name, String value) async {
  final prefs = await SharedPreferences.getInstance();

  if (variable == "double") {
    try {
      double temp = double.parse(value);
      await prefs.setDouble(name, temp);
    } catch (e) {
      print("Error parsing double");
    }
  } else if (variable == "string") {
    String temp = value;
    await prefs.setString(name, temp);
  } else if (variable == "boolean") {
    bool temp;
    if (value == "true") {
      temp = true;
      await prefs.setBool(name, temp);
    } else {
      temp = false;
      await prefs.setBool(name, temp);
    }
  } else if (variable == "int") {
    try {
      int temp = int.parse(value);
      await prefs.setInt(name, temp);
    } catch (e) {
      print("Error parsing int");
    }
  } else {
    print("variable not found");
  }
}
// dynamic getting

Future<dynamic> get(String variable, String name) async {
  final prefs = await SharedPreferences.getInstance();
  if (variable == "string") {
    final String? result = prefs.getString(name);
    return result;
  } else if (variable == "boolean") {
    final bool? result = prefs.getBool(name);
    return result;
  } else if (variable == "int") {
    final int? result = prefs.getInt(name);
    return result;
  } else if (variable == "double") {
    final double? result = prefs.getDouble(name);
    return result;
  } else {
    print("error: unkown variable");
    return -1;
  }
}

// dynamic way to remove variables
void remove(String name) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(name);
}

//longitude
void storelongitude(double longitude) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('longitude', longitude);
}

Future<double?> getlongitude() async {
  final prefs = await SharedPreferences.getInstance();
  final double? longitude = await prefs.getDouble('longitude');
  if (longitude == null) {
    return null;
    print("longitude is null");
  }
  return longitude;
}

void removelongitudedata() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('longitude');
}
// longitude

// latitude
void storelatitude(double latitude) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('latitude', latitude);
}

Future<double?> getlatitude() async {
  final prefs = await SharedPreferences.getInstance();
  final double? latitude = await prefs.getDouble('latitude');
  if (latitude == null) {
    return null;
  }
  return latitude;
}

void removelatitudedata() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('latitude');
}
//latitude

//month
void storemonth(int month) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('month', month);
}

Future<int?> getmonth() async {
  final prefs = await SharedPreferences.getInstance();
  final int? month = prefs.getInt('month');
  if (month == null) {
    return null;
  }
  return month;
}

void removemonth(int month) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('month');
}
//month

//year

//year

//method

//method

//shafaq

//shafaq

//tune

//tune

//midnight mode

//midnight mode

//timezone string

//timezone string

//latitude adjustment method

// latitude adjustment method

//adjustment

//adjustment 

//is08601

//is8601

//address

//address