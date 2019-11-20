import 'package:safe_streets/model/report/report.dart';
import 'package:safe_streets/model/report/violation_image.dart';

class ReportToSend extends Report {

  ReportToSend({reportPosition, time, violation, images, emailUser})
      : super(reportPosition: reportPosition, images: images, time: time, emailUser: emailUser, violation: violation);

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
    List<String> downloadLinks = new List();
    List<String> plates = new List();
    List<String> accuracyList = new List();
    for (ViolationImage image in images) {
      downloadLinks.add(image.downloadLink);
      accuracyList.add(image.accuracy.toString());
      plates.add(image.plate);
    }
    return {
      'note': note,
      'images': {
        'links': downloadLinks,
        'plates': plates,
        'accuracy': accuracyList
      },
      'violation': violation.toString(),
      'location': reportPosition.toString(),
      'time': time.millisecondsSinceEpoch,
      'feedback' : 0
    };
  }

}
