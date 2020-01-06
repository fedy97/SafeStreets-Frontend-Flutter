import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/violation_image.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/new_report_manager.dart';
import 'package:safe_streets/services/utilities.dart';

class CreateReportPage extends StatelessWidget {
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
                        Utilities.showProgress(context);
                        if (u.currReport.images.length == 0) {
                          await u.getPosition();
                        }
                        Map m = await NewReportManager.recognizePlate(f);
                        ViolationImage vi = new ViolationImage(
                            box: m["box"],
                            imageFile: f,
                            plate: m["plate"],
                            accuracy: m["score"]);
                        //this will rebuild gui , because it calls notify listeners
                        u.addImageToReport(image: vi);
                        Navigator.pop(context);
                      }
                    }
                  }),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    await NewReportManager.sendReport(u, context, _scaffoldKey);
                  })
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 14.0),
                TextFormField(
                  onChanged: (currDescription) =>
                      u.addNoteToReport(currDescription),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    helperText: 'Write some additional notes',
                    labelText: 'Note',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 14.0),
                DropdownButton<String>(
                  hint: Text("choose a violation"),
                  icon: Icon(Icons.drive_eta),
                  value: u.currReport.violation.toString(),
                  items: (violations).map((Violation value) {
                    return new DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value
                          .toString()
                          .replaceAll("_", " ")
                          .replaceAll("Violation.", "")
                          .toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (String newViolation) {
                    u.setViolationToReport(newViolation: newViolation);
                  },
                ),
                SizedBox(height: 14.0),
                Expanded(
                  child: ListView.builder(
                      itemCount: u.currReport.images.length,
                      itemBuilder: (context, int) {
                        return Column(
                          children: <Widget>[
                            Image.file(u.currReport.images[int].imageFile),
                            Divider(
                              color: Colors.blue,
                            )
                          ],
                        );
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
}
