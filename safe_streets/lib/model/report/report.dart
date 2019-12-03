import 'package:flutter/material.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/violation_image.dart';

abstract class Report {
  DateTime time;
  String note = "";
  int feedback = 0;
  List<String> feedbackSenders;
  Location reportPosition = new Location(0.0, 0.0);
  Violation violation;
  List<ViolationImage> images = new List();
  String emailUser;
  Map<String, dynamic> imagesLite = new Map();

  Report({@required this.time, @required this.emailUser, this.violation, this.note, this.feedback, this.reportPosition, this.images, this.imagesLite, this.feedbackSenders});
}