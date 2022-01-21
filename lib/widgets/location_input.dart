import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:projekt/helpers/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projekt/screens/maps_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;

  LocationInput(this.onSelectLocation);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreviewMap(locData.latitude, locData.longitude);
      widget.onSelectLocation(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  void _showPreviewMap(double lat, double lon) {
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImage(lat, lon);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation =
        await Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
                  isSelecting: true,
                )));
    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation.latitude);
    _showPreviewMap(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectLocation(
        selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          child: _previewImageUrl == null
              ? Text(
                  'Nie wybrano lokalizacji',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton.icon(
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Obecna lokalizacja'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo)),
              onPressed: _getCurrentUserLocation,
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.map,
              ),
              label: Text('Wybierz na mapie'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo)),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
