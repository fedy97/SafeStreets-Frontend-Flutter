import 'package:safe_streets/model/enum/level.dart';
import 'package:safe_streets/model/user/user.dart';

class Citizen extends User {
  Citizen(String email, String uid) : super(email, uid, Level.standard);
}
