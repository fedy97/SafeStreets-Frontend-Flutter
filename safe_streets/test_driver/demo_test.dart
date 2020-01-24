import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:core';
import 'dart:math';


///to run self driven tests, first open your emulator or connect device,
///then open terminal, navigate to safe_streets directory and run:
///-->" flutter drive --target=test_driver/demo.dart "<--
///if an user is already signed in, log out to let the driven tests start
///
/// "feedback a violation for the fist time" and "feedback a violation for the second time"
/// require that at least one report located in Milan is stored in the database.
/// See the ITD document on chapter Testing, section Integration Testing for more information.
///
void main() {
  group("SafeStreets self-driven tests", () {
    final emailField = find.byValueKey("email-field");
    final emailFieldUp = find.byValueKey("email");
    final passwordField1 = find.byValueKey("password1");
    final passwordField2 = find.byValueKey("password2");
    final passwordField = find.byValueKey("password-field");
    final signInButton = find.byValueKey("signin");
    final userInfoPage = find.byType("HomePage");
    final reportPage = find.byType("ViewReportCitizen");
    final signUpPage = find.byType("SignUpPage");
    final snackbar = find.byValueKey("snack1");
    final check = find.byValueKey("check");
    final signUpButton = find.byValueKey("signup");
    final idField = find.byValueKey("id");
    final back = find.byTooltip('Back');
    final back2 = find.byTooltip('Back');
    final create = find.byValueKey("create");
    final newReportButton = find.byValueKey("newReport");
    final sendReportButton = find.byValueKey("send");
    final sendReportPage = find.byType("CreateReportPage");
    final menuButton = find.byTooltip('Open navigation menu');
    final myReportsButton = find.byValueKey("myReports");
    final deleteReportButton = find.byValueKey("deleteReportButton");
    final reportTile = find.byValueKey("reportTile");
    final loading = find.byValueKey("loading");
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    final cameraButton = find.byValueKey("camera");
    final cityField = find.byValueKey("city");
    final snackbar3 = find.byValueKey("snack3");
    final snackbar4 = find.byValueKey("snack4");
    final cityEnable = find.byValueKey("cityUsed");
    final searchButton = find.byValueKey("searchButton");
    final queryPageButton = find.byValueKey("queryPageButton");

    String testEmail;


    String randomString(int strlen) {
      Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
      String result = "";
      for (var i = 0; i < strlen; i++) {
        result += chars[rnd.nextInt(chars.length)];
      }
      return result;
    }

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
        await Future.delayed(Duration(seconds: 2));
        testEmail = randomString(16) + "@testmail.com";
        await driver.enterText(testEmail);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(passwordField);
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText("test00");
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(signInButton);
        await driver.waitFor(snackbar);
        await Future.delayed(Duration(seconds: 2));
      });
    });

    test("sign up",() async{
      await driver.runUnsynchronized(() async {
        await driver.tap(create);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(emailFieldUp);
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText(testEmail);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(passwordField1);
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText("test00");
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(passwordField2);
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText("test00");
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(signUpButton);
        await Future.delayed(Duration(seconds: 2));
        //await driver.waitFor(snackbar);
        //assert(snackbar != null);
        await driver.tap(check);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(signUpButton);
        //await Future.delayed(Duration(seconds: 4));
        //await Future.delayed(Duration(seconds: 1));
        //await driver.tap(back);
        //await Future.delayed(Duration(seconds: 1));
      });
    });

    /*test("logs in with correct email and password",() async {
      await driver.runUnsynchronized(() async {
        await driver.tap(emailField);
        await Future.delayed(Duration(seconds: 1));
        await driver.enterText(testEmail);
        await driver.tap(passwordField);
        await Future.delayed(Duration(seconds: 1));
        await driver.enterText("test00");
        await driver.tap(signInButton);
        await driver.waitFor(userInfoPage);
        assert(userInfoPage != null);
        await Future.delayed(Duration(seconds: 2));
      });
    });*/

    test("report send fail because no image", () async{
      await driver.runUnsynchronized(() async{
        await driver.waitFor(newReportButton);
        await Future.delayed(Duration(seconds: 4));
        await driver.tap(newReportButton);
        await Future.delayed(Duration(seconds: 3));
        await driver.tap(sendReportButton);
        await Future.delayed(Duration(seconds: 3));
        await driver.waitFor(find.byValueKey("snack1"));
      });
    });

    test("add a report with an image", () async{
      await driver.runUnsynchronized(() async {
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(cameraButton);
        await driver.waitFor(find.byValueKey("loading"));
        await driver.waitForAbsent(find.byValueKey("loading"));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("note"));
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText("DEMO NOTE");
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("violationDropDown"));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("Violation.parking_on_zebra_crossing"));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("send"));
        await driver.waitFor(find.byValueKey("loading"));
        await driver.waitForAbsent(find.byValueKey("loading"));
      });
    });

    test("check user's reports", () async{
      await driver.runUnsynchronized(() async {
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(menuButton);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(myReportsButton);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("reportTile"));
        await Future.delayed(Duration(seconds: 5));
        await driver.tap(find.byTooltip('Back'));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(back2);
        await Future.delayed(Duration(seconds: 2));
      });
    });

    test("logout", () async{
      await driver.runUnsynchronized(() async{
        await driver.tap(menuButton);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("logout"));
        await Future.delayed(Duration(seconds: 2));
      });
    });

    test("login as autority",() async{
      await driver.runUnsynchronized(() async {
        await driver.tap(emailField);
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText("a@a.it");
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(passwordField);
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText("aaaaaa");
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(signInButton);
        await Future.delayed(Duration(seconds: 2));
        await driver.waitFor(find.byType("HomePage"));
      });
    });

    test("get all the violation for parking on zebra crossing in Milan", () async{
      await driver.runUnsynchronized(() async{
        await Future.delayed(Duration(seconds: 3));
        await driver.tap(menuButton);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(queryPageButton);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(cityField);
        await Future.delayed(Duration(seconds: 2));
        await driver.enterText("Milano");
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(cityEnable);
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("violation"));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("Violation.parking_on_zebra_crossing"));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("violationEnable"));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(searchButton);
        await driver.waitFor(find.byValueKey("loading"));
        await driver.waitForAbsent(find.byValueKey("loading"));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("Report 1"));
      });
    });

    test("fine the violation", () async{
      await driver.runUnsynchronized(() async{
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey("fineButton"));
        await Future.delayed(Duration(seconds: 2));
      });
    });



  });
}