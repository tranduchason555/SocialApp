import 'dart:convert';
import 'package:appmangxahoi/entities/chat.dart';
import 'package:appmangxahoi/entities/comment.dart';
import 'package:flutter/material.dart';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:http/http.dart' as http;

class CommentAPI {

  Future<bool> create(Comment comment) async {
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response = await http.post(
      Uri.parse(BareUrl.url + "comment/create"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(comment.toMap()),
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

  Future<List<dynamic>> findByContentid(int contentid) async {
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response = await http
        .get(Uri.parse(BareUrl.url + "comment/findByContentid/${contentid}"));
    if (response.statusCode == 200) {
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result = jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn) => Comment.fromMap(dyn)).toList();
    } else {
      throw Exception("Bad request");
    }
  }
  Future<List<dynamic>> findByMessageid(int messageid) async {
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response = await http
        .get(Uri.parse(BareUrl.url + "comment/findByMessageid/${messageid}"));
    if (response.statusCode == 200) {
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result = jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn) => Chat.fromMap(dyn)).toList();
    } else {
      throw Exception("Bad request");
    }
  }
}
