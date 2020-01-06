import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/user_report_visualization_manager.dart';

class ViewReportAuthority extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context);
    return WillPopScope(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.error),
                  onPressed: () async {
                    await UserReportVisualizationManager.fineReport(
                        u, _scaffoldKey, context);
                  }),
              IconButton(
                  icon: Icon(Icons.assistant_photo),
                  onPressed: () async {
                    await UserReportVisualizationManager.violationFeedback(
                        u, _scaffoldKey);
                  }),
            ],
            title: Text("Report Page"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 14.0,
                ),
                Text(u.currViewedReport.violation
                    .toString()
                    .replaceAll("_", " ")
                    .replaceAll("Violation.", "")
                    .toUpperCase()),
                SizedBox(
                  height: 14.0,
                ),
                Text(u.currViewedReport.note != null
                    ? u.currViewedReport.note
                    : "no note"),
                SizedBox(
                  height: 14.0,
                ),
                Text(u.currViewedReport.time
                    .toIso8601String()
                    .split(".")[0]
                    .replaceAll("T", " at ")),
                SizedBox(
                  height: 14.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: u.currViewedReport.imagesLite['links'].length,
                      itemBuilder: (context, int) {
                        return Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                FadeInImage.assetNetwork(
                                    placeholder: 'assets/loading.gif',
                                    image: u.currViewedReport
                                        .imagesLite['links'][int]),
                                Positioned(
                                    top: 20,
                                    right: 20,
                                    child: RaisedButton(
                                      color: Colors.blue,
                                      shape: CircleBorder(),
                                      child: Icon(Icons.assistant_photo),
                                      onPressed: () async {
                                        UserReportVisualizationManager
                                            .pictureFeedback(
                                                u, int, _scaffoldKey);
                                      },
                                    )),
                              ],
                            ),
                            Divider(
                              color: Colors.blue,
                            )
                          ],
                        );
                      }),
                )
              ],
            ),
          )),
      onWillPop: () {
        u.setCurrViewedReport = null;
        Navigator.pop(context);
        return Future(() => false);
      },
    );
  }
}
