import 'package:flutter_test/flutter_test.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/stats_manager.dart';


void main() {
  //setup
  User u = new Citizen("test@test.com", "test");
  DateTime data = DateTime.now();
  ReportToGet report0 = new ReportToGet();
  ReportToGet report1 = new ReportToGet();
  ReportToGet report2 = new ReportToGet();
  ReportToGet report3 = new ReportToGet();

  test('zero violation uploaded, no most committed violation', () {
    //setup
    //run
    final result = StatsManager.mostCommittedCrime(u).keys.first;
    final max = StatsManager.mostCommittedCrime(u).values.first;
    //verify
    expect(max, 0);
  });

  test('one violation uploaded is the most committed ', () {
    //setup
    report0.time = data;
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    //run
    final result = StatsManager.mostCommittedCrime(u).keys.first;
    final max = StatsManager.mostCommittedCrime(u).values.first;
    //verify
    expect(result, Violation.double_parking);
    expect(max, 1);
  });


  test('three violations uploaded of the same type are the most committed', () {
    //setup
    u.reportsGet.clear();
    report1.time = data;
    report1.violation = Violation.double_parking;
    u.reportsGet.add(report1);
    report2.time = data;
    report2.violation = Violation.double_parking;
    u.reportsGet.add(report2);
    report3.time = data;
    report3.violation = Violation.double_parking;
    u.reportsGet.add(report3);
    //run
    final result = StatsManager.mostCommittedCrime(u).keys.first;
    final max = StatsManager.mostCommittedCrime(u).values.first;
    //verify
    expect(result, Violation.double_parking);
    expect(max,3);
  });

  test('two violations uploaded of the same type and one of another type, the two ones are the most committed', () {
    //setup
    u.reportsGet.clear();
    report1.time = data;
    report1.violation = Violation.double_parking;
    u.reportsGet.add(report1);
    report2.time = data;
    report2.violation = Violation.other_violation;
    u.reportsGet.add(report2);
    report3.time = data;
    report3.violation = Violation.double_parking;
    u.reportsGet.add(report3);
    //run
    final result = StatsManager.mostCommittedCrime(u).keys.first;
    final max = StatsManager.mostCommittedCrime(u).values.first;
    //verify
    expect(result, Violation.double_parking);
    expect(max,2);
  });
  
  test('zero violation uploaded today ', () {
    //setup
    u.reportsGet.clear();
    report0.time = new DateTime(2019);
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    //run
    final result = StatsManager.totalDailyReport(u);
    //verify
    expect(result, 0);
  });

  test('one violation uploaded today ', () {
    //setup
    u.reportsGet.clear();
    report0.time = data;
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    //run
    final result = StatsManager.totalDailyReport(u);
    //verify
    expect(result, 1);
  });

  test('one violation uploaded today and one yesterday', () {
    //setup
    u.reportsGet.clear();
    report0.time = data;
    report0.violation = Violation.double_parking;
    u.reportsGet.add(report0);
    report1.time = new DateTime(2019);//it's set to 2019-01-01 00:00:00.000
    u.reportsGet.add(report1);
    //run
    final result = StatsManager.totalDailyReport(u);
    //verify
    expect(result, 1);
  });

  test('one report uploaded and not fined', () {
    //setup
    u.reportsGet.clear();
    report0.time = data;
    report0.violation = Violation.double_parking;
    report0.fined = false;
    u.reportsGet.add(report0);
    //run
    final result = StatsManager.totalFinedReport(u);
    //verify
    expect(result, 0);
  });

  test('one report uploaded and fined', () {
    //setup
    u.reportsGet.clear();
    report0.time = data;
    report0.violation = Violation.double_parking;
    report0.fined = true;
    u.reportsGet.add(report0);
    //run
    final result = StatsManager.totalFinedReport(u);
    //verify
    expect(result, 1);
  });

  test('Two reports uploaded: one fined and one not', () {
    //setup
    u.reportsGet.clear();
    report0.time = data;
    report0.violation = Violation.double_parking;
    report0.fined = true;
    u.reportsGet.add(report0);
    report1.fined = false;
    u.reportsGet.add(report1);
    //run
    final result = StatsManager.totalFinedReport(u);
    //verify
    expect(result, 1);
  });


}
