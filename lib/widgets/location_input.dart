import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:projekt/helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreviewMap(locData.latitude, locData.longitude);
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
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
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
              label: Text('Current Location'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo)),
              onPressed: _getCurrentUserLocation,
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.map,
              ),
              label: Text('Select on Map'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo)),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
