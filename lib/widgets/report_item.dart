import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:projekt/screens/report_detail_screen.dart';
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
    var newFormat = DateFormat("yy-MM-dd H:m");
    return Expanded(
      child: ListTile(
        leading: report.image != null
            ? CircleAvatar(backgroundImage: _decodeImageString(report.image))
            : null,
        title: Text(report.title),
        subtitle: report.creationDate != null
            ? Text('Stworzono: ${newFormat.format(report.creationDate)}')
            : null,
        trailing: _iconBuilder(report.status),
        onTap: () {
          Navigator.of(context)
              .pushNamed(ReportDetailScreen.routeName, arguments: report);
        },
      ),
    );
  }
}
