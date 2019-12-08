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
    if (!u.currViewedReport.imagesLite['imageFeedbackSenders']
        .contains(u.email)) {
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });

      u.currViewedReport.sendableReport['images']['imageFeedback']++;
      List<List<String>> curr = List<List<String>>.from(
          u.currViewedReport.sendableReport['image.imageFeedbackSenders']);
      curr.elementAt(pictureNumber).add(u.email);
      u.currViewedReport.sendableReport['image.imageFeedbackSenders'] = curr;
      print(curr);
      updatedTuple.updateData({
        'reportSent': FieldValue.arrayUnion([u.currViewedReport.sendableReport])
      });
      u.currViewedReport.imagesLite['imageFeedbackSenders'[pictureNumber]]
          .add(u.email);
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
}
