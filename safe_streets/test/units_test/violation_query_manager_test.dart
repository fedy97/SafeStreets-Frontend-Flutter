import 'package:flutter_test/flutter_test.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/violation_query_manager.dart';

void main() {
  //setup
  User u = new Citizen("test@test.com", "test");
  DateTime data = DateTime.now();
  ReportToGet report0 = new ReportToGet();
  ReportToGet report1 = new ReportToGet();
  ReportToGet report2 = new ReportToGet();
  ReportToGet report3 = new ReportToGet();
  List<bool> bound = new List<bool>();

  test('One report respects the bounds of the query', () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    report0.reportPosition = new Location(45.4773, 9.1815);
    report0.reportPosition.address = "Milano";
    report0.time = DateTime.parse("2010-07-20 20:18:04Z");
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = data;
    bound.add(true);
    bound.add(true);
    bound.add(true);
    bound.add(true);
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(max, 1);
  });

  test('Two report respects the bounds of the query(no bounds on city)', () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    report0.reportPosition = new Location(45.4773, 9.1815);
    report0.reportPosition.address = "Milano";
    report0.time = DateTime.parse("2010-07-20 20:18:04Z");
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    report1.reportPosition = new Location(10.0, 11.0);
    report1.reportPosition.address = "Torino";
    report1.time = DateTime.parse("2005-07-20 20:18:04Z");
    report1.violation = Violation.double_parking;
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = data;
    bound.add(false);//city
    bound.add(true);//violation
    bound.add(true);//timeFrom
    bound.add(true);//timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1,results[1]);
    expect(max, 2);
  });

  //todo coprire tutti gli if di query results
}
