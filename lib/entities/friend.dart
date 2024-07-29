import 'package:intl/intl.dart';

class Friend {
  int? id;
  int? userid1;
  bool? status;
  DateTime? date;
  int? userid2;
  String? fullname;
  String? photo;
  Friend({
    this.id,
    this.userid1,
    this.status,
    DateTime? date,
    this.userid2,
    this.fullname,
    this.photo,
  }) : date = date ?? DateTime.now();

  Friend.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userid1 = map['userid1'];
    status = map['status'];
    date = map['date'] != null ? DateTime.parse(map['date']) : null;
    userid2 = map['userid2'];
    fullname = map['fullname'];
    photo = map['photo'];
  }

  Map<String, dynamic> toMap() {
    var dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return <String, dynamic>{
      'id': id ?? 0,
      'userid1': userid1,
      'userid2': userid2,
      'status': status,
      'date': date != null ? dateFormat.format(date!) : null,
      'fullname': fullname,
      'photo':photo
    };
  }
}