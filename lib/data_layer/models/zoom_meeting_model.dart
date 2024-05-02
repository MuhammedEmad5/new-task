class ZoomMeetingModel {
  String? studentName;
  String? zoomMeetingUid;
  String? courseName;
  String? studentImage;
  List<String>? topics;
  List<String>? zoomMeetingOpened;


  ZoomMeetingModel({
    this.studentName,
    this.topics,
    this.courseName,
    this.zoomMeetingUid,
    this.zoomMeetingOpened,
    this.studentImage
  });

  ZoomMeetingModel.fromJson(Map<String, dynamic> json) {
    studentName = json['studentName'];
    zoomMeetingUid = json['zoomMeetingUid'];
    courseName = json['courseName'];
    studentImage = json['studentImage'];
    zoomMeetingOpened = List<String>.from(json['zoomMeetingOpened'] ?? []);
    topics = List<String>.from(json['topics'] ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      'studentImage': studentImage,
      'courseName': courseName,
      'zoomMeetingOpened': zoomMeetingOpened,
      'studentName': studentName,
      'zoomMeetingUid': zoomMeetingUid,
      'topics': topics,

    };
  }
}
