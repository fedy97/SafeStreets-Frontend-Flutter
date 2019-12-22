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
        //Tutti i filtri attivi
        if (reportToGet.reportPosition.address
                .toLowerCase()
                .contains(city.toLowerCase()) &&
            reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) {
          results.add(reportToGet);
        }
      }
      if (active[0] && active[1] && active[2] && !active[3]) {
        //non attivo timeTo
        if (reportToGet.reportPosition.address
                .toLowerCase()
                .contains(city.toLowerCase()) &&
            reportToGet.violation == violation &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (active[0] && active[1] && !active[2] && active[3]) {
        //non attivo timeFrom
        if (reportToGet.reportPosition.address
                .toLowerCase()
                .contains(city.toLowerCase()) &&
            reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }

      if (active[0] && active[1] && !active[2] && !active[3]) {
        //non attivo data
        if (reportToGet.reportPosition.address
                .toLowerCase()
                .contains(city.toLowerCase()) &&
            reportToGet.violation == violation) results.add(reportToGet);
      }
      if (active[0] && !active[1] && active[2] && active[3]) {
        //filtro sulla violazione non attivo
        if (reportToGet.reportPosition.address
                .toLowerCase()
                .contains(city.toLowerCase()) &&
            reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) {
          results.add(reportToGet);
        }
      }
      if (active[0] && !active[1] && active[2] && !active[3]) {
        // filtro sulle violazioni e sul timeTo non attivi
        if (reportToGet.reportPosition.address.toLowerCase() ==
                city.toLowerCase() &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }
      if (active[0] && !active[1] && !active[2] && active[3]) {
        // filtro sulle violazioni e sulla timeFrom non attivi
        if (reportToGet.reportPosition.address.toLowerCase() ==
                city.toLowerCase() &&
            reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }
      if (active[0] && !active[1] && !active[2] && !active[3]) {
        // filtro sulla violazione, su time From, su timeTo non attivi
        if (reportToGet.reportPosition.address.toLowerCase() ==
            city.toLowerCase()) results.add(reportToGet);
      }
      if (!active[0] && active[1] && active[2] && active[3]) {
        //filtro sulla posizione non attivo
        if (reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }
      if (!active[0] && active[1] && active[2] && !active[3]) {
        //Filtri sulla posizione e su timeTo non attivi
        if (reportToGet.violation == violation &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (!active[0] && active[1] && !active[2] && active[3]) {
        //Filtri sulla posizione e su timeFrom non attivi
        if (reportToGet.violation == violation &&
            reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }

      if (!active[0] && active[1] && !active[2] && !active[3]) {
        //filtro sulla posizione sulle date non attivi
        if (reportToGet.violation == violation) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && active[2] && active[3]) {
        //filtri su pozione e violazione non attivi
        if (reportToGet.time.isBefore(timeTo) &&
            reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && active[2] && !active[3]) {
        //Filtri su posione, violazione, timeTo non attivi
        if (reportToGet.time.isAfter(timeFrom)) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && !active[2] && active[3]) {
        //Tfiltri sulla posizione, violazion, timeFrom non attivi
        if (reportToGet.time.isBefore(timeTo)) results.add(reportToGet);
      }

      if (!active[0] && !active[1] && !active[2] && !active[3]) {
        results = u.reportsGet;
      }
    }
    return results;
  }
}
