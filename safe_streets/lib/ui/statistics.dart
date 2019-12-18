import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/stats_manager.dart';

class Statistics extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Text(
                "Number of reports fined: " + finedReports.toString(),
              ),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Text("Ratio: " +
                  ((finedReports / u.reportsGet.length) * 100).toString() +
                  "%"),
              alignment: Alignment.topLeft,
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
              alignment: Alignment.topLeft,
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
              child: Text(
                  //TODO stampare *tutte* le violazioni commesse il maggior numero di volte u.mostCommittedCrime().keys.iterator.current
                  "Violation type: " +
                      sortedMap.keys.first
                          .toString()
                          .replaceAll("_", " ")
                          .replaceAll("Violation.", "")),
              alignment: Alignment.topLeft,
            ),
            Align(
              child:
                  Text("Committed times: " + sortedMap.values.first.toString()),
              alignment: Alignment.topLeft,
            ),
          ]),
        ),
        onWillPop: null);
  }
}
