import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

///to run self driven tests, first open your emulator or connect device,
///then open terminal, navigate to safe_streets directory and run:
///-->" flutter drive --target=test_driver/app.dart "<--
void main() {
  group("SafeStreets self-driven tests", () {
    final emailField = find.byValueKey("email-field");
    final emailFieldUp = find.byValueKey("email");
    final passwordField1 = find.byValueKey("password1");
    final passwordField2 = find.byValueKey("password2");
    final passwordField = find.byValueKey("password-field");
    final signInButton = find.byValueKey("signin");
    final userInfoPage = find.byType("HomePage");
    final signUpPage = find.byType("SignUpPage");
    final snackbar = find.byValueKey("snack1");
    final check = find.byValueKey("check");
    final signUpButton = find.byValueKey("signup");
    final idField = find.byValueKey("id");
    final back = find.byTooltip('Back');
    final create = find.byValueKey("create");

    FlutterDriver driver;
    setUpAll(()async{
      driver = await FlutterDriver.connect();
    });

    tearDownAll(()async{
      if(driver != null) {
        driver.close();
      }
    });

    test("login fails with incorrect email and password, provides snackbar feedback",() async{
      await driver.runUnsynchronized(() async {
        await driver.tap(emailField);
        await Future.delayed(Duration(seconds: 1));
        await driver.enterText("test@testmail.com");
        await driver.tap(passwordField);
        await Future.delayed(Duration(seconds: 1));
        await driver.enterText("test");
        await driver.tap(signInButton);
        await driver.waitFor(snackbar);
        assert(snackbar != null);
        assert(userInfoPage == null);
        await Future.delayed(Duration(seconds: 1));
      });
    });

    test("open sign up page",() async{
      await driver.runUnsynchronized(() async {
        await driver.tap(create);
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(emailFieldUp);
        await driver.enterText("test@testmail.com");
        await driver.tap(passwordField1);
        await Future.delayed(Duration(seconds: 1));
        await driver.enterText("test");
        await driver.tap(signUpButton);
        await driver.waitFor(snackbar);
        assert(snackbar != null);
        assert(userInfoPage == null);
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(back);
        await Future.delayed(Duration(seconds: 1));
      });
    });

    test("logs in with correct email and password",() async {
      await driver.runUnsynchronized(() async {
        await driver.tap(emailField);
        await Future.delayed(Duration(seconds: 1));
        await driver.enterText("f@f.it");
        await driver.tap(passwordField);
        await Future.delayed(Duration(seconds: 1));
        await driver.enterText("ffffff");
        await driver.tap(signInButton);
        await driver.waitFor(userInfoPage);
        assert(userInfoPage != null);
      });
    });

  });
}