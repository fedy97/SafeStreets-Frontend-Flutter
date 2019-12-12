import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/authority.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/firebase_auth_service.dart';
import 'package:safe_streets/services/utilities.dart';
import 'package:safe_streets/ui/sign_up_page.dart';

import 'home_page.dart';

class SignInPage extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  static String _email = "";
  static String _password = "";
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context);
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
                try {
                  FirebaseUser user =
                      await auth.signInWithEmailAndPassword(_email, _password);
                  DocumentSnapshot map = await fetchMap(user);
                  User u = createUser(map, user);
                  Utilities.showProgress(context);
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
                } catch(error) {
                  final snackBar =
                      SnackBar(content: Text(Utilities.printError(error.toString())));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
            ),
            RaisedButton(
              child: Text("Sign Up"),
              onPressed: () {
                ValueNotifier<bool> checked = ValueNotifier(false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangeNotifierProvider<ValueNotifier<bool>>.value(value: checked,child: SignUpPage(),)));
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
