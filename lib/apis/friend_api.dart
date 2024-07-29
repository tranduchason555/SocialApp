import 'dart:convert';
import 'package:appmangxahoi/entities/friend.dart';
import 'package:appmangxahoi/entities/save.dart';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:http/http.dart' as http;
class FriendAPI {
  Future<bool> create(Friend friend) async {
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response = await http.post(
      Uri.parse(BareUrl.url + "friendships/create"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(friend.toMap()),
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
  Future<bool>update(Friend friend) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.put(Uri.parse(BareUrl.url+"friendships/update"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(friend.toMap()),
      headers: {
        //DỮ LIỆU TRUYỀN LÊN KIỂU JSON
        "Content-Type":"application/json",
      },
    );
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      dynamic dyn= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ CHỈ CÓ 1 NÊN TRẢ TRỰC TIOE61 ĐỐI TƯỢNG
      return dyn["result"];
    }else{
      throw Exception("Bad request");
    }
  }
  Future<List<dynamic>>findByFriendship(int userId) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"friendships/findByFriendship/${userId}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Friend.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<List<dynamic>>findFriendshipByFullname(int userId, String fullname) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"friendships/findByFullnameship/${fullname}/${userId}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁC
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Friend.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<bool> removeAddfriend(dynamic id) async {
    try {
      var response = await http.delete(Uri.parse(BareUrl.url + "friendships/delete/${id}"));
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
}