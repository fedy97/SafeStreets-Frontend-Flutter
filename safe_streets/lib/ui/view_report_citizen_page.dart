import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';

import '../feedback_sender.dart';

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
                  u.showProgress(context);
                  FeedbackSender.violationFeedback(u);
                  Navigator.pop(context);
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
                            child: RaisedButton(
                              color: Colors.blue,
                              child: Icon(Icons.assistant_photo),
                              onPressed: () async {
                                u.showProgress(context);
                                //TODO FeedbackSender.pictureFeedback(u, int);
                                Navigator.pop(context);
                              },
                            )),
                        //this will cover the plate only if there actually is a plate in the image
                        u.currViewedReport.imagesLite['boxes'][int].length != 1 ? Positioned(
                          left: (u.currViewedReport.imagesLite['boxes'][int]['xmin'])/2,
                          width: ((u.currViewedReport.imagesLite['boxes'][int]['xmax'])/2 - (u.currViewedReport.imagesLite['boxes'][int]['xmin'])/2),
                          top: (u.currViewedReport.imagesLite['boxes'][int]['ymin'])/2,
                          height: ((u.currViewedReport.imagesLite['boxes'][int]['ymax'])/2 - (u.currViewedReport.imagesLite['boxes'][int]['ymin'])/2),
                          child: Container(
                            color: Colors.yellow,
                          ),
                        ) : SizedBox.shrink()
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
