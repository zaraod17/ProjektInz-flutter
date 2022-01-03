import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:projekt/helpers/location_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/report.dart';

class Reports with ChangeNotifier {
  List<Report> _items = [];
  final String authToken;
  final String userId;

  Reports(this.authToken, this.userId, this._items);

  List<Report> get items {
    return [..._items];
  }

  Future<void> addReport(
      {String pickedTitle,
      String pickedDescription,
      PlaceLocation pickedLocation,
      String pickedImage,
      String pickedCategory}) async {
    final url = Uri.parse(
        'https://projektinz-fb3fd-default-rtdb.europe-west1.firebasedatabase.app/reports.json');

    final placeAddress = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: placeAddress);

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': pickedTitle,
            'category': pickedCategory,
            'description': pickedDescription,
            'image': pickedImage,
            'location': {
              'latitude': updatedLocation.latitude,
              'longitude': updatedLocation.longitude,
              'address': updatedLocation.address
            },
            'status': describeEnum(ReportStatus.Open)
          }));

      final newReport = Report(
          id: json.decode(response.body)['name'],
          title: pickedTitle,
          image: pickedImage,
          description: pickedDescription,
          location: updatedLocation,
          category: pickedCategory,
          status: ReportStatus.Open);

      _items.add(newReport);
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> fetchAndSetAllReports() async {
    var url = Uri.parse(
        'https://projektinz-fb3fd-default-rtdb.europe-west1.firebasedatabase.app/reports.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Report> loadedReports = [];
      // print(extractedData);

      extractedData.forEach((prodId, report) {
        loadedReports.add(Report(
            id: prodId,
            title: report['title'],
            description: report['description'],
            category: report['category'],
            image: report['image'],
            status: ReportStatus.Open,
            location: PlaceLocation(
                latitude: report['location']['latitude'],
                longitude: report['location']['longitude'],
                address: report['location']['address'])));

        // print(report['image']);
      });
      _items = loadedReports;

      notifyListeners();
    } catch (error) {
      print(error);
      return;
    }
  }
}
