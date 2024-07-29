import 'dart:convert';
import 'package:appmangxahoi/entities/friendship.dart';
import 'package:appmangxahoi/entities/message.dart';
import 'package:flutter/material.dart';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:http/http.dart' as http;
class MessageAPI{
  Future<List<dynamic>>findByUserid(int userid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"message/findByUserid/${userid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Message.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<List<dynamic>> findByFullname(int userId, String fullname) async {
    try {
      var response = await http.get(Uri.parse('${BareUrl.url}message/findByFullname/$userId/$fullname'));

      if (response.statusCode == 200) {
        List<dynamic> result = jsonDecode(response.body);
        return result.map((dyn) => Message.fromMap(dyn)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data: $e");
    }
  }
  Future<List<dynamic>> findByFullname1(String fullname) async {
    try {
      var response = await http.get(Uri.parse('${BareUrl.url}message/findByFullname1/$fullname'));

      if (response.statusCode == 200) {
        List<dynamic> result = jsonDecode(response.body);
        return result.map((dyn) => Message.fromMap(dyn)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load data: $e");
    }
  }
  Future<List<dynamic>>findByMessageid(int userid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"message/findByMessageid/${userid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Message.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<bool> create(Message message) async {
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response = await http.post(
      Uri.parse(BareUrl.url + "message/create"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(message.toMap()),
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
}