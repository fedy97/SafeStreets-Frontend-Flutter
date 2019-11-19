import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/auth_manager.dart';
import 'package:safe_streets/services/firebase_auth_service.dart';

class SignUpPage extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    String _email = "";
    String _password = "";
    String _confirmPassword = "";
    String idAuthority = "";
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Sign Up')),
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
            TextField(
              decoration: InputDecoration(hintText: "reinsert password"),
              obscureText: true,
              onChanged: (currPassword) => _confirmPassword = currPassword,
            ),
            TextField(
                decoration: InputDecoration(hintText: "enter id authority"),
                onChanged: (id) => idAuthority = id),
            RaisedButton(
              child: Text("Sign Up"),
              onPressed: () async {
                if (_email != "" &&
                    _email.contains("@") &&
                    _password != "" &&
                    _password == _confirmPassword) {
                  final auth = Provider.of<FirebaseAuthService>(context);
                  Map<String, dynamic> map =
                      createUserMap(email: _email, idAuthority: idAuthority);
                  await Firestore.instance
                      .collection("users")
                      .document(_email)
                      .setData(map);
                  FirebaseUser u = await auth.createUserWithEmailAndPassword(
                      _email, _password);
                  /*wait Firestore.instance
                      .collection("users")
                      .document(_email)
                      .updateData({'uid': u.uid});*/
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthManager()));
                } else {
                  final snackBar =
                      SnackBar(content: Text("invalid email or password"));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> createUserMap({@required email, idAuthority}) {
    return {
      'level': idAuthority == "" ? 'standard' : 'complete',
      'idAuthority': idAuthority != "" ? idAuthority : null,
      'ReportToSend': []
    };
  }
}
