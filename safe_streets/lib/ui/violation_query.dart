import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/user/user.dart';

class ViolationQuery extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  static String violation = Violation.values.first.toString();
  static String city = "";
  static bool cityUsed = false;
  static bool violationUsed = false;
  static bool fromDateUsed = false;
  static bool toDateUsed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    User u = Provider.of<User>(context, listen: true);
    final violations = Violation.values;
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () =>
                      {} //ViolationQueryManager.queryResults(u, city),
                  //todo cambia scena e mostra i report trovati
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
                    icon: Icon(Icons.drive_eta),
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
                  Expanded(
                      child: Checkbox(
                          value: violationUsed,
                          onChanged: (val) {
                            violationUsed = val;
                            u.updateUI();
                          }))
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: DateTimeField(decoration: InputDecoration(hintText: "From date"),
                    format: DateFormat("dd-MM-yyyy"),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                  )),
                  Expanded(
                      child: Checkbox(
                          value: fromDateUsed,
                          onChanged: (val) {
                            fromDateUsed = val;
                            u.updateUI();
                          }))
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: DateTimeField(decoration: InputDecoration(hintText: "To date"),
                        format: DateFormat("dd-MM-yyyy"),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      )),
                  Expanded(
                      child: Checkbox(
                          value: toDateUsed,
                          onChanged: (val) {
                            toDateUsed = val;
                            u.updateUI();
                          }))
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
              //ListView.builder(itemCount: ,itemBuilder: (context, int) {})
            ]),
          ),
        ),
        onWillPop: null);
  }
}
