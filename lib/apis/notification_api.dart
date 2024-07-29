import 'dart:convert';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/entities/notification.dart';
import 'package:http/http.dart' as http;
class NotificationAPI{
  Future<List<dynamic>>NotificationFriendshipId(int userid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"notification/notificationFriendshipId/${userid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Notification.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<bool> delete(dynamic id) async {
    try {
      var response = await http.delete(Uri.parse(BareUrl.url + "notification/delete/${id}"));
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