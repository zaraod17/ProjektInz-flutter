import 'package:flutter/material.dart';
import 'package:projekt/screens/report_detail_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/report.dart';
import '../screens/report_detail_screen.dart';

class ReportItem extends StatefulWidget {
  @override
  State<ReportItem> createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  ReportStatus statusReport;

  Widget _iconBuilder(ReportStatus status) {
    switch (status) {
      case ReportStatus.Open:
        {
          return Icon(Icons.priority_high_rounded, color: Colors.red[600]);
        }
      case ReportStatus.Closed:
        {
          return Icon(Icons.done, color: Colors.green[600]);
        }
      case ReportStatus.InProgress:
        {
          return Icon(Icons.drag_indicator, color: Colors.yellow);
        }
    }
  }

  MemoryImage _decodeImageString(imageString) {
    final decodedBytes = base64Decode(imageString);
    return MemoryImage(decodedBytes);
  }

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<Report>(context);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: report.image.isNotEmpty
                ? _decodeImageString(report.image)
                : null,
          ),
          title: Text(report.title),
          subtitle: Text(report.location.address),
          trailing: _iconBuilder(report.status),
          onTap: () {
            Navigator.of(context)
                .pushNamed(ReportDetailScreen.routeName, arguments: report);
          },
        ),
        Divider()
      ],
    );
  }
}
