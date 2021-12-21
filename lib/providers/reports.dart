import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:projekt/helpers/location_helper.dart';

import '../models/report.dart';

class Reports with ChangeNotifier {
  List<Report> _items = [
    Report(
        id: 'm1',
        category: null,
        title: 'Zniszczony przystanek',
        description: 'Na ulicy x jest zniszczony przystanek.',
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN5cGrSHd6Z2NtYLBEyLxtgQsVm67AMLJkTA&usqp=CAU',
        location: PlaceLocation(
            latitude: 37.422, longitude: -122.084, address: 'Wojska Polskiego'),
        status: ReportStatus.Open),
    Report(
        id: 'm2',
        category: null,
        title: 'Zniszczony śmietnik',
        description: 'Na ulicy x jest zniszczony śmietnik.',
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQW7RFeHn_HUDCEz_Sj3knBSL28bO6gtjsisg&usqp=CAU',
        location: PlaceLocation(
            latitude: 37.422, longitude: -122.084, address: 'Armi Krajowej'),
        status: ReportStatus.Closed),
    Report(
        id: 'm3',
        category: null,
        title: 'Brak oświetlenia',
        description: 'Na ulicy x nie działa oświetlenie.',
        image: 'http://inzynieria.com/uploaded/articles/crop_5/59766.jpg',
        location: PlaceLocation(
            latitude: 37.422, longitude: -122.084, address: 'Szczecińska'),
        status: ReportStatus.Open),
  ];

  List<Report> get items {
    return [..._items];
  }

  Future<void> addReport(String pickedTitle, String pickedDescription,
      PlaceLocation pickedLocation) async {
    final placeAddress = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: placeAddress);

    final newReport = Report(
        id: DateTime.now().toString(),
        title: pickedTitle,
        image: null,
        description: pickedDescription,
        location: updatedLocation,
        status: ReportStatus.Open);

    _items.add(newReport);
    notifyListeners();
  }
}
