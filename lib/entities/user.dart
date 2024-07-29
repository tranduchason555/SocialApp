import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Users {
  int? id;
  String? email;
  String? password;
  String? fullname;
  String? address;
  String? age;
  String? phone;
  String? photo;
  int? roleId;
  dynamic? countContent;
  dynamic? countFriend;
  dynamic? content;
  dynamic? contentId;
  dynamic? contentPhoto;
  dynamic? notificationCount;
  dynamic? countLike;
  dynamic? status;
  dynamic? friendshipId;
  Users(
      {this.id,
        this.email,
        this.password,
        this.fullname,
        this.address,
        this.age,
        this.phone,
        this.photo,
        this.roleId,
        this.countContent,
        this.countFriend,
        this.content,
        this.contentId,
        this.contentPhoto,
        this.notificationCount,
        this.countLike,
        this.status,
        this.friendshipId
      });
  Users.fromMap(Map<String,dynamic> map){
    id=map["id"];
    email=map["email"];
    password=map["password"];
    fullname=map["fullname"];
    address=map["address"];
    age=map["age"];
    phone=map["phone"];
    photo=map["photo"];
    countContent=map["countContent"];
    countFriend=map["countFriend"];
    contentPhoto=map["contentPhoto"];
    contentId=map["contentId"];
    notificationCount=map["notificationCount"];
    countLike=map["countLike"];
    status=map["status"];
    friendshipId=map["friendshipId"];
    roleId=map["roleId"];
  }
  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id":id ?? 0,
      "email":email,
      "password":password,
      "fullname":fullname,
      "address":address,
      "age":age,
      "phone":phone,
      "photo":photo,
      "roleId":roleId,
      "countContent":countContent,
      "countFriend":countFriend,
      "contentPhoto":contentPhoto,
      "contentId":contentId,
      "notificationCount":notificationCount,
      "countLike":countLike,
      "status":status,
      "friendshipId":friendshipId,
    };
  }
  Users copyWith({
    int? id,
    String? email,
    String? password,
    String? fullname,
    String? address,
    String? age,
    String? phone,
    String? photo,
    int? roleId,
    dynamic countContent,
    dynamic countFriend,
    dynamic content,
    dynamic contentId,
    dynamic contentPhoto,
    dynamic notificationCount,
    dynamic countLike,
    dynamic status,
    dynamic friendshipId,
  }) {
    return Users(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      fullname: fullname ?? this.fullname,
      address: address ?? this.address,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      roleId: roleId ?? this.roleId,
      countContent: countContent ?? this.countContent,
      countFriend: countFriend ?? this.countFriend,
      content: content ?? this.content,
      contentId: contentId ?? this.contentId,
      contentPhoto: contentPhoto ?? this.contentPhoto,
      notificationCount: notificationCount ?? this.notificationCount,
      countLike: countLike ?? this.countLike,
      status: status ?? this.status,
      friendshipId: friendshipId ?? this.friendshipId,
    );
  }
}

