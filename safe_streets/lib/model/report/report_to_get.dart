import 'package:safe_streets/model/report/report.dart';

import '../enum/violation.dart';
import '../location.dart';

class ReportToGet extends Report {
  Map<String, dynamic> sendableReport;

  ReportToGet(
      {time,
      note,
      feedback,
      reportPosition,
      violation,
      emailUser,
      imagesLite,
      marker,
      this.sendableReport})
      : super(
            time: time,
            emailUser: emailUser,
            violation: violation,
            note: note,
            reportPosition: reportPosition,
            feedback: feedback,
            imagesLite: imagesLite);

  factory ReportToGet.fromMap(Map<String, dynamic> data, String emailUser) {
    if (data == null) return null;
    var timeData = data['time'];
    var note = data['note'];
    var feedback = data['feedback'];
    var reportPositionData = data['location'];
    var violationData = data['violation'];
    var imagesLite = data['images'];

    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeData);
    String long = reportPositionData.toString().split(",").last;
    String lat = reportPositionData.toString().split(",").first;
    Location reportLocation =
        Location(double.tryParse(long), double.tryParse(lat));
    Violation violation =
        Violation.values.firstWhere((test) => test.toString() == violationData);

    return ReportToGet(
        time: time,
        emailUser: emailUser,
        feedback: feedback,
        imagesLite: Map<String, dynamic>.from(imagesLite),
        note: note,
        reportPosition: reportLocation,
        violation: violation,
        sendableReport: data);
  }
}
/*@override
  String toString() {
    try {
      return time.millisecondsSinceEpoch.toString() +
          emailUser +
          feedback.toString() +
          imagesLite.toString() +
          note +
          reportPosition.toString() +
          violation.toString();
    } catch (e, e1) {
      print(e1);
    }
    return null;
  }*/
