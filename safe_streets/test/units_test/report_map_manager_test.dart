import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/report_map_manager.dart';

void main() {
  //setup
  User u = new Citizen("test@test.com", "test");
  DateTime data = DateTime.now();
  ReportToGet report0 = new ReportToGet();
  ReportToGet report1 = new ReportToGet();

  test("no violation uploaded", () {
    //setup
    //run
    final markers = ReportMapManager.toMarker(u, null);
    //verify
    expect(markers.isEmpty, true);
  });

  test("Two violation not fined within last day", () {
    //setup
    report0.time = data;
    report0.violation = Violation.double_parking;
    report0.reportPosition = new Location(0.0, 0.0);
    report0.fined = false;
    u.reportsGet.add(report0);
    report1.time = data;
    report1.violation = Violation.double_parking;
    report1.reportPosition = new Location(1.1, 1.1);
    report1.fined = false;
    u.reportsGet.add(report1);
    //run
    final Map<MarkerId, Marker> markers = ReportMapManager.toMarker(u, null);
    final amount = markers.length;
    //verify
    expect(amount, 2);
    expect(markers.values.first.position, new LatLng(0.0, 0.0));
    expect(markers.values.last.position, new LatLng(1.1, 1.1));
  });

  test("Two report not fined not within last day", () {
    //setup
    u.reportsGet.clear();
    report0.time = DateTime.parse("2012-02-25 12:20:10");
    report0.violation = Violation.double_parking;
    report0.reportPosition = new Location(0.0, 0.0);
    report0.fined = false;
    u.reportsGet.add(report0);
    report1.time = DateTime.parse("2010-01-01 11:11:11");
    report1.violation = Violation.double_parking;
    report1.reportPosition = new Location(1.1, 1.1);
    report1.fined = false;
    u.reportsGet.add(report1);
    //run
    final Map<MarkerId, Marker> markers = ReportMapManager.toMarker(u, null);
    final amount = markers.length;
    //verify
    expect(amount, 0);
  });

  test("Report uploaded yesterday", () {
    u.reportsGet.clear();
    report0.time = DateTime(data.year, data.month, data.day - 1);
    report0.violation = Violation.double_parking;
    report0.reportPosition = new Location(0.0, 0.0);
    report0.fined = false;
    u.reportsGet.add(report0);
    //run
    final Map<MarkerId, Marker> markers = ReportMapManager.toMarker(u, null);
    final amount = markers.length;
    //verify
    expect(amount, 0);
  });

  test("Two reports,one within last day", () {
    //setup
    u.reportsGet.clear();
    report0.time = DateTime(data.year, data.month, data.day - 1);
    report0.violation = Violation.double_parking;
    report0.reportPosition = new Location(0.0, 0.0);
    report0.fined = false;
    u.reportsGet.add(report0);
    report1.time = data;
    report1.violation = Violation.double_parking;
    report1.reportPosition = new Location(1.1, 1.1);
    report1.fined = true;
    u.reportsGet.add(report1);
    //run
    final Map<MarkerId, Marker> markers = ReportMapManager.toMarker(u, null);
    final amount = markers.length;
    //verify
    expect(amount, 1);
    expect(markers.values.first.position, LatLng(1.1, 1.1));
  });

  test("Two report on same position", () {
    u.reportsGet.clear();
    report0.time = data;
    report0.violation = Violation.double_parking;
    report0.reportPosition = new Location(0.0, 0.0);
    report0.fined = false;
    u.reportsGet.add(report0);
    report1.time = data;
    report1.violation = Violation.double_parking;
    report1.reportPosition = new Location(0.0, 0.0);
    report1.fined = true;
    u.reportsGet.add(report1);
    //run
    final Map<MarkerId, Marker> markers = ReportMapManager.toMarker(u, null);
    final amount = markers.length;
    //verify
    expect(amount, 2);
    expect(markers.values.first.position, LatLng(0.0, 0.0));
    expect(markers.values.last.position, LatLng(0.0, 0.0));
  });
}
