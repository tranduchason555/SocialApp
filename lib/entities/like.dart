import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Like {
  dynamic? id;
  int? userid;
  int? contentId;
  Like(
      {this.id,
        this.userid,
        this.contentId,
      });
  Like.fromMap(Map<String,dynamic> map){
    id=map["id"];
    userid=map["userid"];
    contentId=map["contentId"];
  }
  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id":id ?? 0,
      "userid":userid,
      "contentId":contentId,
    };
  }
}
