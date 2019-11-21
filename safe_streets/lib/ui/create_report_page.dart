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
    u.initReport();
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Create Report"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    if (u.currReport.images.length < 5) {
                      File f = await ImagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);
                      //check if I actually took the photo or I pressed "back"
                      if (f != null) {
                        showProgress(context);
                        if (u.currReport.images.length == 0)
                          await u.getPosition();
                        Map m = await _recognizePlate(f);
                        ViolationImage vi = new ViolationImage(
                            imageFile: f,
                            plate: m.keys.first,
                            accuracy: m.values.first);
                        //this will rebuild gui , because it calls notify listeners
                        u.addImageToReport(
                            image: vi, reportToSend: u.currReport);
                        Navigator.pop(context);
                      }
                    }
                  }),
              _buttonTopRight(u, context)
            ],
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (currDescription) =>
                      u.addNoteToReport(currDescription),
                  decoration: InputDecoration(hintText: "brief description"),
                ),
                DropdownButton<String>(
                  hint: Text("choose a violation"),
                  icon: Icon(Icons.drive_eta),
                  value: u.currReport.violation.toString(),
                  items: (violations).map((Violation value) {
                    return new DropdownMenuItem<String>(
                      value: value.toString(),
                      child: new Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String newViolation) {
                    u.setViolationToReport(
                        reportToSend: u.currReport, newViolation: newViolation);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: u.currReport.images.length,
                      itemBuilder: (context, int) {
                        return Image.file(u.currReport.images[int].imageFile);
                      }),
                )
              ],
            ),
          ),
        ),
        onWillPop: () {
          u.currReport.removeAllImages();
          u.currReport = null;
          Navigator.pop(context);
          return Future(() => false);
        });
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

  Widget _buttonTopRight(User u, BuildContext context) {
    if (!u.loadingReport) {
      return IconButton(
          icon: Icon(Icons.send),
          onPressed: () async {
            if (u.currReport.images.length > 0) {
              u.isLoadingReport = true;
              final storage = Provider.of<FirebaseStorageService>(context);
              //upload images to storage
              for (ViolationImage image in u.currReport.images) {
                image.downloadLink = await storage.uploadImages(
                    image: image,
                    mail: u.email,
                    timestamp: u.currReport.time.millisecondsSinceEpoch);
              }
              var rightTuple =
                  Firestore.instance.collection("users").document(u.email);
              //upload model in map form to the database, passing links to images just produced
              await rightTuple.updateData({
                'reportSent': FieldValue.arrayUnion([u.currReport.toMap()])
              });
              //delete temp images from device storage
              await u.currReport.removeAllImages();
              //add report to user reports
              u.addReportToList(u.currReport);
              //reset currReport
              u.currReport = null;
              //re fetch  documents that changed
              await u.getAllReports();
              u.isLoadingReport = false;
              Navigator.pop(context);
            } else {
              final snackBar =
                  SnackBar(content: Text("send at least one image"));
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }
          });
    } else
      return CircularProgressIndicator(
        backgroundColor: Colors.cyanAccent,
      );
  }

  void showProgress(BuildContext context) {
    showDialog(context: context,builder: (context2) {
      return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            SizedBox(width: 10.0,),
            new Text("Loading"),
          ],
        ),
      );
    });
  }

/*Widget _displayImages(User u) {
    if (!u.loadingImage) {
      return Expanded(
        child: ListView.builder(
            itemCount: u.currReport.images.length,
            itemBuilder: (context, int) {
              return Image.file(u.currReport.images[int].imageFile);
            }),
      );
    } else {
      return Expanded(
        child: ListView.builder(
            itemCount: lengthImages,
            itemBuilder: (context, int) {
              if (int != lengthImages-1)
                return Image.file(u.currReport.images[int].imageFile);
              else
                return SizedBox(child: CircularProgressIndicator(),height: 5.0,width: 5.0,);
            }),
      );
    }
  }*/
}
