import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/user.dart';

class ViolationQueryManager {
  static List<ReportToGet> queryResults(User u, String city,
      Violation violation, DateTime timeFrom, DateTime timeTo) {
    List<ReportToGet> results;
    for (ReportToGet reportToGet in u.reportsGet) {
      if (reportToGet.reportPosition.address
              .toLowerCase()
              .contains(city.toLowerCase()) &&
          reportToGet.violation == violation &&
          reportToGet.time.isBefore(timeTo) &&
          reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
    }

    return results;
  }
}
