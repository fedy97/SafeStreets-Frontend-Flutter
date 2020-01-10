import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/stats_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///statistics authority page

class AuthorityStatistics extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  static Map mapp;

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
            SizedBox(height: 14),
            Align(
              child: Text("Ranking of the most fined cars"),
              alignment: Alignment.center,
            ),
            SizedBox(height: 10),
            Expanded(
                child: FutureBuilder(
              future: buildMap(),
              builder: (context, child) {
                if (child.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: mapp.length,
                    itemBuilder: (context, int) {
                      return ListTile(
                          leading: Icon(Icons.directions_car),
                          title: Text(mapp.keys.elementAt(int).toString() +
                              ": " +
                              mapp.values.elementAt(int).toString()));
                    });
              },
            )),
          ]),
        ),
        onWillPop: null);
  }

  Future<Map<String, String>> buildMap() async {
    var map = new Map();
    var val = await Firestore.instance.collection("fines").getDocuments();
    var list = val.documents;
    for (var elem in list) {
      map[elem.documentID] = elem.data['count'];
    }
    mapp = map;
    return map;
  }
}
