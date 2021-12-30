import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:projekt/helpers/location_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/report.dart';

class Reports with ChangeNotifier {
  List<Report> _items = [
    Report(
        id: 'm1',
        category: null,
        title: 'Zniszczony przystanek',
        description: 'Na ulicy x jest zniszczony przystanek.',
        image: '',
        location: PlaceLocation(
            latitude: 37.422, longitude: -122.084, address: 'Wojska Polskiego'),
        status: ReportStatus.Open),
    Report(
        id: 'm2',
        category: null,
        title: 'Zniszczony śmietnik',
        description: 'Na ulicy x jest zniszczony śmietnik.',
        image: '',
        location: PlaceLocation(
            latitude: 37.422, longitude: -122.084, address: 'Armi Krajowej'),
        status: ReportStatus.Closed),
    Report(
        id: 'm3',
        category: null,
        title: 'Brak oświetlenia',
        description: 'Na ulicy x nie działa oświetlenie.',
        image: '',
        location: PlaceLocation(
            latitude: 37.422, longitude: -122.084, address: 'Szczecińska'),
        status: ReportStatus.Open),
  ];

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

      extractedData.forEach((prodId, report) {
        loadedReports.add(Report(
            id: prodId,
            title: extractedData['title'],
            description: extractedData['description'],
            category: extractedData['category'],
            image: extractedData['image'],
            status: ReportStatus.values.firstWhere((element) =>
                element.toString() == 'ReportStatus' + extractedData['status']),
            location: PlaceLocation(
                latitude: extractedData['location']['latitude'],
                longitude: extractedData['location']['longitude'],
                address: extractedData['location']['address'])));
      });
    } catch (error) {
      print(error);
      return;
    }
  }
}
