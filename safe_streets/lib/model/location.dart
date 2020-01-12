import 'package:geolocator/geolocator.dart';

///Location is made: latitude, longitude, address and city
class Location {
  double long;
  double lat;
  String address = "";
  String city = "";
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

  ///Location is made at least of two coordinate: latitude and longitude
  Location(double long, double lat) {
    this.long = long;
    this.lat = lat;
  }

  ///setter
  Future<void> setAddress() async {
    address = await _getAddressFromLatLng(lat, long);
  }

  ///This method retrieves the address(locality, postal code, country) from latitude and longitude
  Future<String> _getAddressFromLatLng(double lat, double long) async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(lat, long);
      Placemark place = p[0];
      city = place.locality;
      return "${place.locality},${place.postalCode},${place.country}";
    } catch (e, trace) {
      return "Mountain View,94043,United States";
    }
  }

  @override
  String toString() {
    //remove spaces in address
    return "$lat,$long";
  }
}
