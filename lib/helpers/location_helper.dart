import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyDDzq-egmdJPhZUosNCxtag75NPlFUM2RE';

class LocationHelper {
  static String generateLocationPreviewImage(
      double latitude, double longitude) {
    return (latitude != null && longitude != null)
        ? 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY'
        : null;
  }

  static Future<String> getPlaceAddress(double lat, double lon) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$GOOGLE_API_KEY');
    try {
      final response = await http.get(url);
      return json.decode(response.body)['results'][0]['formatted_address'];
    } catch (error) {
      return null;
    }
  }
}
