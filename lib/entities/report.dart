import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Report {
  int? id;
  String? contentreport;
  int? contentid;
  DateTime? date;
  int? userid;
  Report(
      { this.id,
        this.contentreport,
        this.contentid,
        this.userid,
        DateTime? date,
      }): date = date ?? DateTime.now();
  Report.fromMap(Map<String,dynamic> map){
    id=map["id"];
    contentreport=map["contentreport"];
    contentid=map["contentid"];
    userid=map["userid"];
    date = map['date'] != null ? DateTime.parse(map['date']) : null;
  }
  Map<String,dynamic> toMap(){
    var dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return <String,dynamic>{
      "id":id ?? 0,
      "contentreport":contentreport,
      "contentid":contentid,
      "userid":userid,
      "date": date != null ? dateFormat.format(date!) : null,
    };
  }
}
