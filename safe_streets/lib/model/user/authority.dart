// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/ui/statistics_authority_page.dart';
import 'package:safe_streets/ui/view_report_authority_page.dart';

class Authority extends User {
  String idAuthority;

  Authority(String email, String uid, String idAuthority) :
    this.idAuthority = idAuthority,
    super(email, uid, Level.complete);

  @override
  Widget viewReportPage() {
    return ViewReportAuthority();
  }

  @override
  Widget viewStatisticsPage() {
    return AuthorityStatistics();
  }

}