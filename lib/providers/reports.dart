import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
        location: PlaceLoaction(
            latitude: null, longitude: null, address: 'Wojska Polskiego'),
        status: ReportStatus.Open),
    Report(
        id: 'm2',
        category: null,
        title: 'Zniszczony śmietnik',
        description: 'Na ulicy x jest zniszczony śmietnik.',
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQW7RFeHn_HUDCEz_Sj3knBSL28bO6gtjsisg&usqp=CAU',
        location: PlaceLoaction(
            latitude: null, longitude: null, address: 'Armi Krajowej'),
        status: ReportStatus.Closed),
    Report(
        id: 'm3',
        category: null,
        title: 'Brak oświetlenia',
        description: 'Na ulicy x nie działa oświetlenie.',
        image: 'http://inzynieria.com/uploaded/articles/crop_5/59766.jpg',
        location: PlaceLoaction(
            latitude: null, longitude: null, address: 'Szczecińska'),
        status: ReportStatus.Open),
  ];

  List<Report> get items {
    return [..._items];
  }
}
