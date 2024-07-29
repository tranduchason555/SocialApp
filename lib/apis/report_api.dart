import 'dart:convert';
import 'package:appmangxahoi/entities/chat.dart';
import 'package:appmangxahoi/entities/comment.dart';
import 'package:appmangxahoi/entities/report.dart';
import 'package:flutter/material.dart';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:http/http.dart' as http;
class ReportAPI {
  Future<bool> create(Report report) async {
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response = await http.post(
      Uri.parse(BareUrl.url + "report/create"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(report.toMap()),
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
