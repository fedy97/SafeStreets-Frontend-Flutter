import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:safe_streets/services/access_manager.dart';
import 'package:safe_streets/ui/sign_in_page.dart';

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
  Widget _makeTestable(Widget child) {
    return Provider<AccessManager>.value(
      value: authUser,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  var emailField = find.byKey(Key("email-field"));
  var passwordField = find.byKey(Key("password-field"));
  var signInButton = find.byKey(Key("signin"));

  group("login page test", ()
  {
    when(authUser.signIn("test@testmail.com", "password")).thenAnswer((_) async {
      return false;
    });
    testWidgets(
        'email, password and button are found', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(SignInPage()));
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(signInButton, findsOneWidget);
    });
  });
  testWidgets("validates empty email and password", (WidgetTester tester) async{
    await tester.pumpWidget(_makeTestable(SignInPage()));
    await tester.tap(signInButton);
    expect(find.byKey(Key("snack1")),findsNothing);
    await tester.pump(new Duration(milliseconds: 100));
    expect(find.byKey(Key("snack1")),findsOneWidget);
  });
  testWidgets("calls sign in method when email and password is entered", (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestable(SignInPage()));
    await tester.enterText(emailField, "test@testmail.com");
    await tester.enterText(passwordField, "password");
    await tester.tap(signInButton);
    await tester.pump();
    ///must be called only once
    verify(authUser.signInWithEmailAndPassword("test@testmail.com", "password")).called(1);
  });

}