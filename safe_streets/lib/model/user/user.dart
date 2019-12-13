import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';

abstract class User extends ChangeNotifier {
  String _email;
  String _uid;
  Level _level;
  List<ReportToGet> myReports;
  List<ReportToGet> _reportsGet;
  Location _location;
  ReportToSend currReport;
  ReportToGet _currViewedReport;
  bool _loadingReport = false;

  User(String email, String uid, Level level) {
    this._email = email;
    this._uid = uid;
    this._level = level;
    myReports = new List();
    _reportsGet = new List();
  }

  Level get level => _level;

  String get uid => _uid;

  String get email => _email;

  List<ReportToGet> get reportsGet => _reportsGet;

  void setLocation(Location value) async {
    _location = value;
    notifyListeners();
  }

  Location get location => _location;

  ReportToSend initReport() {
    if (currReport == null) {
      currReport = new ReportToSend(
          images: List<ViolationImage>(),
          time: DateTime.now(),
          emailUser: _email,
          violation: Violation.values.first);
      return currReport;
    }
    return currReport;
  }

  void setViolationToReport({String newViolation}) {
    currReport.violation =
        Violation.values.firstWhere((test) => test.toString() == newViolation);
    //in order to re-render the dropdown menu with the new value
    notifyListeners();
  }

  void setLocationToReport({Location location}) {
    currReport.reportPosition = location;
    //no need to notify listeners here
  }

  void addImageToReport({ViolationImage image}) {
    currReport.addImage(image);
    notifyListeners();
  }

  void addNoteToReport(String note) {
    currReport.addNote(note);
    //no need to notify changes when typing a description
  }

  Map<MarkerId, Marker> toMarker(BuildContext context) {
    Map<MarkerId, Marker> map = Map();
    MarkerId markerId;
    var iter = _reportsGet.iterator;
    while (iter.moveNext()) {
      //check if the report is in the range of the 24 hours
      if (int.tryParse(DateTime.now()
              .difference(iter.current.time)
              .toString()
              .split(":")[0]) <
          24) {
        final markerId = MarkerId(_reportsGet.indexOf(iter.current).toString());
        final Marker marker = Marker(
            icon: !iter.current.fined
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue)
                : BitmapDescriptor.defaultMarker,
            onTap: () async {
              this.setCurrViewedReport = _reportsGet[int.parse(markerId.value)];
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<User>.value(
                        value: this,
                        child: viewReportPage(),
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

  Future getPosition() async {
    final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
    Position currentPos = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    Location l = new Location(currentPos.longitude, currentPos.latitude);
    await l.setAddress();
    if (this.currReport != null) this.setLocationToReport(location: l);
    //here I notify listeners
    this.setLocation(l);
  }

  Future getAllReports() async {
    reportsGet.clear();
    var list = await Firestore.instance.collection("users").getDocuments();
    var iter = list.documentChanges;
    for (DocumentChange doc in iter) {
      List list = doc.document.data['reportSent'];
      int i = 0;
      while (i < list.length) {
        this.reportsGet.add(ReportToGet.fromMap(
            Map<String, dynamic>.from(list[i]), doc.document.documentID));
        i++;
      }
    }
    fillMyReports();
    notifyListeners();
  }

  void fillMyReports() {
    myReports.clear();
    for (ReportToGet reportToGet in _reportsGet) {
      if (reportToGet.emailUser == this.email) myReports.add(reportToGet);
    }
  }

  bool get loadingReport => _loadingReport;

  set isLoadingReport(bool value) {
    _loadingReport = value;
    notifyListeners();
  }

  ReportToGet get currViewedReport => _currViewedReport;

  set setCurrViewedReport(ReportToGet value) {
    _currViewedReport = value;
  }

  int totalFinedReport() {
    int fined = 0, daily = 0;
    for (ReportToGet reportToGet in _reportsGet) {
      if (reportToGet.fined) fined++;
    }
    return fined;
  }

  int totalDailyReport() {
    int daily = 0;
    for (ReportToGet reportToGet in _reportsGet) {
      if (int.tryParse(DateTime.now()
              .difference(reportToGet.time)
              .toString()
              .split(":")[0]) <
          24) daily++;
    }
    return daily;
  }


   ///It returns a map that contains the most committed violations and the number of times. It is the same for all.
  Map <Violation, int> mostCommittedCrime() {
    int doubleParking = 0, parkingOnZebra = 0, parkingOnPavement = 0;
    for (ReportToGet reportToGet in _reportsGet) {
      switch (reportToGet.violation) {
        case Violation.double_parking:
          doubleParking++;
          break;
        case Violation.parking_on_zebra_crossing:
          parkingOnZebra++;
          break;
        case Violation.parking_on_pavement:
          parkingOnPavement++;
          break;
        case Violation.other_violation:
          break;
      }
    }
    var map = new Map<Violation, int>();
    if(doubleParking >= parkingOnZebra && doubleParking >= parkingOnPavement )
      map[Violation.double_parking] = doubleParking;
    else if(parkingOnZebra >= doubleParking && parkingOnZebra >= parkingOnPavement )
      map[Violation.parking_on_zebra_crossing] = parkingOnZebra;
    else if(parkingOnPavement >= doubleParking && parkingOnPavement >= parkingOnZebra )
      map[Violation.parking_on_pavement] = parkingOnPavement;
    return map;
  }

  Widget viewReportPage();
}
