import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Save {
  int? id;
  int? contentid;
  String? contentPhoto;
  String? userPhoto;
  dynamic? date;
  String? fullname;
  int? userId;
  Save(
      { this.id,
        this.contentid,
        this.contentPhoto,
        this.date,
        this.fullname,
        this.userId,
        this.userPhoto,
      });
  Save.fromMap(Map<String,dynamic> map){
    id=map["id"];
    contentid=map["contentid"];
    contentPhoto=map["contentPhoto"];
    date=map["date"];
    fullname=map["fullname"];
    userId=map["userId"];
    userPhoto=map["userPhoto"];
  }
  Map<String,dynamic> toMap(){
    var dateFormat = DateFormat("dd/MM/yyyy");
    return <String,dynamic>{
      "id":id ?? 0,
      "contentid":contentid,
      "contentPhoto":contentPhoto,
      "fullname":fullname,
      "userId":userId,
      "userPhoto":userPhoto,
      "date":date,
    };
  }
}
