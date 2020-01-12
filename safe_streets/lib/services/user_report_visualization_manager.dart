import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_streets/model/user/user.dart';

///It menages the reports of the user
abstract class UserReportVisualizationManager {

  /// Check if the user has send a feedback yet fot the violation
  /// If he did not, upload a new feedback
  static Future violationFeedback(User u, GlobalKey<ScaffoldState> key) async {
    if (!u.currViewedReport.feedbackSenders.contains(u.email)) {
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      await updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });

      addViolationFeedback(u);

      await updatedTuple.updateData({
        'reportSent': FieldValue.arrayUnion([u.currViewedReport.sendableReport])
      });

      /// if there are 5 feedback, remove the report
      if (u.currViewedReport.feedback >= 5) {
        await updatedTuple.updateData({
          'reportSent':
              FieldValue.arrayRemove([u.currViewedReport.sendableReport])
        });
      }
      await u.getAllReports();
      final snackBar =
          SnackBar(content: Text("feedback to report sent successfully!"), key: Key("positiveSnack"),);
      key.currentState.showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
          content: Text("you have already given a feedback to this report!"), key: Key("negativeSnack"),);
      key.currentState.showSnackBar(snackBar);
      return;
    }
  }

  /// Function called if the user give a feedback about a report
  /// The report is updated to register the user
  static addViolationFeedback(User u){
    u.currViewedReport.sendableReport['feedback']++;
    List<String> curr = List<String>.from(
        u.currViewedReport.sendableReport['feedbackSenders']);
    curr.add(u.email);
    u.currViewedReport.sendableReport['feedbackSenders'] = curr;
    u.currViewedReport.feedbackSenders.add(u.email);
  }

  /// Check if the user has already sent a feedback for the picture
  /// If he has not, send a new feedback
  static Future pictureFeedback(
      User u, int pictureNumber, GlobalKey<ScaffoldState> key) async {
    /// check if the user already gave a feedback about the picture
    String feedbackSenders = List<String>.from(
            u.currViewedReport.sendableReport['images']['imageFeedbackSenders'])
        .elementAt(pictureNumber);
    bool userFound = false;
    List<String> feedbacker = feedbackSenders.split(" ");
    for (String x in feedbacker) {
      if (x == u.email) userFound = true;
    }
    if (userFound) {
      final snackBar = SnackBar(
          content: Text("you have already given a feedback to this picture!"));
      key.currentState.showSnackBar(snackBar);
      return;
    } else {
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      await updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });

      /// if at least 4 feedback, remove the picture
      if (List<int>.from(
                  u.currViewedReport.sendableReport['images']['imageFeedback'])
              .elementAt(pictureNumber) >=
          4) {
        /// if last picture with 4 report, delete the report
        if (u.currViewedReport.sendableReport['images']['links'].length <= 1) {
          final snackBar =
              SnackBar(content: Text("picture feedback sent successfully!"));
          key.currentState.showSnackBar(snackBar);
          return;
        }

        /// if 4 report but more than 1 picture, delete the picture
        else {

          deletePicture(u, pictureNumber);

          await updatedTuple.updateData({
            'reportSent':
                FieldValue.arrayUnion([u.currViewedReport.sendableReport])
          });
          //u.currReport.images.removeAt(pictureNumber);
        }
      }

      /// if less than 4 feedback, add one
      else {
        addFeedbackToPicture(u, pictureNumber);
        await updatedTuple.updateData({
          'reportSent':
              FieldValue.arrayUnion([u.currViewedReport.sendableReport])
        });
      }

      await u.getAllReports();
      final snackBar =
          SnackBar(content: Text("picture feedback sent successfully!"));
      key.currentState.showSnackBar(snackBar);
    }
  }

  /// Increment the feedback number of a picture and add the email of the user to the list of feedback senders
  static addFeedbackToPicture(User u, int pictureNumber){
    List<int> feedbackCounter = List<int>.from(
        u.currViewedReport.sendableReport['images']['imageFeedback']);
    feedbackCounter.replaceRange(pictureNumber, pictureNumber + 1,
        [feedbackCounter.elementAt(pictureNumber) + 1]);
    List<String> curr1 = List<String>.from(u
        .currViewedReport.sendableReport['images']['imageFeedbackSenders']);
    curr1.replaceRange(pictureNumber, pictureNumber + 1,
        [curr1.elementAt(pictureNumber) + " " + u.email]);
    List<int> curr2 = List<int>.from(
        u.currViewedReport.sendableReport['images']['imageFeedback']);
    curr2.replaceRange(pictureNumber, pictureNumber + 1,
        [curr2.elementAt(pictureNumber) + 1]);
    u.currViewedReport.sendableReport['images']['imageFeedbackSenders'] =
        curr1;
    u.currViewedReport.sendableReport['images']['imageFeedback'] = curr2;
    u.currViewedReport.imagesLite['imageFeedbackSenders'] = curr1;
    u.currViewedReport.imagesLite['imageFeedback'] = curr2;
  }

  /// delete the picture defined by pictureNumber from the report that is ready to be uploaded
  static deletePicture(User u, int pictureNumber){
    var images = u.currViewedReport.sendableReport['images'];
    List<String> accuracy = List<String>.from(images['accuracy']);
    accuracy.removeAt(pictureNumber);
    List<Map<dynamic, dynamic>> boxes =
    List<Map<dynamic, dynamic>>.from(images['boxes']);
    boxes.removeAt(pictureNumber);
    List<int> imageFeedback = List<int>.from(images['imageFeedback']);
    imageFeedback.removeAt(pictureNumber);
    List<String> imageFeedbackSenders =
    List<String>.from(images['imageFeedbackSenders']);
    imageFeedbackSenders.removeAt(pictureNumber);
    List<String> links = List<String>.from(images['links']);
    links.removeAt(pictureNumber);
    List<String> plates = List<String>.from(images['plates']);
    plates.removeAt(pictureNumber);
    u.currViewedReport.sendableReport['images']['accuracy'] = accuracy;
    u.currViewedReport.sendableReport['images']['boxes'] = boxes;
    u.currViewedReport.sendableReport['images']['imageFeedback'] =
        imageFeedback;
    u.currViewedReport.sendableReport['images']['imageFeedbackSenders'] =
        imageFeedbackSenders;
    u.currViewedReport.sendableReport['images']['links'] = links;
    u.currViewedReport.sendableReport['images']['plates'] = plates;
  }

  static Future fineReport(
      User u, GlobalKey<ScaffoldState> key, BuildContext context) async {
    ///check if it is already fined THIS report
    if (u.currViewedReport.fined == true) {
      final snackBar = SnackBar(content: Text("already fined"));
      key.currentState.showSnackBar(snackBar);
      return;
    }

    ///check if the report actually contains a plate
    List<String> plates = new List();
    for (String plate in u.currViewedReport.imagesLite['plates']) {
      if (plate != "") plates.add(plate);
    }
    if (plates.length > 0) {
      ///now we are good to go
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      await updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });
      u.currViewedReport.sendableReport['fined'] = true;
      await updatedTuple.updateData({
        'reportSent': FieldValue.arrayUnion([u.currViewedReport.sendableReport])
      });

      String onePlate = plates[0];

      ///check if already present in db a fine with that plate
      ///if so, increment the counter else set counter to 1 and create the fine tuple
      var doc =
          await Firestore.instance.collection("fines").document(onePlate).get();
      if (!doc.exists)
        await Firestore.instance
            .collection("fines")
            .document(onePlate)
            .setData({"count": 1});
      else
        await Firestore.instance
            .collection("fines")
            .document(onePlate)
            .updateData({'count': FieldValue.increment(1)});

      ///update the report locally
      u.currViewedReport.fined = true;
      final snackBar = SnackBar(content: Text("report fined successfully"));
      key.currentState.showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text("no plates here"));
      key.currentState.showSnackBar(snackBar);
      return;
    }
  }
}
