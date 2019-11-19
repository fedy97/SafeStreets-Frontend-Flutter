import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/report/report_to_get.dart';
import 'package:safe_streets/ui/home_page.dart';
import 'package:safe_streets/ui/sign_in_page.dart';

import 'model/user/authority.dart';
import 'model/user/citizen.dart';
import 'model/user/user.dart';

class AuthManager extends StatefulWidget {
  @override
  _AuthManagerState createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  bool logged;
  User u;

  @override
  void initState() {
    super.initState();
    try {
      FirebaseAuth.instance.currentUser().then((user) {
        if (user == null) {
          setState(() {
            logged = false;
          });
        } else {
          fetchMap(user).then((map) {
            u = createUser(map, user);
            setState(() {
              logged = true;
              Firestore.instance
                  .collection("users")
                  .getDocuments()
                  .then((list) {
                var iter = list.documents.iterator;
                while (iter.moveNext()) {
                  List list = iter.current.data['reportSent'];
                  int i = 0;
                  while (i < list.length)
                    u.reportsGet.add(ReportToGet.fromMap(
                        Map<String, dynamic>.from(list[i++]), u.email));
                }
              });
            });
          });
        }
      });
    } catch (e, trace) {
      print(trace);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (logged == null)
      return CircularProgressIndicator();
    else if (logged)
      return ChangeNotifierProvider<User>.value(value: u, child: HomePage());
    else
      return SignInPage();
  }

  Future<DocumentSnapshot> fetchMap(FirebaseUser user) async {
    return await Firestore.instance
        .collection("users")
        .document(user.email)
        .snapshots()
        .first;
  }

  User createUser(DocumentSnapshot map, FirebaseUser user) {
    if (map.data['level'] == "standard") {
      return new Citizen(user.email, user.uid);
    } else {
      return new Authority(user.email, user.uid, map.data['idAuthority']);
    }
  }
}
