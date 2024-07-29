import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:http/http.dart' as http;
class UsersAPI{
  Future<bool>login(Users users) async{
    var response= await http.post(Uri.parse(BareUrl.url+"users/login"),
      body: json.encode(users.toMap()),
      headers: {
        "Content-Type":"application/json",
      },
    );
    print(response.body);
    if(response.statusCode == 200){
      dynamic dyn= jsonDecode(response.body);
      return dyn["status"];
    }else{
      return false;

    }
  }
  Future<List<dynamic>> findAll(int userid) async {
    try {
      // NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
      var response = await http.get(Uri.parse(BareUrl.url + "users/findAll/${userid}"));

      if (response.statusCode == 200) {
        // BIẾN JSON THÀNH KIỂU DANH SÁCH
        List<dynamic> result = jsonDecode(response.body);

        // In ra kết quả để kiểm tra
        print("API response: $result");

        // TRẢ VỀ KẾT QUẢ
        List<Users> users = result.map((dyn) => Users.fromMap(dyn)).toList();

        // In ra danh sách người dùng để kiểm tra
        print("Parsed users: $users");

        return users;
      } else {
        throw Exception("Bad request: ${response.statusCode}");
      }
    } catch (e) {
      // In ra lỗi để kiểm tra
      print("Error in findAll: $e");
      throw e;
    }
  }

  Future<bool>create(Users users) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.post(Uri.parse(BareUrl.url+"users/create"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(users.toMap()),
      headers: {
        //DỮ LIỆU TRUYỀN LÊN KIỂU JSON
        "Content-Type":"application/json",
      },
    );
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      dynamic dyn= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ CHỈ CÓ 1 NÊN TRẢ TRỰC TIOE61 ĐỐI TƯỢNG
      return dyn["status"];
    }else{
      throw Exception("Bad request");
    }
  }
  Future<Users>findByEmail(String email) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"users/findByEmail/${email}"));
    if(response.statusCode ==200){
//ÉP NGƯỢC LẠI THÀNH ACCOUNT
      dynamic result= jsonDecode(response.body);
      return Users.fromMap(result);
    }else{
      throw Exception("Bad request");
    }
  }
  Future<Users>findByEmail1(String email,int userid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"users/findByEmail1/${email}/${userid}"));
    if(response.statusCode ==200){
//ÉP NGƯỢC LẠI THÀNH ACCOUNT
      dynamic result= jsonDecode(response.body);
      return Users.fromMap(result);
    }else{
      throw Exception("Bad request");
    }
  }
  Future<List<Users>>findByFullName(String fullname) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"users/findByFullname/${fullname}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Users.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<dynamic>update(Users user) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.put(Uri.parse(BareUrl.url+"users/update"),
      //BIẾN CATEGORY THÀNH JSON ĐẨY LÊN
      body: json.encode(user.toMap()),
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
  Future<dynamic> update2(File file, String strProduct) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${BareUrl.url}users/update2"),
    );

    // Add the string product data to the request
    request.fields["strProduct"] = strProduct;

    // Add the file to the request
    request.files.add(http.MultipartFile.fromBytes(
      "file",
      await file.readAsBytes(),
      filename: path.basename(file.path),
    ));

    try {
      // Log the request details
      print("Sending request to ${BareUrl.url}users/update2");
      print("Fields: ${request.fields}");
      print("Files: ${request.files.map((file) => file.filename)}");

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result["status"];
      } else {
        print("Failed to upload data: ${response.statusCode}");
        return Future.value(null);
      }
    } catch (e) {
      print("Error: $e");
      return Future.value(null);
    }
  }
}