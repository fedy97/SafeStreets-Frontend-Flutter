import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_streets/model/user/authority.dart';
import 'package:safe_streets/model/user/citizen.dart';
import 'package:safe_streets/model/user/user.dart';

///It menages the access of a user
class AccessManager {
  final _firebaseAuth = FirebaseAuth.instance;

  ///getter
  Stream<FirebaseUser> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged;
  }

  ///It signs in a generic user by his mail and password
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return authResult.user;
  }

  ///It signs in a user calling signInWithEmailAndPassword function
  Future<bool> signIn(String email, String password) async {
    try {
      FirebaseUser u = await signInWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///It creates a new user
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return authResult.user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  ///It returns the current user
  Future<FirebaseUser> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  ///after the creation of the user in firebase, the object itself is needed
  ///locally to perform actions
  static User createUserObject(DocumentSnapshot map, FirebaseUser user) {
    if (map.data['level'] == "standard") {
      return new Citizen(user.email, user.uid);
    } else {
      return new Authority(user.email, user.uid, map.data['idAuthority']);
    }
  }

  ///this is the map that will be sent to firebase when a new user is created
  ///successfully.
  static Map<String, dynamic> createUserMap({@required email, idAuthority}) {
    return {
      'level': idAuthority == "" ? 'standard' : 'complete',
      'idAuthority': idAuthority != "" ? idAuthority : null,
      'reportSent': []
    };
  }

  ///this method will check if a user tries to create a account with a
  ///already present id, in that case an error is thrown.
  static Future<bool> checkIdAlreadyPresent(GlobalKey<ScaffoldState> scaffold,
      String id, BuildContext context) async {
    final auth = Provider.of<AccessManager>(context, listen: false);
    QuerySnapshot query =
        await Firestore.instance.collection("users").getDocuments();
    for (DocumentSnapshot doc in query.documents) {
      if (doc.data["level"] == "complete" && doc.data["idAuthority"] == id) {
        final snackBar = SnackBar(content: Text("id authority already used"));
        scaffold.currentState.showSnackBar(snackBar);
        return true;
      }
    }
    return false;
  }
}
