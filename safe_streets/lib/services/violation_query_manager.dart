import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/user.dart';

class ViolationQueryManager{
  static List<ReportToGet> findReportCity(User u, String city){
    List<ReportToGet> results;
    for (ReportToGet reportToGet in u.reportsGet) {
      if (reportToGet.reportPosition.address.toLowerCase().contains(city.toLowerCase())) results.add(reportToGet);
    }
  }
}