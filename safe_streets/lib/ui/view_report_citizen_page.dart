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
          title: Text("Report Page"),
        ),
        body: ListView.builder(
            itemCount: u.currViewedReport.imagesLite['links'].length,
            shrinkWrap: true,
            itemBuilder: (context, int) {
              return Image.network(u.currViewedReport.imagesLite['links'][int]);
            }),
      ),
      onWillPop: () {
        u.setCurrViewedReport = null;
        Navigator.pop(context);
        return Future(() => false);
      },
    );
  }
}
