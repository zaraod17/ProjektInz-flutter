import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:projekt/models/report.dart';
import '../providers/reports.dart';
import './report_detail_screen.dart';

class ReportsOnMapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;

  ReportsOnMapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: 37.422, longitude: -122.084)});
  @override
  _ReportsOnMapScreenState createState() => _ReportsOnMapScreenState();
}

class _ReportsOnMapScreenState extends State<ReportsOnMapScreen> {
  var counter = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<Reports>(
        builder: (ctx, reportsData, _) => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.initialLocation.latitude,
                widget.initialLocation.longitude,
              ),
              zoom: 16,
            ),
            markers: reportsData.items
                .map((report) => Marker(
                      markerId: MarkerId(report.title),
                      position: LatLng(
                          report.location.latitude, report.location.longitude),
                      infoWindow: InfoWindow(
                          title: report.title,
                          snippet: report.category,
                          onTap: () => Navigator.of(context).pushNamed(
                              ReportDetailScreen.routeName,
                              arguments: report)),
                    ))
                .toSet()),
      ),
    );
  }
}
