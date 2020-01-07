import 'package:flutter/material.dart';

class Utilities {
  ///this is a progress circular indicator
  ///used when a page is waiting for something from the net.
  static void showProgress(BuildContext context) {
    showDialog(
        context: context,
        builder: (context2) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 10.0,
                ),
                new Text("Loading"),
              ],
            ),
          );
        });
  }
  ///this return some errors from firebase,
  ///for example if the email is badly formatted during the sign up process
  static String printError(String errorToParse) {
    if (errorToParse.split("(")[0] == "PlatformException") {
      String first = errorToParse.split("(")[1];
      String second = first.split(", ")[1];
      return second;
    }
    return errorToParse;
  }


   ///dart does not allow printing on the console more than TOT words, if you print something
   ///that is too long it will be cut out, with this everything will be printed
   ///useful for debug
  static void printEverything(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
  ///this will show a alert dialog with
  ///a custom message with 2 buttons, "Ok" and "Close"
  static Future<bool> showAlert(BuildContext context, String message) async {
    bool result = false;
    await showDialog(
        context: context,
        child: AlertDialog(
          title: new Text("Alert"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
                result = false;
              },
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  result = true;
                },
                child: Text("Ok"))
          ],
        ));
    return result;
  }
}
