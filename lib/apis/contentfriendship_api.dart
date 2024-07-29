import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:appmangxahoi/entities/friendship.dart';
import 'package:appmangxahoi/apis/base_url.dart';
class ContentfriendshipAPI{
  Future<List<dynamic>>findByUserid(int userid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"contentfriendship/findByUserid/${userid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Contentfriendship.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<List<dynamic>>findByUserid1(int userid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"contentfriendship/findByUserId1/${userid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Contentfriendship.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<List<dynamic>>findByContentId(int contentid) async{
    //NỐI CHUỖI VÀ ĐỌC ĐƯỜNG DẪN TRONG API
    var response= await http.get(Uri.parse(BareUrl.url+"contentfriendship/findByContentId/${contentid}"));
    if(response.statusCode ==200){
      //BIẾN JOSN THÀNH KIỂU DANH SÁCH
      List<dynamic> result= jsonDecode(response.body);
      //TRẢ VỀ KẾT QUÁ
      return result.map((dyn)=>Contentfriendship.fromMap(dyn)).toList();
    }else{
      throw Exception("Bad request");
    }
  }
  Future<bool> create(var strProduct, File file) async {
    try {
      var uri = Uri.parse(BareUrl.url + "contentfriendship/create2");

      // Create a multipart request
      var request = http.MultipartRequest('POST', uri);

      // Add file to the request
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', '*'), // Adjust contentType as per your file type
      );
      request.files.add(multipartFile);

      // Add JSON content to the request
      request.fields['strProduct'] = jsonEncode(strProduct);

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        dynamic dyn = jsonDecode(responseString);
        if (dyn != null && dyn["status"] != null) {
          return dyn["status"];
        } else {
          print("Invalid response format: $responseString");
          return false;
        }
      } else {
        print("Server returned an error: ${response.statusCode}");
        var responseString = await response.stream.bytesToString();
        print("Response: $responseString");
        return false;
      }
    } catch (e) {
      print("Error during file upload: $e");
      return false;
    }
  }
  Future<dynamic> create1(File file, String strProduct) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${BareUrl.url}contentfriendship/create2"),
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
      print("Sending request to ${BareUrl.url}contentfriendship/create2");
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
  Future<bool> delete(int id) async {
    try {
      var response = await http.delete(Uri.parse(BareUrl.url + "contentfriendship/delete/${id}"));
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