import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chat {
  int? id;
  String? content;
  int? userid;
  dynamic? date;
  int? messagesid;
  Chat(
      { this.id,
        this.content,
        this.userid,
        this.date,
        this.messagesid,

      });
  Chat.fromMap(Map<String,dynamic> map){
    id=map["id"];
    content=map["content"];
    userid=map["userid"];
    date=map["date"];
    messagesid=map["messagesid"];

  }
  Map<String,dynamic> toMap(){
    var dateFormat = DateFormat("dd/MM/yyyy");
    return <String,dynamic>{
      "id":id ?? 0,
      "content":content,
      "userid":userid,
      "messagesid":messagesid,
      "date":date,
    };
  }
}
