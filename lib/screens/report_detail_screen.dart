import 'package:flutter/material.dart';
import 'package:projekt/models/report.dart';
import 'package:projekt/providers/reports.dart';
import 'package:projekt/widgets/comment_item.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import '../helpers/location_helper.dart';

class ReportDetailScreen extends StatefulWidget {
  static const routeName = '/report-detail';

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  String _previewImageUrl;
  Report report;
  final _commentController = TextEditingController();

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

  Widget _messageBuilder(ReportStatus status) {
    switch (status) {
      case ReportStatus.Open:
        {
          return Center(
            child: Text('Zgłoszenie czeka na rozpatrzenie'),
          );
        }
      case ReportStatus.Closed:
        {
          return Center(
            child: Text('Zgłoszenie zamknięte'),
          );
        }
      case ReportStatus.InProgress:
        {
          return Center(
            child: Text('Zgłoszenie jest rozpatrywane'),
          );
        }
    }
  }

  Widget _statusMessageBuilder(ReportStatus status) {
    switch (status) {
      case ReportStatus.Open:
        {
          return Center(
            child: Text('Status zgłoszenia: Otwarte'),
          );
        }
      case ReportStatus.Closed:
        {
          return Center(
            child: Text('Status zgłoszenia: Zamknięte'),
          );
        }
      case ReportStatus.InProgress:
        {
          return Center(
            child: Text('Status zgłoszenia: Rozpatrywane'),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final reportData = ModalRoute.of(context).settings.arguments as Report;
    // _showPreviewMap(
    //     reportData.location.latitude, reportData.location.longitude);

    final reportsProvider = Provider.of<Reports>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(report.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: report.image != null
                    ? _decodeImageString(report.image)
                    : Text('Nie znaleziono zdjęcia'),
              ),
              SizedBox(height: 15),
              Text(report.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
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
              _statusMessageBuilder(report.status),
              SizedBox(
                height: 15,
              ),
              Text('Lokalizacja',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
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
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.purple[600],
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text('Uwagi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                    reportsProvider.userId == report.creatorId
                        ? Consumer<Reports>(
                            builder: (ctx, reports, ch) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              height: 300,
                              child: report.comments != null
                                  ? ListView.builder(
                                      itemBuilder: (ctx, i) => Column(
                                        children: [
                                          CommentItem(
                                              report.comments[i].comment,
                                              report.creatorId),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                      itemCount:
                                          report.comments.reversed.length,
                                    )
                                  : Text('Nie dodano uwag'),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(8),
                            child: _messageBuilder(report.status),
                          ),
                    if (reportsProvider.userId == report.creatorId)
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 500,
                        controller: _commentController,
                        decoration: InputDecoration(
                          label: Text('Uwagi dla admina'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (reportsProvider.userId == report.creatorId)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            color: Colors.green,
                            onPressed: () {
                              reportsProvider.addComment(
                                report.id,
                                _commentController.text,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Wysłano wiadomość')));
                              setState(() {
                                _commentController.text = '';
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: 80,
                                child: Text('Dodaj')),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
