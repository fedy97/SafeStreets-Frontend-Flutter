import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/access_manager.dart';
import 'package:safe_streets/services/new_report_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_streets/ui/create_report_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //setup
  User u = new Citizen("test@test.com", "test");
  DateTime data = DateTime.now();
  ReportToGet report0 = new ReportToGet();
  ReportToSend reportToSend = new ReportToSend();

  group("Similar report", () {
    test("Similar report don't exist", () async {
      //setup
      reportToSend.time = data;
      reportToSend.violation = Violation.double_parking;
      reportToSend.reportPosition = Location(0.0, 0.0);
      u.currReport = reportToSend;
      //run
      bool found = await NewReportManager.alreadyExist(null, u);
      //verify
      expect(found, false);
    });

    /*test("Similar report exist", () async {
      //setup
      reportToSend.time = data;
      reportToSend.violation = Violation.double_parking;
      reportToSend.reportPosition = Location(0.0, 0.0);
      u.currReport = reportToSend;
      report0.time = DateTime(data.year, data.month, data.day, data.hour - 1);
      report0.reportPosition = Location(0.0, 0.0);
      report0.violation = Violation.double_parking;
      u.reportsGet.add(report0);
      //run
      var found = await NewReportManager.alreadyExist(null, u);
      //verify
      expect(found, true);
    });*/

    /*test("Report with same violation and day", () async {
      //setup
      reportToSend.time = data;
      reportToSend.violation = Violation.double_parking;
      reportToSend.reportPosition = Location(0.0, 0.0);
      u.currReport = reportToSend;
      report0.time = DateTime(data.year, data.month, data.day, data.hour - 1);
      report0.reportPosition = Location(4.4, 1.1);
      report0.violation = Violation.double_parking;
      u.reportsGet.add(report0);
      //run
      var found = await NewReportManager.alreadyExist(null, u);
      //verify
      expect(found, false);
    });*/

    test("Report with same location and day", () async {
      //setup
      reportToSend.time = data;
      reportToSend.violation = Violation.double_parking;
      reportToSend.reportPosition = Location(0.0, 0.0);
      u.currReport = reportToSend;
      report0.time = DateTime(data.year, data.month, data.day, data.hour - 1);
      report0.reportPosition = Location(0.0, 0.0);
      report0.violation = Violation.parking_on_pavement;
      u.reportsGet.add(report0);
      //run
      var found = await NewReportManager.alreadyExist(null, u);
      //verify
      expect(found, false);
    });

    test("Report with same location and violation", () async {
      //setup
      reportToSend.time = data;
      reportToSend.violation = Violation.double_parking;
      reportToSend.reportPosition = Location(0.0, 0.0);
      u.currReport = reportToSend;
      report0.time = DateTime(data.year, data.month, data.day - 1);
      report0.reportPosition = Location(0.0, 0.0);
      report0.violation = Violation.double_parking;
      u.reportsGet.add(report0);
      //run
      var found = await NewReportManager.alreadyExist(null, u);
      //verify
      expect(found, false);
    });
  });

}
