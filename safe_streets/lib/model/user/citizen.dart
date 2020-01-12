import 'package:flutter/material.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/ui/statistics_citizen_page.dart';
import 'package:safe_streets/ui/view_report_citizen_page.dart';

///Citizen is one type of user
class Citizen extends User {
  Citizen(String email, String uid) : super(email, uid, Level.standard);

  @override
  Widget viewReportPage() {
    return ViewReportCitizen();
  }

  @override
  Widget viewStatisticsPage() {
    return CitizenStatistics();
  }
}
