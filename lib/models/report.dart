import 'package:flutter/foundation.dart';

enum ReportStatus { Open, Closed, InProgress }

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation(
      {@required this.latitude, @required this.longitude, this.address});
}

class Report with ChangeNotifier {
  final String id;
  final String category;
  final String title;
  final String description;
  final String image;
  final PlaceLocation location;
  final ReportStatus status;

  Report(
      {this.id,
      this.title,
      this.category,
      this.location,
      this.description,
      this.image,
      this.status});
}
