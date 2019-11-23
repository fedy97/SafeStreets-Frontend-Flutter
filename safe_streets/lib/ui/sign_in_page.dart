import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/authority.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/firebase_auth_service.dart';
import 'package:safe_streets/ui/sign_up_page.dart';

import 'home_page.dart';

class SignInPage extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context);
    String _email = "";
    String _password = "";
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Sign in')),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(hintText: "enter email"),
                onChanged: (currEmail) => _email = currEmail),
            TextField(
                decoration: InputDecoration(hintText: "enter password"),
                obscureText: true,
                onChanged: (currPassword) => _password = currPassword),
            RaisedButton(
              child: Text('Sign in'),
              onPressed: () async {
                if (_email != "" && _email.contains("@") && _password != "") {
                  FirebaseUser user =
                      await auth.signInWithEmailAndPassword(_email, _password);
                  DocumentSnapshot map = await fetchMap(user);
                  User u = createUser(map, user);
                  u.showProgress(context);
                  await u.getAllReports();
                  await u.getPosition();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<User>.value(
                                value: u,
                                child: HomePage(),
                              )));
                } else {
                  final snackBar =
                      SnackBar(content: Text("invalid email or password"));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
            ),
            RaisedButton(
              child: Text("Sign Up"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
            )
          ],
        ),
      ),
    );
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
