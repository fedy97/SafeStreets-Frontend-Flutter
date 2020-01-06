import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';

class ReportMapManager {
  static Map<MarkerId, Marker> toMarker(User u, BuildContext context) {
    Map<MarkerId, Marker> map = Map();
    DateTime now = DateTime.now();
    var iter = u.reportsGet.iterator;
    while (iter.moveNext()) {
      //check if the report is in the range of the 24 hours
      if (int.tryParse(
              now.difference(iter.current.time).toString().split(":")[0]) <
          24) {
        final markerId =
            MarkerId(u.reportsGet.indexOf(iter.current).toString());
        //color marker if fined
        final Marker marker = Marker(
            icon: !iter.current.fined
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue)
                : BitmapDescriptor.defaultMarker,
            onTap: () async {
              u.setCurrViewedReport = u.reportsGet[int.parse(markerId.value)];
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<User>.value(
                        value: u,
                        child: u.viewReportPage(),
                      )));
            },
            markerId: markerId,
            position: LatLng(iter.current.reportPosition.lat,
                iter.current.reportPosition.long));
        map[markerId] = marker;
      }
    }
    return map;
  }
}
