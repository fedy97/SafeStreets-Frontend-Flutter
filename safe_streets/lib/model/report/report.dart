import 'package:flutter/material.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/violation_image.dart';

abstract class Report {
  DateTime time;
  String note = "";
  int feedback = 0;
  Location reportPosition;
  Violation violation;
  List<ViolationImage> images = new List();
  String emailUser;

  Report({@required this.time, @required this.emailUser, this.violation});
}