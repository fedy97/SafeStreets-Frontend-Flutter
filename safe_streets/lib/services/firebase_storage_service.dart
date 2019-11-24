import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:safe_streets/model/report/violation_image.dart';

class FirebaseStorageService {
  Future<String> uploadImages(
      {@required ViolationImage image,
      @required String mail,
      @required int timestamp, @required int index}) async {
    String path = _createPath(image, mail, timestamp.toString(), index);
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageRef.putFile(image.imageFile, StorageMetadata());
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) throw snapshot.error;
    return await snapshot.ref.getDownloadURL();
  }

  String _createPath(ViolationImage image, String mail, String timestamp, int index) {
    //mail/timestampRecord/imagesList
    return "$mail/$timestamp/" + index.toString();
  }
}
