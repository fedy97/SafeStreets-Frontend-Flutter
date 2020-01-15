import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/user.dart';
import 'package:safe_streets/services/access_manager.dart';
import 'package:safe_streets/services/utilities.dart';
import 'package:safe_streets/ui/sign_up_page.dart';
import 'home_page.dart';

///this is the Login page

class SignInPage extends StatelessWidget {
  static var _scaffoldKey = GlobalKey<ScaffoldState>();


  Widget build(BuildContext context) {
    String _email = "";
    String _password = "";
    final auth = Provider.of<AccessManager>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Sign in'),
          actions: <Widget>[
            FlatButton(
              key: Key("create"),
              child: Text(
                "Create Account",
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),

              ///this will open the sign_up_page on click
              onPressed: () {
                ValueNotifier<bool> checked = ValueNotifier(false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<ValueNotifier<bool>>.value(
                              value: checked,
                              child: SignUpPage(),
                            )));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 24.0),
              TextFormField(
                key: Key("email-field"),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  icon: Icon(Icons.email),
                  hintText: 'Your email address',
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  _email = value;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                key: Key("password-field"),
                obscureText: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  icon: Icon(Icons.vpn_key),
                  labelText: 'Password',
                ),
                onChanged: (String value) {
                  _password = value;
                },
              ),
              SizedBox(height: 24.0),

              ///this is the sign in button
              OutlineButton(
                key: Key("signin"),
                splashColor: Colors.blue,
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                child: Text('Sign in'),
                onPressed: () async {
                  try {
                    FirebaseUser user = await auth.signInWithEmailAndPassword(
                        _email, _password);
                    DocumentSnapshot map = await Firestore.instance
                        .collection("users")
                        .document(user.email)
                        .snapshots()
                        .first;
                    User u = AccessManager.createUserObject(map, user);
                    Utilities.showProgress(context);
                    await u.getAllReports();
                    await u.getPosition(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<User>.value(
                                  value: u,
                                  child: HomePage(),
                                )));
                  } catch (error) {
                    final snackBar = SnackBar(
                        key: Key("snack1"),
                        content: Text(Utilities.printError(error.toString())));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                },
              ),
            ],
          ),
        ));
  }
}
