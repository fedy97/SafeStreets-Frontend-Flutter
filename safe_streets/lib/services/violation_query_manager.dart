import 'package:safe_streets/model/enum/violation.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/model/user/user.dart';

class ViolationQueryManager {
  /// active: pos 0 city; pos 1 violation; pos 2 timeFrom; pos 3 timeTo
  static List<ReportToGet> queryResults(
      User u,
      String city,
      Violation violation,
      DateTime timeFrom,
      DateTime timeTo,
      List<bool> active) {
    List<ReportToGet> results = new List<ReportToGet>();
    for (ReportToGet reportToGet in u.reportsGet) {
      if (active[0] && active[1] && active[2] && active[3]) {
        ///all active filters
        if (reportToGet.reportPosition.city
                .toLowerCase()
                == city.toLowerCase() &&
            reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) {
          results.add(reportToGet);
        }
      }
      if (active[0] && active[1] && active[2] && !active[3]) {
        ///no timeTo
        if (reportToGet.reportPosition.city
                .toLowerCase()
                ==city.toLowerCase() &&
            reportToGet.violation == violation &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (active[0] && active[1] && !active[2] && active[3]) {
        ///no timeFrom
        if (reportToGet.reportPosition.city
                .toLowerCase()
                == city.toLowerCase() &&
            reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }

      if (active[0] && active[1] && !active[2] && !active[3]) {
        ///no data
        if (reportToGet.reportPosition.city
                .toLowerCase()
                ==city.toLowerCase() &&
            reportToGet.violation == violation) results.add(reportToGet);
      }
      if (active[0] && !active[1] && active[2] && active[3]) {
        ///no violation
        if (reportToGet.reportPosition.city
                .toLowerCase()
            == city.toLowerCase() &&
            reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) {
          results.add(reportToGet);
        }
      }
      if (active[0] && !active[1] && active[2] && !active[3]) {
        ///no violation and timeFrom
        if (reportToGet.reportPosition.city.toLowerCase() ==
                city.toLowerCase() &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }
      if (active[0] && !active[1] && !active[2] && active[3]) {
        /// filtro sulle violazioni e sulla timeFrom non attivi
        if (reportToGet.reportPosition.city.toLowerCase() ==
                city.toLowerCase() &&
            reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }
      if (active[0] && !active[1] && !active[2] && !active[3]) {
        /// filtro sulla violazione, su time From, su timeTo non attivi
        if (reportToGet.reportPosition.city.toLowerCase() ==
            city.toLowerCase()) results.add(reportToGet);
      }
      if (!active[0] && active[1] && active[2] && active[3]) {
        /// filtro sulla posizione non attivo
        if (reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }
      if (!active[0] && active[1] && active[2] && !active[3]) {
        /// Filtri sulla posizione e su timeTo non attivi
        if (reportToGet.violation == violation &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (!active[0] && active[1] && !active[2] && active[3]) {
        /// Filtri sulla posizione e su timeFrom non attivi
        if (reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }

      if (!active[0] && active[1] && !active[2] && !active[3]) {
        /// filtro sulla posizione sulle date non attivi
        if (reportToGet.violation == violation) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && active[2] && active[3]) {
        /// filtri su pozione e violazione non attivi
        if (reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && active[2] && !active[3]) {
        /// Filtri su posione, violazione, timeTo non attivi
        if (reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && !active[2] && active[3]) {
        /// no filters
        if (reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && !active[2] && !active[3]) {
        results = u.reportsGet;
      }
    }
    return results;
  }
}
