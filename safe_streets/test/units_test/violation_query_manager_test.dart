import 'package:flutter_test/flutter_test.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/location.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/violation_query_manager.dart';

void main() {
  //setup
  User u = new Citizen("test@test.com", "test");
  DateTime date = DateTime.now();
  ReportToGet report0;
  ReportToGet report1 = new ReportToGet();
  ReportToGet report2 = new ReportToGet();
  ReportToGet report3 = new ReportToGet();
  List<bool> bound = new List<bool>();

  test('One report respects the bounds of the query', () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = date;
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

  test('Two report respects the bounds of the query(no bounds on city', () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Torino,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = date;
    bound.add(false); //city
    bound.add(true); //violation
    bound.add(true); //timeFrom
    bound.add(true); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test('Two report respects the bounds of the query(no bounds on violation)',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = date;
    bound.add(true); //city
    bound.add(false); //violation
    bound.add(true); //timeFrom
    bound.add(true); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });
  test('Two report respects the bounds of the query(no bounds on timeTo', () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = DateTime.parse("2001-07-20 20:18:04Z");
    bound.add(true); //city
    bound.add(true); //violation
    bound.add(true); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test('Two report respects the bounds of the query(no bounds on timeFrom', () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2020-07-20 20:18:04Z");
    DateTime timeTo = date;
    bound.add(true); //city
    bound.add(true); //violation
    bound.add(false); //timeFrom
    bound.add(true); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on timeFrom and timeTo',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2020-07-20 20:18:04Z");
    DateTime timeTo = DateTime.parse("2020-07-20 20:18:04Z");
    bound.add(true); //city
    bound.add(true); //violation
    bound.add(false); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on violation and timeTo',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = DateTime.parse("2001-07-20 20:18:04Z");
    bound.add(true); //city
    bound.add(false); //violation
    bound.add(true); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on violation and timeFrom',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2020-07-20 20:18:04Z");
    DateTime timeTo = date;
    bound.add(true); //city
    bound.add(false); //violation
    bound.add(false); //timeFrom
    bound.add(true); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  //todo
  test(
      'Two report respects the bounds of the query(no bounds on violation and timeFrom and timeTo',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Milano";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = date;
    bound.add(true); //city
    bound.add(false); //violation
    bound.add(false); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on city and timeTo',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Torino";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = DateTime.parse("2001-07-20 20:18:04Z");
    bound.add(false); //city
    bound.add(true); //violation
    bound.add(true); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on city and timeFrom',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Torino";
    DateTime timeFrom = date;
    DateTime timeTo = DateTime.parse("2019-07-20 20:18:04Z");
    bound.add(false); //city
    bound.add(true); //violation
    bound.add(false); //timeFrom
    bound.add(true); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on city and timeFrom and timeTo',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Torino";
    DateTime timeFrom = date;
    DateTime timeTo = DateTime.parse("2001-07-20 20:18:04Z");
    bound.add(false); //city
    bound.add(true); //violation
    bound.add(false); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.double_parking, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on city and violation)',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Torino";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = date;
    bound.add(false); //city
    bound.add(false); //violation
    bound.add(true); //timeFrom
    bound.add(true); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on city and violation and timeTo)',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Torino";
    DateTime timeFrom = DateTime.parse("2000-07-20 20:18:04Z");
    DateTime timeTo = DateTime.parse("2000-07-20 20:18:04Z");
    bound.add(false); //city
    bound.add(false); //violation
    bound.add(true); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });
  test(
      'Two report respects the bounds of the query(no bounds on city and violation and timeFrom)',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Torino";
    DateTime timeFrom = date;
    DateTime timeTo = date;
    bound.add(false); //city
    bound.add(false); //violation
    bound.add(false); //timeFrom
    bound.add(true); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });

  test(
      'Two report respects the bounds of the query(no bounds on city and violation and timeFrom and timeTo)',
      () {
    //setup
    u.reportsGet.clear();
    bound.clear();
    ReportToSend reportToSend = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend.reportPosition.address = "Milano,20131,Italy";
    report0 = ReportToGet.fromMap(reportToSend.toMap(), u.email);
    u.reportsGet.add(report0);
    ReportToSend reportToSend1 = ReportToSend(
        reportPosition: new Location(45.4773, 9.1815),
        time: DateTime.parse("2010-07-20 20:18:04Z"),
        violation: Violation.double_parking,
        images: new List<ViolationImage>(),
        emailUser: u.email);
    reportToSend1.reportPosition.address = "Milano,20131,Italy";
    report1 = ReportToGet.fromMap(reportToSend1.toMap(), u.email);
    u.reportsGet.add(report1);
    String city = "Torino";
    DateTime timeFrom = date;
    DateTime timeTo = date;
    bound.add(false); //city
    bound.add(false); //violation
    bound.add(false); //timeFrom
    bound.add(false); //timeTo
    //run
    List<ReportToGet> results = new List<ReportToGet>();
    results = ViolationQueryManager.queryResults(
        u, city, Violation.other_violation, timeFrom, timeTo, bound);
    final max = results.length;
    //verify
    expect(report0, results.first);
    expect(report1, results[1]);
    expect(max, 2);
  });
}
