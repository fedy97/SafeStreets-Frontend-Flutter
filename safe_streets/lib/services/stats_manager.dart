import 'package:queries/collections.dart';
import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/user.dart';

/// It manages the building of the statistics
class StatsManager {

  ///It retrieves the number of fined reports
  static int totalFinedReport(User u) {
    int fined = 0;
    for (ReportToGet reportToGet in u.reportsGet) {
      if (reportToGet.fined) fined++;
    }
    return fined;
  }

  ///It retrieves the number of daily reports
  static int totalDailyReport(User u) {
    int daily = 0;
    DateTime now = DateTime.now();
    for (ReportToGet reportToGet in u.reportsGet) {
      if (int.tryParse(
              now.difference(reportToGet.time).toString().split(":")[0]) <
          24) daily++;
    }
    return daily;
  }

  ///It returns a map that contains all the violations and the number of times that they occurred,
  ///sorted by the most committed one descending.
  static Map<Violation, int> mostCommittedCrime(User u) {
    Map<Violation, int> crimes = new Map();
    for (Violation violation in Violation.values) crimes[violation] = 0;
    for (ReportToGet reportToGet in u.reportsGet) {
      crimes[reportToGet.violation] = crimes[reportToGet.violation] + 1;
    }
    var query = Dictionary.fromMap(crimes)
        .orderByDescending((e) => e.value)
        .toDictionary$1((kv) => kv.key, (kv) => kv.value);
    return query.toMap();
  }
}
