import 'package:geolocator/geolocator.dart';

class Location {
  double long;
  double lat;
  String address = "";
  final Geolocator geoLocator = Geolocator()
    ..forceAndroidLocationManager;
  Location(double long, double lat) {
    this.long = long;
    this.lat = lat;
  }

  Future<void> setAddress() async {
    address = await _getAddressFromLatLng(lat, long);
  }

  Future<String> _getAddressFromLatLng(double lat, double long) async {
    List<Placemark> p = await geoLocator.placemarkFromCoordinates(
        lat, long);
    Placemark place = p[0];
    return "${place.locality}, ${place.postalCode}, ${place.country}, ${place.thoroughfare}, ${place.subThoroughfare}";
  }

  @override
  String toString(){
    //remove spaces in address
    return "$lat,$long";
  }
}
