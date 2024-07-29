import 'package:intl/intl.dart';

class Notification {
  int? id;
  int? contentId;
  dynamic? dateContent;
  int? storyId;
  dynamic? dateStory;
  int? likeId;
  dynamic? dateLike;
  dynamic? status;
  int? userId;
  int? friendshipId;
  dynamic? dateFriendship;
  int? messageId;
  dynamic? dateMessage;
  int? commentId;
  dynamic? dateComment;
  String? userPhoto;
  String? fullname;
  bool? statusFriendship;

  Notification({
    this.id,
    this.contentId,
    this.dateContent,
    this.storyId,
    this.dateStory,
    this.likeId,
    this.status,
    this.dateLike,
    this.friendshipId,
    this.dateFriendship,
    this.messageId,
    this.dateMessage,
    this.commentId,
    this.dateComment,
    this.userId,
    this.userPhoto,
    this.fullname,
    this.statusFriendship
  });

  Notification.fromMap(Map<String, dynamic> map) {
    var dateFormat = DateFormat("dd/MM/yyyy");
    id = map["id"];
    contentId = map["contentId"];
    dateContent = map["dateContent"] != null ? DateTime.parse(map["dateContent"]) : null;
    storyId = map["storyId"];
    dateStory = map["dateStory"] != null ? DateTime.parse(map["dateStory"]) : null;
    likeId = map["likeId"];
    userId = map["userId"];
    dateLike = map["dateLike"] != null ? DateTime.parse(map["dateLike"]) : null;
    friendshipId = map["friendshipId"];
    dateFriendship = map["dateFriendship"] != null ? DateTime.parse(map["dateFriendship"]) : null;
    messageId = map["messageId"];
    status = map["status"];
    dateMessage = map["dateMessage"] != null ? DateTime.parse(map["dateMessage"]) : null;
    commentId = map["commentId"];
    dateComment = map["dateComment"] != null ? DateTime.parse(map["dateComment"]) : null;
    userPhoto = map["userPhoto"];
    fullname=map["fullname"];
    statusFriendship=map["statusFriendship"];
  }

  Map<String, dynamic> toMap() {
    var dateFormat = DateFormat("dd/MM/yyyy");
    return <String, dynamic>{
      "id": id ?? 0,
      "contentId": contentId,
      "dateContent": dateContent != null ? dateFormat.format(dateContent!) : null,
      "storyId": storyId,
      "dateStory": dateStory != null ? dateFormat.format(dateStory!) : null,
      "userId": userId,
      "likeId": likeId,
      "dateLike": dateLike != null ? dateFormat.format(dateLike!) : null,
      "friendshipId": friendshipId,
      "dateFriendship": dateFriendship != null ? dateFormat.format(dateFriendship!) : null,
      "messageId": messageId,
      "status": status,
      "dateMessage": dateMessage != null ? dateFormat.format(dateMessage!) : null,
      "commentId": commentId,
      "dateComment": dateComment != null ? dateFormat.format(dateComment!) : null,
      "userPhoto": userPhoto,
      "fullname": fullname,
      "statusFriendship": statusFriendship,
    };
  }
}