import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/firebase_storage_service.dart';

class CreateReportPage extends StatelessWidget {
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);
    final violations = Violation.values;
    ReportToSend reportToSend = u.initReport();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(u.location.address == null ? "" : u.location.address),
            Text((reportToSend == null || reportToSend.images.length == 0)
                ? ""
                : reportToSend.images.last.plate),
            TextField(
              onChanged: (currDescription) =>
                  u.addNoteToReport(currDescription),
              decoration: InputDecoration(hintText: "brief description"),
            ),
            DropdownButton<String>(
              hint: Text("choose a violation"),
              icon: Icon(Icons.drive_eta),
              value: reportToSend.violation.toString(),
              items: (violations).map((Violation value) {
                return new DropdownMenuItem<String>(
                  value: value.toString(),
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (String newViolation) {
                u.setViolationToReport(
                    reportToSend: reportToSend, newViolation: newViolation);
              },
            ),
            IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  if (reportToSend.images.length < 5) {
                    File f = await ImagePicker.pickImage(
                        source: ImageSource.camera, imageQuality: 50);
                    //check if I actually took the photo or I pressed "back"
                    if (f != null) {
                      if (reportToSend.images.length == 0) await _getPosition(u);
                      Map m = await _recognizePlate(f);
                      ViolationImage vi = new ViolationImage(
                          imageFile: f,
                          plate: m.keys.first,
                          accuracy: m.values.first);
                      //this will rebuild gui , because it calls notify listeners
                      u.addImageToReport(image: vi, reportToSend: reportToSend);
                    }
                  }
                }),
            Expanded(
              child: ListView.builder(
                  itemCount: reportToSend.images.length,
                  itemBuilder: (context, int) {
                    return Image.file(reportToSend.images[int].imageFile);
                  }),
            ),
            RaisedButton(
              child: Text("Send"),
              onPressed: () async {
                if (reportToSend.images.length > 0) {
                  final storage = Provider.of<FirebaseStorageService>(context);
                  //upload images to storage
                  reportToSend.downloadUrlImages = await storage.uploadImages(
                      images: reportToSend.images,
                      mail: u.email,
                      timestamp: reportToSend.time.millisecondsSinceEpoch);
                  var rightTuple =
                      Firestore.instance.collection("users").document(u.email);
                  //upload model in map form to the database, passing links to images just produced
                  await rightTuple.updateData({
                    'reportSent': FieldValue.arrayUnion([reportToSend.toMap()])
                  });
                  //delete temp images from device storage
                  await reportToSend.removeAllImages();
                  //add report to user reports
                  u.addReportToList(reportToSend);
                  //reset currReport
                  u.currReport = null;
                  Navigator.pop(context);
                } else {
                  final snackBar =
                      SnackBar(content: Text("send at least one image"));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future _getPosition(User user) async {
    Position currentPos = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    Location l = new Location(currentPos.longitude, currentPos.latitude);
    user.setLocationToReport(reportToSend: user.currReport, location: l);
    //here I notify listeners
    user.setLocation(l);
  }

  Future<Map<String, double>> _recognizePlate(File f) async {
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
        return {response.data['results'][0]['plate'].toString(): score};
      }
    } catch (e, stack) {
      print(stack.toString());
    }
    return {"": 0};
  }

/*Future<String> _recognizeText(List<ViolationImage> pictures) async {
    String plate = "";
    final FirebaseVisionImage file =
        FirebaseVisionImage.fromFile(pictures[0].imageFile);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(file);
    final String text = visionText.text;
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;
      plate += '$text\n';
    }
    return plate;
  }*/
}
