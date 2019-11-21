import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';

class ViewReportCitizen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User u = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Page"),
      ),
      body: Container(),
    );
  }
}
