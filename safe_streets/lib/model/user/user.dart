import 'package:flutter/cupertino.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';

abstract class User extends ChangeNotifier {
  String _email;
  String _uid;
  Level _level;
  List<ReportToSend> myReports;
  Location _location;
  ReportToSend currReport;

  User(String email, String uid, Level level) {
    this._email = email;
    this._uid = uid;
    this._level = level;
    myReports = new List();
    _location = new Location(0.0, 0.0);
  }

  Level get level => _level;

  String get uid => _uid;

  String get email => _email;

  bool isAuthority() {
    return level.toString() == "standard" ? false : true;
  }

  void setLocation(Location value) async {
    _location = value;
    await _location.setAddress();
    notifyListeners();
  }

  Location get location => _location;

  ReportToSend initReport() {
    if (currReport == null) {
      currReport = new ReportToSend(time: DateTime.now(), emailUser: _email, violation: Violation.values.first);
      return currReport;
    }
    return currReport;
  }

  void setViolationToReport({ReportToSend reportToSend, String newViolation}){
    reportToSend.violation = Violation.values.firstWhere((test) => test.toString() == newViolation);
    notifyListeners();
  }
  //TODO @arg reportToSend is actually currReport, can be omitted
  void setLocationToReport({Location location, ReportToSend reportToSend}){
    reportToSend.reportPosition = location;
    //no need to notify listeners here
  }

  void addImageToReport({ViolationImage image, ReportToSend reportToSend}) {
    reportToSend.addImage(image);
    notifyListeners();
  }

  void addNoteToReport(String note) {
    currReport.addNote(note);
    //no need to notify changes when typing a description
  }

  void removeLastReport() {
    myReports.last.removeAllImages();
    myReports.removeLast();
    notifyListeners();
  }
  void addReportToList(ReportToSend reportToSend){
    myReports.add(reportToSend);
    notifyListeners();
  }
}
