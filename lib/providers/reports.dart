import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:projekt/helpers/location_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/report.dart';

class Reports with ChangeNotifier {
  List<Report> _items = [];
  List<Report> _copyItems = [];
  final String authToken;
  final String userId;
  int limitNumber = 8;
  int startNumer = 9;

  Reports(this.authToken, this.userId, this._items);

  List<Report> get items {
    return [..._items];
  }

  List<Report> get copyOfReports {
    return [..._copyItems];
  }

  Future<void> addReport(
      {String pickedTitle,
      String pickedDescription,
      PlaceLocation pickedLocation,
      String pickedImage,
      String pickedCategory}) async {
    final url = Uri.parse(
        'https://projektinz-fb3fd-default-rtdb.europe-west1.firebasedatabase.app/reports.json?auth=$authToken');

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
            'dateTime': DateTime.now().toIso8601String(),
            'creatorId': userId,
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
          creatorId: userId,
          status: ReportStatus.Open);

      _items.add(newReport);
      // _copyItems.add(newReport);
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> fetchAndSetAllReports([bool filterByUser = false]) async {
    var number = 30;
    // var now = DateTime.now().toIso8601String();
    final limit = 'limitToLast=$number';
    final filterString = filterByUser
        ? 'orderBy="creatorId"&equalTo="$userId"'
        : 'orderBy="\$key"&$limit';
    var url = Uri.parse(
        'https://projektinz-fb3fd-default-rtdb.europe-west1.firebasedatabase.app/reports.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Report> loadedReports = [];

      extractedData.forEach((prodId, report) {
        final List<Comment> commentsList = [];

        var commentsMap = report['comments'] as Map<String, dynamic>;

        commentsMap != null
            ? commentsMap.forEach((commentId, comment) {
                commentsList.add(Comment(
                    comment: comment['content'], userId: comment['userId']));
              })
            : null;

        loadedReports.add(Report(
          id: prodId,
          title: report['title'],
          description: report['description'],
          category: report['category'],
          image: report['image'],
          creatorId: report['creatorId'],
          status: ReportStatus.values.firstWhere((status) =>
              status.toString() == 'ReportStatus.' + report['status']),
          comments: commentsList,
          location: PlaceLocation(
              latitude: report['location']['latitude'],
              longitude: report['location']['longitude'],
              address: report['location']['address']),
        ));
      });
      _items = loadedReports.reversed.toList();
      _copyItems = loadedReports.reversed.toList();

      notifyListeners();
    } catch (error) {
      print(error);
      return;
    }
  }

  // Future<void> fetchMoreReports() async {
  //   final limit = 'limitToFirst=$limitNumber';
  //   final lastReport = _items.last.id;
  //   var now = DateTime.now().toIso8601String();
  //   final filterString =
  //       'orderBy="dateTime"&$limit&startAt="$lastReport"&equalTo="$now"';
  //   var url = Uri.parse(
  //       'https://projektinz-fb3fd-default-rtdb.europe-west1.firebasedatabase.app/reports.json?auth=$authToken&$filterString');

  //   try {
  //     final response = await http.get(url);

  //     // print(authToken);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }

  //     if (extractedData.length < 2) {
  //       return;
  //     }

  //     extractedData.forEach((prodId, report) {
  //       final List<Comment> commentsList = [];

  //       var commentsMap = report['comments'] as Map<String, dynamic>;

  //       commentsMap != null
  //           ? commentsMap.forEach((commentId, comment) {
  //               commentsList.add(Comment(
  //                   comment: comment['content'], userId: comment['userId']));
  //             })
  //           : null;

  //       _items.add(Report(
  //           id: prodId,
  //           title: report['title'],
  //           description: report['description'],
  //           category: report['category'],
  //           image: report['image'],
  //           creatorId: report['creatorId'],
  //           status: ReportStatus.values.firstWhere((status) =>
  //               status.toString() == 'ReportStatus.' + report['status']),
  //           comments: commentsList,
  //           location: PlaceLocation(
  //               latitude: report['location']['latitude'],
  //               longitude: report['location']['longitude'],
  //               address: report['location']['address'])));
  //     });

  //     _items = _items.toSet().toList();

  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     return;
  //   }
  // }

  void filterReports(String value) {
    final reports = copyOfReports;
    List<Report> filteredItems = [];
    if (value == 'all') {
      filteredItems = reports;
    } else if (value == 'open') {
      filteredItems = reports
          .where((report) => report.status == ReportStatus.Open)
          .toList();
    } else if (value == 'closed') {
      filteredItems = reports
          .where((report) => report.status == ReportStatus.Closed)
          .toList();
    } else if (value == 'inProgress') {
      filteredItems = reports
          .where((report) => report.status == ReportStatus.InProgress)
          .toList();
    } else {
      _items = reports;
    }
    _items = filteredItems;
    notifyListeners();
  }

  void addComment(String reportId, String comment) async {
    final url = Uri.parse(
        'https://projektinz-fb3fd-default-rtdb.europe-west1.firebasedatabase.app/reports/$reportId/comments.json?auth=$authToken');
    try {
      await http.post(url,
          body: json.encode({'content': comment, 'userId': userId}));

      _items[_items.indexWhere((report) => report.id == reportId)]
          .comments
          .add(Comment(comment: comment, userId: userId));

      notifyListeners();
    } catch (error) {
      print(error);
      return;
    }
  }
}
