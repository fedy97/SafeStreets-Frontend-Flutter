// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/ui/view_report_citizen_page.dart';

class Citizen extends User {
  Citizen(String email, String uid) : super(email, uid, Level.standard);

  @override
  Widget viewReportPage() {
    return ViewReportCitizen();
  }
}
