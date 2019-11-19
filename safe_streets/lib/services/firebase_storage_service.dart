import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:safe_streets/model/report/report_to_send.dart';
import 'package:safe_streets/model/report/violation_image.dart';

class FirebaseStorageService {
  Future<List<String>> uploadImages({@required List<ViolationImage> images, @required String mail, @required int timestamp}) async {
    List<String> downloadLinks = new List();
    for (ViolationImage image in images) {
      String path = _createPath(image, mail, timestamp.toString());
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final uploadTask = storageRef.putFile(image.imageFile, StorageMetadata());
      final snapshot = await uploadTask.onComplete;
      if (snapshot.error != null)
        throw snapshot.error;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      downloadLinks.add(downloadUrl);
    }
    return downloadLinks;
  }

  String _createPath(ViolationImage image, String mail, String timestamp) {
    //mail/timestampRecord/imagesList
    return "$mail/$timestamp/" + image.imageFile.path.split("/").last;
  }
}