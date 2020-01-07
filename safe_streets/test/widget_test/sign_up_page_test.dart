import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:safe_streets/services/access_manager.dart';
import 'package:safe_streets/ui/sign_up_page.dart';

class MockUser extends Mock implements AccessManager {
  final MockFirebaseAuth auth;
  MockUser({this.auth});
}

class MockFirebaseAuth extends Mock implements FirebaseAuth{}
class MockFirebaseUser extends Mock implements FirebaseUser{}

void main() {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  //BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  MockUser authUser;
  authUser = MockUser(auth: _auth);
  ValueNotifier<bool> checked = ValueNotifier(false);
  Widget _makeTestable(Widget child) {
    return Provider<AccessManager>.value(
      value: authUser,
      child: ChangeNotifierProvider<ValueNotifier<bool>>.value(
        value: checked,
        child: MaterialApp(
          home: child,
        ),
      ),
    );
  }

  var emailField = find.byKey(Key("email"));
  var passwordField = find.byKey(Key("password1"));
  var confPassField = find.byKey(Key("password2"));
  var idField = find.byKey(Key("id"));
  var signUpButton = find.byKey(Key("signup"));
  var check = find.byKey(Key("check"));

  group("signup page test", ()
  {
    testWidgets(
        'email, password, confirm password and button are found', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(SignUpPage()));
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(confPassField, findsOneWidget);
      expect(idField, findsOneWidget);
      expect(signUpButton, findsOneWidget);
      expect(check, findsOneWidget);
    });
    testWidgets("validates empty fields", (WidgetTester tester) async{
      await tester.pumpWidget(_makeTestable(SignUpPage()));
      await tester.tap(signUpButton);
      expect(find.byKey(Key("snack1")),findsNothing);
      await tester.pump(new Duration(milliseconds: 100));
      expect(find.byKey(Key("snack1")),findsOneWidget);
    });
    testWidgets("calls sign up method when email and password is entered", (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(SignUpPage()));
      await tester.enterText(emailField, "morre@m.it");
      await tester.enterText(passwordField, "password");
      await tester.enterText(confPassField, "password");
      await tester.tap(check);
      await tester.tap(signUpButton);
      await tester.pump();
      ///must be called only once
      verify(authUser.createUserWithEmailAndPassword("morre@m.it", "password")).called(1);
    });

  });
}