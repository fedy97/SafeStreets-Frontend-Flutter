import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/utilities.dart';

///here is the list page of all the reports
///submitted by the logged user

class MyReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Reports"),
        ),
        body: ListView.builder(
            itemCount: u.myReports.length,
            itemBuilder: (context, int) {
              return ListTile(

                  ///this will open the report on tap
                  onTap: () async {
                    u.setCurrViewedReport = u.myReports[int];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<User>.value(
                              value: u,
                              child: u.viewReportPage(),
                            )));
                  },
                  leading: Icon(Icons.report_problem),
                  key: Key("reportTile"),
                  title: Text("Report ${int + 1}, " +
                      u.myReports[int].time.toIso8601String()),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      key: Key("deleteReportButton"),
                      onPressed: () async {
                        Utilities.showProgress(context);
                        var rightTuple = Firestore.instance
                            .collection("users")
                            .document(u.email);
                        await rightTuple.updateData({
                          'reportSent': FieldValue.arrayRemove(
                              [u.myReports[int].sendableReport])
                        });
                        await u.getAllReports();
                        //pop loading bar
                        Navigator.pop(context);
                      }));
            }),
      ),
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        return Future(() => false);
      },
    );
  }
}
