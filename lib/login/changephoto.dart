import 'dart:convert';
import 'dart:io';

import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/user.dart';

class ChangePhotoScreen extends StatefulWidget {
  const ChangePhotoScreen({super.key});

  @override
  State<ChangePhotoScreen> createState() => _ChangePhotoScreenState();
}
String? path;
final userAPI = UsersAPI();
class _ChangePhotoScreenState extends State<ChangePhotoScreen> {
   Users? user;
  void selectAFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      PlatformFile platformFile = filePickerResult.files[0];
      setState(() {
        path = platformFile.path;
      });
    }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset('assets/icons/button_back.svg'),
      ),
    ),
      body: Padding(
          padding: const EdgeInsets.all(10),
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
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 260, // Button width
                        height: 60, // Button height
                        decoration: BoxDecoration(
                          color: k2MainThemeColor, // Button background color
                          borderRadius: BorderRadius.circular(30), // Button border radius
                        ),
                        child: TextButton(
                          onPressed: () async{
                            Users updatePhoto = Users(
                            id: 2,
                            photo: path?.replaceFirst(BareUrl.imageurl,'')
                          );
                          userAPI.update(updatePhoto);
                          },
                          child: Text(
                            'Sửa ảnh',
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
    );
  }
}