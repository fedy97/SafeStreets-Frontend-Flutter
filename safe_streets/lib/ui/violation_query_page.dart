import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/utilities.dart';
import 'package:safe_streets/services/violation_query_manager.dart';

class ViolationQuery extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  static String violation = Violation.values.first.toString();
  static DateTime fromDate;
  static DateTime toDate;
  static String city = "";
  static bool cityUsed = false;
  static bool violationUsed = false;
  static bool fromDateUsed = false;
  static bool toDateUsed = false;
  static List<ReportToGet> results = List();
  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context, listen: true);
    final violations = Violation.values;
    return WillPopScope(
        child: Scaffold(resizeToAvoidBottomPadding: false,
          key: _scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    if ((fromDateUsed && fromDate == null) || (toDateUsed && toDate == null) || (cityUsed && city=="")) {
                      final snackBar = SnackBar(
                          content: Text("you have checked something without inputting the value"));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                      return;
                    }
                    Utilities.showProgress(context);
                    await u.getAllReports();
                    List<bool> checks = List();
                    checks.add(cityUsed);
                    checks.add(violationUsed);
                    checks.add(fromDateUsed);
                    checks.add(toDateUsed);
                    Violation violation2 = Violation.values.firstWhere((test) => test.toString() == violation);
                    results = ViolationQueryManager.queryResults(u, city, violation2, fromDate, toDate, checks);
                    u.updateUI();
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        content: Text(results.length.toString() + " reports found"));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
              )
            ],
            title: Text("Violation query"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              SizedBox(height: 14.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      onChanged: (selectedCity) => city = selectedCity,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'City',
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Checkbox(
                      value: cityUsed,
                      onChanged: (val) {
                        cityUsed = val;
                        u.updateUI();
                      }),
                ],
              ),
              SizedBox(height: 14.0),
              Row(
                children: <Widget>[
                  DropdownButton<String>(
                    value: violation,
                    items: (violations).map((Violation value) {
                      return new DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value
                            .toString()
                            .replaceAll("_", " ")
                            .replaceAll("Violation.", "")
                            .toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (newViolation) {
                      violation = newViolation;
                      u.updateUI();
                    },
                  ),
                  Expanded(child: Checkbox(
                      value: violationUsed,
                      onChanged: (val) {
                        violationUsed = val;
                        u.updateUI();
                      })),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: DateTimeField(onChanged: (date) {
                        fromDate = date;
                      }, decoration: InputDecoration(helperText: "inclusive",hintText: "From date"),
                        format: DateFormat("dd-MM-yyyy"),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      )),
                         Checkbox(
                          value: fromDateUsed,
                          onChanged: (val) {
                            fromDateUsed = val;
                            u.updateUI();
                          })
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: DateTimeField(onChanged: (date) {
                        toDate = date;
                      }, decoration: InputDecoration(hintText: "To date",helperText: "exclusive"),
                        format: DateFormat("dd-MM-yyyy"),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      )),
                  Checkbox(
                          value: toDateUsed,
                          onChanged: (val) {
                            toDateUsed = val;
                            u.updateUI();
                          })
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
              Expanded(child: ListView.builder(shrinkWrap: true,itemCount: results.length,itemBuilder: (context, int) {
                return ListTile(
                    onTap: () async {
                      u.setCurrViewedReport = results[int];
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider<User>.value(
                            value: u,
                            child: u.viewReportPage(),
                          )));
                    },
                    leading: Icon(Icons.report_problem),
                    title: Text("Report ${int + 1}, " +
                        results[int].time.toIso8601String().split(".")[0]
                            .replaceAll("T", " at ")));
              })),
            ]),
          ),
        ),
        onWillPop: () {
          results.clear();
          city = "";
          toDate= null;
          fromDate=null;
          violation=Violation.values.first.toString();
          cityUsed = false;
          violationUsed = false;
          fromDateUsed = false;
          toDateUsed = false;
          Navigator.pop(context);
          return Future(() => false);
        });
  }
}
