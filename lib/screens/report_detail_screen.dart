import 'package:flutter/material.dart';
import 'package:projekt/models/report.dart';

class ReportDetailScreen extends StatelessWidget {
  static const routeName = '/report-detail';
  @override
  Widget build(BuildContext context) {
    final reportData = ModalRoute.of(context).settings.arguments as Report;
    return Scaffold(
        appBar: AppBar(
          title: Text(reportData.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    reportData.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Text(reportData.description,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Container(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsets.all(15), child: Text('Opis')),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    )),
                SizedBox(height: 15),
                Text('Lokalizacja',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                Container(
                    width: double.infinity,
                    height: 250,
                    child: Text('Mapka z lokalizacją',
                        textAlign: TextAlign.center),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
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
