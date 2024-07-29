import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message {
  dynamic? messageId;
  int? userId;
  String? userPhoto;
  String? otherUserPhoto;
  int? otherUserId;
  String? contentPhoto;
  String? fullName;
  String? otherFullName;
  dynamic? date;
  dynamic? content;
  Message(
      {this.messageId,
        this.userId,
        this.userPhoto,
        this.otherUserPhoto,
        this.otherUserId,
        this.contentPhoto,
        this.date,
        this.fullName,
        this.otherFullName,
        this.content
      });
  Message.fromMap(Map<String,dynamic> map){
    messageId=map["messageId"];
    userId=map["userId"];
    userPhoto=map["userPhoto"];
    otherUserPhoto=map["otherUserPhoto"];
    otherUserId=map["otherUserId"];
    contentPhoto=map["contentPhoto"];
    date=map["date"];
    fullName=map["fullName"];
    otherFullName=map["otherFullName"];
    content=map["content"];
  }
  Map<String,dynamic> toMap(){
    var dateFormat = DateFormat("dd/MM/yyyy");
    return <String,dynamic>{
      "messageId":messageId ?? 0,
      "userId":userId,
      "userPhoto":userPhoto,
      "otherUserPhoto":otherUserPhoto,
      "otherUserId":otherUserId,
      "date":date,
      "contentPhoto":contentPhoto,
      "fullName":fullName,
      "otherFullName":otherFullName,
      "content":content,
    };
  }
}
