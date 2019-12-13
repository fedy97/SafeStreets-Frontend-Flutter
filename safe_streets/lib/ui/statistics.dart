import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';

class Statistics extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    User u = Provider.of<User>(context, listen: true);
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Select Statistics"),
          ),
          body: Column(children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Center(child: Text(
              "Effectiveness",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
            ),),
            Align(child: Text(
              "Total reports number: " + u.reportsGet.length.toString(),),
              alignment: Alignment.topLeft,
              ),

            Align(child:Text(
                "Number of reports fined: " + u.totalFinedReport().toString(),),
            alignment: Alignment.topLeft,),
            Align(child:Text(
              "ratio: " + ((u.totalFinedReport() / u.reportsGet.length)*100).toString()+ "%"),
              alignment: Alignment.topLeft,),
            SizedBox(
              height: 10,
            ),
            Center(child: Text(
              "Daily Reports",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
            ),),
            Align(child:Text(
              "Number of reports: " + u.totalDailyReport().toString()),
              alignment: Alignment.topLeft,),
          ]),
        ),
        onWillPop: null);
  }
}
