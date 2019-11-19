import 'dart:io';

import 'package:flutter/cupertino.dart';

class ViolationImage {
  File imageFile;
  bool isSensitive = false;
  String plate = "";
  double accuracy = 0;

  ViolationImage({@required this.imageFile, @required this.plate,@required this.accuracy}) {
    if (this.plate != "") isSensitive = true;
  }
}
