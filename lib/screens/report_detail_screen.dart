import 'package:flutter/material.dart';
import 'package:projekt/models/report.dart';
import 'dart:convert';

import '../helpers/location_helper.dart';

class ReportDetailScreen extends StatefulWidget {
  static const routeName = '/report-detail';

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  String _previewImageUrl;
  Report report;

  void _showPreviewMap(double lat, double lon) {
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImage(lat, lon);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final reportData = ModalRoute.of(context).settings.arguments as Report;
    report = reportData;
    _showPreviewMap(report.location.latitude, report.location.longitude);

    super.didChangeDependencies();
  }

  Image _decodeImageString(imageString) {
    final decodedBytes = base64Decode(imageString);
    return Image.memory(decodedBytes,
        height: 250, width: double.infinity, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    // final reportData = ModalRoute.of(context).settings.arguments as Report;
    // _showPreviewMap(
    //     reportData.location.latitude, reportData.location.longitude);
    return Scaffold(
        appBar: AppBar(
          title: Text(report.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: report.image.isNotEmpty
                      ? _decodeImageString(report.image)
                      : null,
                ),
                SizedBox(height: 15),
                Text(report.title,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(report.description)),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    )),
                SizedBox(height: 15),
                Text('Lokalizacja',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: _previewImageUrl != null
                        ? Image.network(
                            _previewImageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text('Nie podano lokalizacji'),
                            ),
                          )),
                SizedBox(height: 15),
                Text('Uwagi',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ));
  }
}
