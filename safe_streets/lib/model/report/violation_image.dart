import 'dart:io';

import 'package:flutter/cupertino.dart';

///this is the image object created by a user when he
///takes a photo.
class ViolationImage {
  File imageFile;
  bool isSensitive = false;
  String plate = "";
  double accuracy = 0;
  String downloadLink = "";
  int feedback = 0;
  List<String> imageFeedbackSenders;
  Map<String, dynamic> box;

  ViolationImage(
      {@required this.imageFile,
      @required this.plate,
      @required this.accuracy,
      @required this.box,
      this.imageFeedbackSenders,
      this.feedback,
      this.downloadLink}
  ) {
    if (this.plate != "") isSensitive = true;
  }
}
