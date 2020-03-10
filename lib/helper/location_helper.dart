import 'package:http/http.dart' as http;
import 'dart:convert';

const String GOOGLE_API_KEY = 'AIzaSyDoOGlaGPBW3IIPoiav-tBTREnGVyuYbWk';
const String GEO_API =
    'https://maps.googleapis.com/maps/api/geocode/json?latlng=';

class LocationHelper {
  static String generateLocationReviewImage({double lat, double long}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final String url = '$GEO_API$lat,$long&key=$GOOGLE_API_KEY';
    final respond = await http.get(url);
    final address = json.decode(respond.body);
    print(address['results'][0]['formatted_address']);
    return address['results'][0]['formatted_address'];
//    results[0].formatted_address
  }
}
