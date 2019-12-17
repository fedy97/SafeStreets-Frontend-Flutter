import 'package:flutter_test/flutter_test.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/stats_manager.dart';


void main() {
  //setup
  User u = new Citizen("test@test.com", "test");
  DateTime data = new DateTime(2019);
  ReportToGet report0 = new ReportToGet();
  ReportToGet report1 = new ReportToGet();
  ReportToGet report2 = new ReportToGet();
  ReportToGet report3 = new ReportToGet();

  test('zero violation uploaded, no most commited violation', () {
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

  test('two violations uploaded of the same type and of another type, the two ones are the most committed', () {
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

}
