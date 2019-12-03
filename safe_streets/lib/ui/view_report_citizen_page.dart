import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';

class ViewReportCitizen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.assistant_photo),
                onPressed: () async {
                  if (!u.currViewedReport.feedbackSenders.contains(u.email)) {
                    u.showProgress(context);
                    var updatedTuple = Firestore.instance
                        .collection("users")
                        .document(u.currViewedReport.emailUser);
                    updatedTuple.updateData({
                      'reportSent':
                      FieldValue.arrayRemove([u.currViewedReport.sendableReport])
                    });
                    u.currViewedReport.sendableReport['feedback']++;
                    List<String> curr = List<String>.from(u.currViewedReport.sendableReport['feedbackSenders']);
                    curr.add(u.email);
                    u.currViewedReport.sendableReport['feedbackSenders'] = curr;
                    updatedTuple.updateData({
                      'reportSent':
                      FieldValue.arrayUnion([u.currViewedReport.sendableReport])
                    });
                    u.currViewedReport.feedbackSenders.add(u.email);
                    await u.getAllReports();
                    Navigator.pop(context);
                  }
                })
          ],
          title: Text("Report Page"),
        ),
        body: Column(
          children: <Widget>[
            Text(u.currViewedReport.violation
                .toString()
                .replaceAll("_", " ")
                .replaceAll("Violation.", "")
                .toUpperCase()),
            Text(u.currViewedReport.note != null
                ? u.currViewedReport.note
                : "no note"),
            Text(u.currViewedReport.time
                .toIso8601String()
                .split(".")[0]
                .replaceAll("T", " at ")),
            Expanded(
              child: ListView.builder(
                  itemCount: u.currViewedReport.imagesLite['links'].length,
                  itemBuilder: (context, int) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child: Image.network(
                                u.currViewedReport.imagesLite['links'][int])),
                        Positioned(
                            top: 20,
                            right: 20,
                            child: IconButton(
                              icon: Icon(Icons.assistant_photo),
                              onPressed: () async {
                                //TODO send feedback
                              },
                            )),
                        //this will cover the plate
                        Positioned(
                          bottom: 10,
                          height: 50,
                          width: 50,
                          child: Container(
                            color: Colors.yellow,
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      onWillPop: () {
        u.setCurrViewedReport = null;
        Navigator.pop(context);
        return Future(() => false);
      },
    );
  }
}
