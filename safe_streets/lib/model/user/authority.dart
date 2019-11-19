import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/user/user.dart';

class Authority extends User {
  String idAuthority;

  Authority(String email, String uid, String idAuthority) :
    this.idAuthority = idAuthority,
    super(email, uid, Level.complete);

}