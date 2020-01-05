import 'package:geolocator/geolocator.dart';

class Location {
  double long;
  double lat;
  String address = "";
  String city = "";
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

  Location(double long, double lat) {
    this.long = long;
    this.lat = lat;
  }

  Future<void> setAddress() async {
    address = await _getAddressFromLatLng(lat, long);
  }

  Future<String> _getAddressFromLatLng(double lat, double long) async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(lat, long);
      Placemark place = p[0];
      city = place.locality;
      print(city);
      return "${place.locality},${place.postalCode},${place.country}";
    } catch (e,trace) {
      return "Mountain View,94043,United States";
    }

  }

  @override
  String toString() {
    //remove spaces in address
    return "$lat,$long";
  }
}
