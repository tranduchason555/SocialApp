import 'package:intl/intl.dart';

class Contentfriendship {
  int? id;
  String? content1;
  String? contentPhoto;
  dynamic? date;
  String? fullname;
  String? photo;
  dynamic? userId;
  int? storyId;
  int? commentUserId;
  dynamic? status;
  dynamic? countLike;
  dynamic? countSave;

  Contentfriendship({
    this.id,
    this.content1,
    this.contentPhoto,
    DateTime? date,
    this.fullname,
    this.photo,
    this.userId,
    this.storyId,
    this.commentUserId,
    this.status,
    this.countLike,
    this.countSave
  }) : date = date ?? DateTime.now();

  Contentfriendship.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    content1 = map['content1'];
    contentPhoto = map['contentPhoto'];
    date = map['date'] != null ? DateTime.parse(map['date']) : null;
    fullname = map['fullname'];
    photo = map['photo'];
    userId = map['userId'];
    storyId = map['storyId'];
    commentUserId = map['commentUserId'];
    status = map['status'];
    countLike = map['countLike'];
    countSave = map['countSave'];
  }

  Map<String, dynamic> toMap() {
    var dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return <String, dynamic>{
      'id': id ?? 0,
      'content1': content1,
      'contentPhoto': contentPhoto,
      'fullname': fullname,
      'photo': photo,
      'userId': userId,
      'date': date != null ? dateFormat.format(date!) : null,
      'storyId': storyId,
      'commentUserId': commentUserId,
      'status': status,
      'countLike': countLike,
      'countSave': countSave,
    };
  }
}