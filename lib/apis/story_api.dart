import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:appmangxahoi/entities/story.dart';
import 'package:appmangxahoi/story/createstory.dart';
import 'package:flutter/material.dart';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
class StoryAPI {
  Future<List<dynamic>> findByUserid(int userid) async {
    try {
      var response = await http.get(
          Uri.parse(BareUrl.url + "storyfriendship/findByUserid/${userid}"));
      if (response.statusCode == 200) {
        // Parse the JSON into a list of dynamic objects
        List<dynamic> result = jsonDecode(response.body);
        // Convert each dynamic object into a Story object
        return result.map((dyn) => Story.fromMap(dyn)).toList();
      } else {
        throw Exception(
            "Failed to load stories: ${response.statusCode} ${response
                .reasonPhrase}");
      }
    } catch (error) {
      print('Error fetching stories: $error');
      throw Exception("Error fetching stories: $error");
    }
  }
  Future<List<dynamic>> findByUserid1(int userid) async {
    try {
      var response = await http.get(
          Uri.parse(BareUrl.url + "storyfriendship/findByUserid1/${userid}"));
      if (response.statusCode == 200) {
        // Parse the JSON into a list of dynamic objects
        List<dynamic> result = jsonDecode(response.body);
        // Convert each dynamic object into a Story object
        return result.map((dyn) => Story.fromMap(dyn)).toList();
      } else {
        throw Exception(
            "Failed to load stories: ${response.statusCode} ${response
                .reasonPhrase}");
      }
    } catch (error) {
      print('Error fetching stories: $error');
      throw Exception("Error fetching stories: $error");
    }
  }
  Future<dynamic> create1(File file, String strProduct) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${BareUrl.url}storyfriendship/create2"),
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
      print("Sending request to ${BareUrl.url}storyfriendship/create2");
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