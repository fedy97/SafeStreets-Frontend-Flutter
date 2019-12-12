import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/user/user.dart';

abstract class FeedbackSender {
  static Future violationFeedback(User u, GlobalKey<ScaffoldState> key) async {
    if (!u.currViewedReport.feedbackSenders.contains(u.email)) {
      var updatedTuple = Firestore.instance
          .collection("users")
          .document(u.currViewedReport.emailUser);
      await updatedTuple.updateData({
        'reportSent':
            FieldValue.arrayRemove([u.currViewedReport.sendableReport])
      });
      u.currViewedReport.sendableReport['feedback']++;
      List<String> curr = List<String>.from(
          u.currViewedReport.sendableReport['feedbackSenders']);
      curr.add(u.email);
      u.currViewedReport.sendableReport['feedbackSenders'] = curr;
      await updatedTuple.updateData({
        'reportSent': FieldValue.arrayUnion([u.currViewedReport.sendableReport])
      });
      u.currViewedReport.feedbackSenders.add(u.email);
      // if there are 5 feedback, remove the report
      if (u.currViewedReport.feedback >= 5) {
        await updatedTuple.updateData({
          'reportSent':
              FieldValue.arrayRemove([u.currViewedReport.sendableReport])
        });
      }
      await u.getAllReports();
    } else {
      final snackBar = SnackBar(
          content: Text("you have already given a feedback to this report!"));
      key.currentState.showSnackBar(snackBar);
      return;
    }
  }

  static Future pictureFeedback(
      User u, int pictureNumber, GlobalKey<ScaffoldState> key) async {
    // check if the user already gave a feedback about the picture
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

      if (u.currViewedReport.sendableReport['images']['imageFeedback']
              .elementAt(pictureNumber) >=
          4) {
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
          await updatedTuple.updateData({
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
        await updatedTuple.updateData({
          'reportSent':
              FieldValue.arrayUnion([u.currViewedReport.sendableReport])
        });
        u.currViewedReport.imagesLite['imageFeedbackSenders'] = curr1;
        u.currViewedReport.imagesLite['imageFeedback'] = curr2;
      }

      await u.getAllReports();
    }
  }

  static Future fineReport(User u, GlobalKey<ScaffoldState> key) async {
    //check if it is already fined THIS report
    if (u.currViewedReport.fined == true) {
      final snackBar = SnackBar(content: Text("already fined"));
      key.currentState.showSnackBar(snackBar);
      return;
    }
    //check if the report actually contains a plate
    String onePlate = "";
    for (String plate in u.currViewedReport.imagesLite['plates']) {
      if (plate != "") onePlate = plate;
    }
    if (onePlate != "") {
      //now we are good to go
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
      //check if already present in db a fine with that plate
      //if so, increment the counter else set counter to 1 and create the fine tuple
      var doc = await Firestore.instance.collection("fines").document(onePlate).get();
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
      //update the report locally
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
