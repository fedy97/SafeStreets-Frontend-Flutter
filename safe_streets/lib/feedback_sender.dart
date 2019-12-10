import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user/user.dart';

abstract class FeedbackSender {
  static Future violationFeedback(
    User u,
  ) async {
    if (!u.currViewedReport.feedbackSenders.contains(u.email)) {
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });
      u.currViewedReport.sendableReport['feedback']++;
      List<String> curr = List<String>.from(
          u.currViewedReport.sendableReport['feedbackSenders']);
      curr.add(u.email);
      u.currViewedReport.sendableReport['feedbackSenders'] = curr;
      updatedTuple.updateData({
        'reportSent': FieldValue.arrayUnion([u.currViewedReport.sendableReport])
      });
      u.currViewedReport.feedbackSenders.add(u.email);
      // if there are 5 feedback, remove the report
      if (u.currViewedReport.feedback >= 5) {
        updatedTuple.updateData({
          'reportSent':
              FieldValue.arrayRemove([u.currViewedReport.sendableReport])
        });
      }
      await u.getAllReports();
    }
  }

  static Future pictureFeedback(User u, int pictureNumber) async {
    // check if the user already gave a feedback about the picture
    String feedbackSenders = List<String>.from(
            u.currViewedReport.sendableReport['images']['imageFeedbackSenders'])
        .elementAt(pictureNumber);
    bool userFound = false;
    List<String> feedbacker = feedbackSenders.split(" ");
    for (String x in feedbacker) {
      if (x == u.email) userFound = true;
    }
    if (userFound)
      return;
    else {
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });

      if (u.currViewedReport.sendableReport['images']['imageFeedback'].elementAt(pictureNumber) >= 4) {
        // if last picture with 4 report, delete the report
        if (u.currViewedReport.sendableReport['images'].size() <= 1)
          return;
        // if 4 report but more than 1 picture, delete the picture
        else {
          var images = u.currViewedReport.sendableReport['images'];
          images['accuracy'].removeAt(pictureNumber);
          images['boxes'].removeAt(pictureNumber);
          images['imageFeedback'].removeAt(pictureNumber);
          images['imageFeedbackSenders'].removeAt(pictureNumber);
          images['links'].removeAt(pictureNumber);
          images['plates'].removeAt(pictureNumber);
          updatedTuple.updateData({
            'reportSent':
            FieldValue.arrayUnion([u.currViewedReport.sendableReport])
          });
          u.currViewedReport.images.removeAt(pictureNumber);
        }
      }
      // if less than 4 feedback, add one
      else {
        List<int> feedbackCounter = List<int>.from(
            u.currViewedReport.sendableReport['images']['imageFeedback']);
        feedbackCounter.replaceRange(pictureNumber, pictureNumber + 1,
            [feedbackCounter.elementAt(pictureNumber) + 1]);
        List<String> curr1 = List<String>.from(u.currViewedReport
            .sendableReport['images']['imageFeedbackSenders']);
        curr1.replaceRange(pictureNumber, pictureNumber + 1,
            [curr1.elementAt(pictureNumber) + " " + u.email]);
        List<int> curr2 = List<int>.from(
            u.currViewedReport.sendableReport['images']['imageFeedback']);
        curr2.replaceRange(pictureNumber, pictureNumber + 1,
            [curr2.elementAt(pictureNumber) + 1]);
        u.currViewedReport.sendableReport['images']['imageFeedbackSenders'] =
            curr1;
        u.currViewedReport.sendableReport['images']['imageFeedback'] = curr2;
        updatedTuple.updateData({
          'reportSent':
          FieldValue.arrayUnion([u.currViewedReport.sendableReport])
        });
        u.currViewedReport.imagesLite['imageFeedbackSenders'] = curr1;
        u.currViewedReport.imagesLite['imageFeedback'] = curr2;
      }

      await u.getAllReports();
    }
  }
}
