class PostQuestionModel {
  String? questionTitle;
  String? postIUid;
  List<String>? wantedUsers;
  List<String>? postOpened;


  PostQuestionModel({
    this.questionTitle,
    this.wantedUsers,
    this.postIUid,
    this.postOpened
  });

  PostQuestionModel.fromJson(Map<String, dynamic> json) {
    questionTitle = json['questionTitle'];
    postIUid = json['postIUid'];
    postOpened = List<String>.from(json['postOpened'] ?? []);
    wantedUsers = List<String>.from(json['wantedUsers'] ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      'postOpened': postOpened,
      'questionTitle': questionTitle,
      'postIUid': postIUid,
      'wantedUsers': wantedUsers,

    };
  }
}
