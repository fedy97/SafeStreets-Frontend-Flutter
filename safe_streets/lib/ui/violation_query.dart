import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/violation_query_manager.dart';

class ViolationQuery extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    User u = Provider.of<User>(context, listen: true);
    final violations = Violation.values;
    String city;
    Violation violation;
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Violation query"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              SizedBox(height: 14.0),
              TextFormField(
                onChanged: (selectedCity) => city = selectedCity,//TODO chiamare metodo per trovare report con la città selezionata
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Write the city',
                ),
                maxLines: 1,
              ),
              SizedBox(height: 14.0),
              DropdownButton<String>(
                icon: Icon(Icons.drive_eta),
                value: Violation.double_parking.toString(),
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
                onChanged: (newViolation) => violation = Violation.other_violation,//TODO dalla stringa ritrovare la violazione selezionata
              ),
              SizedBox(height: 14.0,),

              IconButton(
                icon: Icon(Icons.search),
                color: Colors.blueAccent,
                onPressed:()=> ViolationQueryManager.findReportCity(u, city),
                //todo cambia scena e mostra i report trovati
              )
            ]),
          ),
        ),
        onWillPop: null);
  }
}
