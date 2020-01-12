import 'package:safe_streets/model/report/report.dart';
import 'package:safe_streets/model/report/violation_image.dart';

///this class is used to create report object to send
///to firebase, in fact there is a method called "toMap" that converts
///this object to a json map, that firebase can read.
class ReportToSend extends Report {
  ReportToSend({reportPosition, time, violation, images, emailUser})
      : super(
            reportPosition: reportPosition,
            images: images,
            time: time,
            emailUser: emailUser,
            violation: violation);

  ///It adds an image to the report
  void addImage(ViolationImage image) {
    if (this.images.length < 5) this.images.add(image);
  }

  ///It removes all the images
  Future removeAllImages() {
    for (ViolationImage vi in this.images) {
      vi.imageFile.delete();
    }
    this.images.clear();
    return null;
  }

  ///It adds notes
  void addNote(String note) {
    this.note = note;
  }

  Map<String, dynamic> toMap() {
    List<String> downloadLinks = new List();
    List<String> plates = new List();
    List<Map<String, dynamic>> boxes = new List();
    List<String> accuracyList = new List();
    List<int> feedback = new List();
    List<String> imageFeedbackSenders = new List();
    List<String> feedbackSenders = new List();
    for (ViolationImage image in images) {
      downloadLinks.add(image.downloadLink);
      accuracyList.add(image.accuracy.toString());
      plates.add(image.plate);
      image.box == null ? boxes.add({"empty": 0}) : boxes.add(image.box);
      feedback.add(0);
      imageFeedbackSenders.add("");
    }
    return {
      'note': note,
      'images': {
        'links': downloadLinks,
        'plates': plates,
        'boxes': boxes,
        'accuracy': accuracyList,
        'imageFeedback': feedback,
        'imageFeedbackSenders': imageFeedbackSenders
      },
      'violation': violation.toString(),
      'location': reportPosition.toString(),
      'zone': reportPosition.address,
      'time': time.millisecondsSinceEpoch,
      'feedback': 0,
      'feedbackSenders': feedbackSenders,
      'fined': false
    };
  }
}
