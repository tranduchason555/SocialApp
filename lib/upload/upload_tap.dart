import 'dart:convert';
import 'dart:io';

import 'package:appmangxahoi/apis/contentfriendship_api.dart';
import 'package:appmangxahoi/entities/friendship.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/nav/nav.dart';
import 'package:appmangxahoi/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p; // Import the path package

class UploadTap extends StatefulWidget {
  @override
  _UploadTapState createState() => _UploadTapState();
}

class _UploadTapState extends State<UploadTap> {
  TextEditingController content1 = TextEditingController(text: "");
  String? path;
  var contentAPI = ContentfriendshipAPI();
  Users? user;

  @override
  void initState() {
    loadData();
  }

  void loadData() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      setState(() {
        var k = shared.getString("user");
        user = Users.fromMap(jsonDecode(k!));
      });
    }
  }

  void selectAFile() async {
    FilePickerResult? filePickerResult=await FilePicker.platform.pickFiles();
    if(filePickerResult!=null){
      PlatformFile platformFile=filePickerResult.files[0];
      setState(() {
        path=platformFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => selectAFile(),
                      child: DottedBorder(
                        dashPattern: [15, 5],
                        color: Colors.grey, // Change this to your desired outline color
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 300, // Adjusted height
                          child: path != null
                              ? Image.file(
                            File(path!), // Display selected image
                            fit: BoxFit.fill, // Fill the DottedBorder area with the image
                          )
                              : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.photo,
                                  size: 65,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Thêm hình ảnh",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Mời nhập nội dung",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: content1,
                      decoration: InputDecoration(
                        hintText: "Nhập nội dung bạn muốn",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 260, // Button width
                        height: 60, // Button height
                        decoration: BoxDecoration(
                          color: kSelectedTabColor, // Button background color
                          borderRadius: BorderRadius.circular(30), // Button border radius
                        ),
                        child: TextButton(
                          onPressed: () async {
                            var fileName = p.basename(path ?? '');
                            var content = Contentfriendship(
                                content1: content1.text,
                                userId: user!.id!,
                            );
                            var strProduct = jsonEncode(content.toMap());
                            print("Content: ${strProduct}");
                            var success = await contentAPI.create1(File(path!),strProduct);
                            if(success != null){
                              print("Thành công");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Nav(),
                                ),
                              );

                            }else{
                              print("Thất bại");
                            }

                          },
                          child: Text(
                            'Thêm bài viét',
                            style: TextStyle(
                              color: Colors.white, // Button text color
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}