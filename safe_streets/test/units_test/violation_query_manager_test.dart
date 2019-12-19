import 'package:flutter_test/flutter_test.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/stats_manager.dart';
import 'package:safe_streets/services/violation_query_manager.dart';
import 'package:safe_streets/ui/violation_query.dart';

void main() {
  //setup
  User u = new Citizen("test@test.com", "test");
  DateTime data = DateTime.now();
  ReportToGet report0 = new ReportToGet();
  ReportToGet report1 = new ReportToGet();
  ReportToGet report2 = new ReportToGet();
  ReportToGet report3 = new ReportToGet();

  test('One report respects the bounds of the query', () {
    //setup
    u.reportsGet.clear();
    report0.reportPosition = new Location(45.4773, 9.1815);
    report0.reportPosition.address = "Milano";
    report0.time = DateTime.parse("2010-07-20 20:18:04Z");
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = data;
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(max, 1);
  });

  test('Zero report respect the bounds of the query (violation bound)', () {
    //setup
    u.reportsGet.clear();
    report0.reportPosition = new Location(45.4773, 9.1815);
    report0.reportPosition.address = "Milano";
    report0.time = DateTime.parse("2010-07-20 20:18:04Z");
    report0.violation = Violation.parking_on_pavement;
    u.reportsGet.add(report0);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = data;
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo);
    final max = results.length;
    //verify
    expect(max, 0);
  });

  test('Zero report respect the bounds of the query (data time bound)', () {
    //setup
    u.reportsGet.clear();
    report0.reportPosition = new Location(45.4773, 9.1815);
    report0.reportPosition.address = "Milano";
    report0.time = DateTime.parse("1999-07-20 20:18:04Z");
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = data;
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo);
    final max = results.length;
    //verify
    expect(max, 0);
  });

  test('Zero report respect the bounds of the query (city bound)', () {
    //setup
    u.reportsGet.clear();
    report0.reportPosition = new Location(45.0781, 7.6761);
    report0.reportPosition.address = "Torino";
    report0.time = DateTime.parse("2010-07-20 20:18:04Z");
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = data;
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo);
    final max = results.length;
    //verify
    expect(max, 0);
  });

  test('Zero report respect the bounds of the query (city bound)', () {
    //setup
    u.reportsGet.clear();
    report0.reportPosition = new Location(45.0781, 7.6761);
    report0.reportPosition.address = "Milano";
    report0.time = DateTime.parse("2002-07-20 20:18:04Z");
    report0.violation = Violation.double_parking;
  u.reportsGet.add(report0);

    report1.reportPosition = new Location(45.0781, 7.6761);
    report1.reportPosition.address = "Milano";
    report1.time = DateTime.parse("2003-07-20 20:18:04Z");
    report1.violation = Violation.double_parking;
u.reportsGet.add(report1);

    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = data;
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo);
    final max = results.length;
    //verify
    expect(max, 2);
  });

}
