import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

///to run self driven tests, first open your emulator or connect device,
///then open terminal, navigate to safe_streets directory and run:
///-->" flutter drive --target=test_driver/app.dart "<--
void main() {
  group("Sign in self-driven test", () {
    final emailField = find.byValueKey("email-field");
    final passwordField = find.byValueKey("password-field");
    final signInButton = find.byValueKey("signin");
    final userInfoPage = find.byType("HomePage");
    final snackbar = find.byValueKey("snack1");

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