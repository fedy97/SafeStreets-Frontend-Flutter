import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/auth_manager.dart';
import 'package:safe_streets/services/access_manager.dart';
import 'package:safe_streets/services/utilities.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                icon: Icon(Icons.email),
                hintText: 'Your email address',
                labelText: 'E-mail*',
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String value) {
                _email = value;
              },
            ),
            SizedBox(height: 14.0),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                icon: Icon(Icons.vpn_key),
                labelText: 'Password*',
                helperText: "at least 6 characters",
              ),
              onChanged: (String value) {
                _password = value;
              },
            ),
            SizedBox(height: 14.0),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                icon: Icon(Icons.vpn_key),
                labelText: 'Confirm Password*',
              ),
              onChanged: (String value) {
                _confirmPassword = value;
              },
            ),
            SizedBox(height: 14.0),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                icon: Icon(Icons.fiber_pin),
                labelText: 'ID authority',
              ),
              onChanged: (String value) {
                idAuthority = value;
              },
            ),
            SizedBox(height: 14.0),
            Consumer<ValueNotifier<bool>>(builder: (context, value2, child) {
              return CheckboxListTile(
                  title: Text("accept terms"),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: value2.value,
                  onChanged: (value) {
                    value2.value = value;
                  });
            }),
            OutlineButton(
              splashColor: Colors.blue,
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              child: Text("Sign Up"),
              onPressed: () async {
                if (_email != "" &&
                    _email.contains("@") &&
                    _password != "" &&
                    _password == _confirmPassword &&
                    Provider.of<ValueNotifier<bool>>(context, listen: false)
                        .value) {
                  Utilities.showProgress(context);
                  if (idAuthority != "") if (await AccessManager
                      .checkIdAlreadyPresent(
                          _scaffoldKey, idAuthority, context)) {
                    Navigator.pop(context);
                    return;
                  }
                  try {
                    final auth = Provider.of<AccessManager>(context);
                    Map<String, dynamic> map = AccessManager.createUserMap(
                        email: _email, idAuthority: idAuthority);
                    FirebaseUser u = await auth.createUserWithEmailAndPassword(
                        _email, _password);
                    await Firestore.instance
                        .collection("users")
                        .document(_email)
                        .setData(map);
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AuthManager()));
                  } catch (e, stack) {
                    final snackBar = SnackBar(
                        content: Text(Utilities.printError(e.toString())));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                    Navigator.pop(context);
                  }
                } else if (!Provider.of<ValueNotifier<bool>>(context,
                        listen: false)
                    .value) {
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
}
