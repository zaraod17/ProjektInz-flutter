import 'package:flutter/foundation.dart';

import 'package:projekt/providers/reports.dart';

enum ReportStatus { Open, Closed, InProgress }

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation(
      {@required this.latitude, @required this.longitude, this.address});
}

class Comment {
  final String comment;
  final String userId;

  Comment({this.comment, this.userId});
}

class Report with ChangeNotifier {
  final String id;
  final String category;
  final String title;
  final String description;
  final String image;
  final String creatorId;
  final DateTime creationDate;
  final List<Comment> comments;
  final PlaceLocation location;
  final ReportStatus status;

  Report(
      {this.id,
      this.title,
      this.category,
      this.location,
      this.comments,
      this.description,
      this.creatorId,
      this.creationDate,
      this.image,
      this.status});
}
