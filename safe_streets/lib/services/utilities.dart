import 'package:flutter/material.dart';

class Utilities {
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

  static String printError(String errorToParse) {
    if (errorToParse.split("(")[0] == "PlatformException") {
      String first = errorToParse.split("(")[1];
      String second = first.split(", ")[1];
      return second;
    }
    return errorToParse;
  }
}