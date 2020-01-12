import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/user_report_visualization_manager.dart';

void main() {
  User u = new Citizen("test@test.com", "test");
  List<ViolationImage> images = List<ViolationImage>();
  images.add(ViolationImage(imageFile: null, plate: "", accuracy: 1.0, box: new Map(), downloadLink: "linkToImageOne", feedback: 4, imageFeedbackSenders: ["feedbacksendersFirstImage"]));
  images.add(ViolationImage(imageFile: null, plate: "aaaaaa", accuracy: 3.0, box: new Map(), downloadLink: "linkToImageTwo", feedback: 2, imageFeedbackSenders: ["feedbacksendersSecondImage"]));
  u.currViewedReport = new ReportToGet(
      time: DateTime.now(),
      emailUser: u.email,
      feedback: 1,
      feedbackSenders: ["firstFeedbacker@mail.com"],
      sendableReport: ReportToSend(
              feedback: 1,
              feedbackSenders: ["firstFeedbacker@mail.com"],
              time: DateTime.now(),
              emailUser: u.email,
              images: images,
              reportPosition: Location(0.0, 0.0))
          .toMap());

  u.currViewedReport.feedback = 1;
  u.currViewedReport.feedbackSenders = new List<String>();
  u.currViewedReport.feedbackSenders.add(u.email);
  u.currViewedReport.sendableReport["feedback"] = 1;
  u.currViewedReport.sendableReport["feedbackSenders"] = [
    "firstFeedbacker@mail.com"
  ];

  group("Feedback test", () {
    test("Add the user to the violation feedbacker", () {
      //Setup
      //Run
      UserReportVisualizationManager.addViolationFeedback(u);
      //Verify
      expect(u.currViewedReport.sendableReport["feedback"], 2);
      expect(u.currViewedReport.sendableReport["feedbackSenders"].length, 2);
      expect(
          List<String>.from(
                  u.currViewedReport.sendableReport["feedbackSenders"])
              .elementAt(1),
          u.email);
      expect(u.currViewedReport.feedbackSenders.length, 2);
      expect(u.currViewedReport.feedbackSenders.elementAt(1), u.email);
    });

    test("Add a feedback to a picture", () {
      //Setup
      u.currViewedReport.imagesLite = u.currViewedReport.sendableReport["images"];
      int feedbackNumberFirstImage = u.currViewedReport.sendableReport["images"]["imageFeedback"].elementAt(0);
      int feedbackNumberSecondImage = u.currViewedReport.sendableReport["images"]["imageFeedback"].elementAt(1);
      String feedbacKSendersFirstImage = u.currViewedReport.sendableReport["images"]["imageFeedbackSenders"].elementAt(0);
      String feedbacKSendersSecondImage = u.currViewedReport.sendableReport["images"]["imageFeedbackSenders"].elementAt(1);
      //Run
      UserReportVisualizationManager.addFeedbackToPicture(u, 1);
      //Verify
      expect(u.currViewedReport.sendableReport["images"]["imageFeedback"].elementAt(0), feedbackNumberFirstImage);
      expect(u.currViewedReport.sendableReport["images"]["imageFeedback"].elementAt(1), feedbackNumberSecondImage + 1);
      expect(u.currViewedReport.sendableReport["images"]["imageFeedbackSenders"].elementAt(0), feedbacKSendersFirstImage);
      expect(u.currViewedReport.sendableReport["images"]["imageFeedbackSenders"].elementAt(1), feedbacKSendersSecondImage + " " + u.email);

    });

    test("Delete one picture from the sendable report", () {
      //Setup
      String secondLink = u.currViewedReport.sendableReport["images"]["links"].elementAt(1);
      String reporterSecondImage = u.currViewedReport.sendableReport["images"]["imageFeedbackSenders"].elementAt(1);
      //Run
      UserReportVisualizationManager.deletePicture(u, 0);
      //Verify
      expect(u.currViewedReport.sendableReport["images"]["imageFeedback"].length, 1);
      expect(u.currViewedReport.sendableReport["images"]["imageFeedbackSenders"].length, 1);
      expect(u.currViewedReport.sendableReport["images"]["links"].length, 1);
      expect(u.currViewedReport.sendableReport["images"]["links"].elementAt(0), secondLink);
      expect(u.currViewedReport.sendableReport["images"]["imageFeedbackSenders"].elementAt(0), reporterSecondImage);
    });

  });
}
