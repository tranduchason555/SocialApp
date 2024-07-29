import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Story {
  int? id;
  String? content;
  DateTime? date;
  String? photo;
  String? photoUser;
  String? fullname;
  int? userId;
  dynamic? status;

  Story({
    this.id,
    this.content,
    DateTime? date,
    this.fullname,
    this.photoUser,
    this.photo,
    this.userId,
    this.status
  }) : date = date ?? DateTime.now();

  // Factory constructor to create a Story from a map
  Story.fromMap(Map<String, dynamic> map) {
    var dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    id = map['id'];
    content = map['content'];
    date = map['date'] != null ? DateTime.parse(map['date']) : null;
    fullname = map['fullname'];
    photoUser = map['photoUser'];
    photo = map['photo'];
    userId = map['userId'];
    status = map['status'];
  }

  // Method to convert a Story to a map
  Map<String, dynamic> toMap() {
    var dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return {
      "id": id ?? 0,
      "content": content,
      "date": date != null ? dateFormat.format(date!) : null,
      "fullname": fullname,
      "photoUser": photoUser,
      "photo": photo,
      "userId": userId,
      "status:": status,
    };
  }
}