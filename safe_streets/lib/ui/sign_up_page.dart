import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/auth_manager.dart';
import 'package:safe_streets/services/firebase_auth_service.dart';

class SignUpPage extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  static String _email = "";
  static String _password = "";
  static String _confirmPassword = "";
  static String idAuthority = "";
  Widget build(BuildContext context) {
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
            Consumer<ValueNotifier<bool>>(builder: (context, value2, child) {
              return CheckboxListTile(
                  title: Text("accept terms"),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: value2.value,
                  onChanged: (value) {
                    value2.value = value;
                  });
            }),
            RaisedButton(
              child: Text("Sign Up"),
              onPressed: () async {
                if (_email != "" &&
                    _email.contains("@") &&
                    _password != "" &&
                    _password == _confirmPassword &&
                    Provider.of<ValueNotifier<bool>>(context,listen: false).value) {
                  final auth = Provider.of<FirebaseAuthService>(context);
                  Map<String, dynamic> map =
                      createUserMap(email: _email, idAuthority: idAuthority);
                  await Firestore.instance
                      .collection("users")
                      .document(_email)
                      .setData(map);
                  FirebaseUser u = await auth.createUserWithEmailAndPassword(
                      _email, _password);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthManager()));
                } else if (!Provider.of<ValueNotifier<bool>>(context,listen: false).value) {
                  final snackBar =
                      SnackBar(content: Text("you must accept the terms"));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
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
      'reportSent': []
    };
  }
}
