import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';

///this is the abstract class of a user in SafeStreets,
///a user can be either Citizen or Authority.

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

  void updateUI() {
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

  Widget viewReportPage();
  Widget viewStatisticsPage();
}
