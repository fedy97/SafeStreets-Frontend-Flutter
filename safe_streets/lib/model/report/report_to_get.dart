import 'package:safe_streets/model/report/report.dart';

import '../enum/violation.dart';
import '../location.dart';

///this class is used to create report objects that are fetched
///as maps from firebase, in fact there is a constructor "fromMap" that builds
///the object from that map.

class ReportToGet extends Report {
  Map<String, dynamic> sendableReport;

  ReportToGet(
      {time,
      note,
      feedback,
      feedbackSenders,
      reportPosition,
      violation,
      emailUser,
      imagesLite,
      marker,
      this.sendableReport,
      fined})
      : super(
            time: time,
            emailUser: emailUser,
            violation: violation,
            note: note,
            reportPosition: reportPosition,
            feedback: feedback,
            feedbackSenders: feedbackSenders,
            imagesLite: imagesLite,
            fined: fined,
  );

  factory ReportToGet.fromMap(Map<String, dynamic> data, String emailUser) {
    if (data == null) return null;
    var timeData = data['time'];
    var note = data['note'];
    var feedback = data['feedback'];
    var reportPositionData = data['location'];
    var violationData = data['violation'];
    var imagesLite = data['images'];
    var feedbackSenders = data['feedbackSenders'];
    var fined = data['fined'];
    var zone = data['zone'];

    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeData);
    String long = reportPositionData.toString().split(",").last;
    String lat = reportPositionData.toString().split(",").first;
    Location reportLocation =
        Location(double.tryParse(long), double.tryParse(lat));
    reportLocation.address = zone;
    reportLocation.city = reportLocation.address.split(",")[0];
    Violation violation =
        Violation.values.firstWhere((test) => test.toString() == violationData);

    return ReportToGet(
        time: time,
        emailUser: emailUser,
        feedback: feedback,
        feedbackSenders: List<String>.from(feedbackSenders),
        imagesLite: Map<String, dynamic>.from(imagesLite),
        note: note,
        reportPosition: reportLocation,
        violation: violation,
        sendableReport: data,
        fined: fined);
  }
}
