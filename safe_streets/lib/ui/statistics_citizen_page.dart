import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/stats_manager.dart';

///statistics citizen page

class CitizenStatistics extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);
    int finedReports = StatsManager.totalFinedReport(u);
    int dailyReports = StatsManager.totalDailyReport(u);
    var sortedMap = StatsManager.mostCommittedCrime(u);
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Select Statistics"),
          ),
          body: Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Effectiveness".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Align(
              child: Text(
                "Total reports number: " + u.reportsGet.length.toString(),
              ),
              alignment: Alignment.center,
            ),
            Align(
              child: Text(
                "Number of reports fined: " + finedReports.toString(),
              ),
              alignment: Alignment.center,
            ),
            Align(
              child: Text("Ratio: " +
                  ((finedReports / u.reportsGet.length) * 100).toString() +
                  "%"),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Daily Reports".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Align(
              child: Text("Number of reports: " + dailyReports.toString()),
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Most committed violation".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Align(
              child: Text("Violation type: " +
                  sortedMap.keys.first
                      .toString()
                      .replaceAll("_", " ")
                      .replaceAll("Violation.", "")),
              alignment: Alignment.center,
            ),
            Align(
              child:
                  Text("Committed times: " + sortedMap.values.first.toString()),
              alignment: Alignment.center,
            ),
          ]),
        ),
        onWillPop: null);
  }
}
