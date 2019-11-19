import 'package:safe_streets/model/report/report.dart';
import 'package:safe_streets/model/report/violation_image.dart';

class ReportToSend extends Report {
  List<String> downloadUrlImages = new List();

  ReportToSend({reportPosition, time, violation, images, emailUser})
      : super(time: time, emailUser: emailUser, violation: violation);

  void addImage(ViolationImage image) {
    if (this.images.length < 5) this.images.add(image);
  }

  Future removeAllImages() {
    for (ViolationImage vi in this.images) {
      vi.imageFile.delete();
    }
    this.images.clear();
    return null;
  }

  void addNote(String note) {
    this.note = note;
  }

  Map<String, dynamic> toMap() {
    List<String> plates = new List();
    List<String> accuracyList = new List();
    for (ViolationImage image in images) {
      accuracyList.add(image.accuracy.toString());
      plates.add(image.plate);
    }
    return {
      'note': note,
      'images': {
        'links': downloadUrlImages,
        'plates': plates,
        'accuracy': accuracyList
      },
      'violation': violation.toString(),
      'location': reportPosition.toString(),
      'time': time.millisecondsSinceEpoch,
      'feedback' : feedback
    };
  }

  //TODO "from map" constructor, when receiving a map from firebase, $this instance must be created
}