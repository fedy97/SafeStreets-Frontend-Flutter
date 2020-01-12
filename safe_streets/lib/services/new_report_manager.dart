import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/report/violation_image.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/utilities.dart';

import 'firebase_storage_service.dart';

///It menages the sent of a new report
class NewReportManager {
  ///this method will call the plate recognizer API, and will get a Map
  ///with all the plates in the image as strings and their pixel position
  ///in the image.
  static Future<Map<String, dynamic>> recognizePlate(File f) async {
    String token = "af4446d6d28223c73ac5c091814ee32a7fce6ede";
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'upload': await dio.MultipartFile.fromFile(f.path,
            filename: f.path.split("/").last)
      });
      var http = dio.Dio();
      dio.Response response = await http.post(
          "https://api.platerecognizer.com/v1/plate-reader/",
          data: formData,
          options: dio.Options(headers: {'Authorization': 'Token $token'}));
      List resp = response.data['results'];
      double score;
      if (resp.length > 0)
        score = double.parse(response.data['results'][0]['score'].toString());
      if (resp.length > 0 && score != null && score > 0.8) {
        return {
          "plate": response.data['results'][0]['plate'].toString(),
          "score": score,
          "box": response.data['results'][0]['box']
        };
      }
    } catch (e, stack) {
      print(stack.toString());
    }
    return {"plate": "", "score": 0.0, "box": null};
  }

  ///this function is called when the user taps on the send report button,
  ///it checks if there is at least one image and if
  ///the report has already been uploaded by others.
  static Future sendReport(
      User u, BuildContext context, GlobalKey<ScaffoldState> scaffold) async {
    if (u.currReport.images.length > 0) {
      Utilities.showProgress(context);
      bool uploadAnyway = true;
      if (await alreadyExist(context, u)) {
        uploadAnyway = await Utilities.showAlert(context,
            "this report may already exist, do you want to upload it anyway?");
      }
      if (uploadAnyway) {
        /// todo aggiunto listen:false per risolvere ERROR
        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        //upload images to storage
        for (ViolationImage image in u.currReport.images) {
          image.downloadLink = await storage.uploadImages(
              image: image,
              mail: u.email,
              timestamp: u.currReport.time.millisecondsSinceEpoch,
              index: u.currReport.images.indexOf(image));
        }
        var rightTuple =
            Firestore.instance.collection("users").document(u.email);
        //upload model in map form to the database, passing links to images just produced
        await rightTuple.updateData({
          'reportSent': FieldValue.arrayUnion([u.currReport.toMap()])
        });
      }
      //delete temp images from device storage
      await u.currReport.removeAllImages();
      //reset currReport
      u.currReport = null;
      //re fetch  documents that changed
      await u.getAllReports();
      //pop the loading bar
      Navigator.pop(context);
      //return to homepage
      Navigator.pop(context);
    } else {
      final snackBar = SnackBar(
        content: Text("send at least one image"),
        key: Key("snack1"),
      );
      scaffold.currentState.showSnackBar(snackBar);
    }
  }

  ///this will check if the report that is uploading is already present in the map,
  ///checking time(in the last 24 hours), position(10 meters from other reports) and
  ///violation type. If another report with that characteristics is found, the user is asked
  ///if he wants to upload it anyway.
  static Future<bool> alreadyExist(BuildContext context, User u) async {
    for (var reportCurr in u.reportsGet) {
      //check time and violation type, if they coincide, go to next check that is the position check
      if (u.currReport.time.difference(reportCurr.time).inHours < 24 &&
          u.currReport.violation.toString() ==
              reportCurr.violation.toString()) {
        double distance = await Geolocator().distanceBetween(
            u.currReport.reportPosition.lat,
            u.currReport.reportPosition.long,
            reportCurr.reportPosition.lat,
            reportCurr.reportPosition.long);
        //position check
        if (distance < 10) {
          return true;
        }
      }
    }
    return false;
  }
}
