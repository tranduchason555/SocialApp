import 'dart:convert';
import 'package:appmangxahoi/entities/friendship.dart';
import 'package:appmangxahoi/entities/message.dart';
import 'package:appmangxahoi/entities/save.dart';
import 'package:flutter/material.dart';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:http/http.dart' as http;
class SaveAPI{
  Future<List<dynamic>>findByUserid(int userid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"save/findByUserId/${userid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Save.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<bool> create(Save like) async {
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response = await http.post(
      Uri.parse(BareUrl.url + "save/create"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(like.toMap()),
      headers: {
        //DỮ LIỆU TRUYỀN LÊN KIỂU JSON
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      dynamic dyn = jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ CHỈ CÓ 1 NÊN TRẢ TRỰC TIOE61 ĐỐI TƯỢNG
      return dyn["status"];
    } else {
      throw Exception("Bad request");
    }
  }
  Future<bool> delete(dynamic id) async {
    try {
      var response = await http.delete(Uri.parse(BareUrl.url + "save/delete/${id}"));
      if (response.statusCode == 200) {
        dynamic dyn = jsonDecode(response.body);
        return dyn["result"] ?? false; // Return false if dyn["result"] is null
      } else {
        throw Exception("Bad request");
      }
    } catch (e) {
      print("Error deleting like: $e");
      return false; // Return false in case of error
    }
  }
  Future<List<dynamic>>findByContentId(int contentid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"save/findByContentid/${contentid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Save.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
}