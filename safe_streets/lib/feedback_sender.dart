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
    String feedbackSenders = List<String>.from(u.currViewedReport.sendableReport['images']['imageFeedbackSenders']).elementAt(pictureNumber);
    bool userFound = false;
    List<String> feedbacker = feedbackSenders.split(" ");
    for (String x in feedbacker){
      if (x == u.email) userFound = true;
    }
    if (!userFound) {
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });

      List<int> feedbackCounter = List<int>.from(u.currViewedReport.sendableReport['images']['imageFeedback']);
      feedbackCounter.replaceRange(pictureNumber, pictureNumber, [feedbackCounter.elementAt(pictureNumber) + 1]);
      List<String> curr1 = List<String>.from(
          u.currViewedReport.sendableReport['images']['imageFeedbackSenders']);
      curr1.replaceRange(pictureNumber, pictureNumber, [curr1.elementAt(pictureNumber) + " " + u.email]);
      List<int> curr2 = List<int>.from(u.currViewedReport.sendableReport['images']['imageFeedback']);
      curr2.replaceRange(pictureNumber, pictureNumber, [curr2.elementAt(pictureNumber) + 1]);
      u.currViewedReport.sendableReport['images']['imageFeedbackSenders'] = curr1;
      u.currViewedReport.sendableReport['images']['imageFeedback'] = curr2;
      updatedTuple.updateData({
        'reportSent': FieldValue.arrayUnion([u.currViewedReport.sendableReport])
      });
      u.currViewedReport.imagesLite['imageFeedbackSenders'] = curr1;
      u.currViewedReport.imagesLite['imageFeedback'] = curr2;
      // TODO if there are 5 feedback, remove the
      /*if (List<int>.from(u.currViewedReport.imagesLite['imageFeedback']).elementAt(pictureNumber) >= 5) {
        updatedTuple.updateData({
          'reportSent':
              FieldValue.arrayRemove(u.currViewedReport.sendableReport['images'])
        });
      }
      await u.getAllReports();*/
    }
  }
}
