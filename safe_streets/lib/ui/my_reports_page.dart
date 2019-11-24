import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';

class MyReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: u.myReports.length,
          itemBuilder: (context, int) {
            return ListTile(
                leading: Icon(Icons.report_problem),
                title: Text("Report ${int + 1}, " +
                    u.myReports[int].time.toIso8601String()),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      u.showProgress(context);
                      var rightTuple = Firestore.instance
                          .collection("users")
                          .document(u.email);
                      await rightTuple.updateData({
                        'reportSent': FieldValue.arrayRemove(
                            [u.myReports[int].sendableReport])
                      });
                      await u.getAllReports();
                      Navigator.pop(context);
                    }));
          }),
    );
  }
}
