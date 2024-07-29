import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment {
  int? id;
  String? comment1;
  int? userid;
  int? contentid;
  dynamic? date;
  String? fullname;
  String? photo;
  Comment(
      { this.id,
         this.comment1,
         this.userid,
          this.date,
         this.contentid,
          this.fullname,
          this.photo
      });
  Comment.fromMap(Map<String,dynamic> map){
    id=map["id"];
    comment1=map["comment1"];
    userid=map["userid"];
    date=map["date"];
    contentid=map["contentid"];
    fullname=map["fullname"];
    photo=map["photo"];
  }
  Map<String,dynamic> toMap(){
    var dateFormat = DateFormat("dd/MM/yyyy");
    return <String,dynamic>{
      "id":id ?? 0,
      "comment1":comment1,
      "userid":userid,
      "contentid":contentid,
      "date":date,
      "fullname":fullname,
      "photo":photo,
    };
  }
}
