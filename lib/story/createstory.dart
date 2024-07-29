import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:appmangxahoi/apis/story_api.dart';
import 'package:appmangxahoi/entities/story.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/nav/nav.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Createstory extends StatefulWidget {
  const Createstory({super.key});

  @override
  State<Createstory> createState() => _CreatestoryState();
}

String? path;

class _CreatestoryState extends State<Createstory> {
  TextEditingController content1 = TextEditingController(text: "");
  String? selectedMusic;
  AudioPlayer audioPlayer = AudioPlayer();
  Users? user;
  var storyAPI= StoryAPI();

  @override
  void initState() {
    super.initState();
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

  final List<Map<String, String>> musicList = [
    {"name": "Không chọn", "path": " "},
    {"name": "Chúng ta rồi sẽ hạnh phúc", "path": "music/ChungTaRoiSeHanhPhuc-JackJ97-12903446.mp3"},
    {"name": "Đừng Làm Trái Tim Anh Đau", "path": "music/DungLamTraiTimAnhDau.wav"},
    {"name": "Em Ổn Không", "path": "music/EmOnKhong.wav"},
    {"name": "Tháng Tư Là Lời Nói Dối Của Em", "path": "music/TTLLNDCE.wav"},
    {"name": "Xin Đừng Lặng Im", "path": "music/XinDungLangIm.wav"},
  ]; // Danh sách các bản nhạc với tên và đường dẫn

  void selectAFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      PlatformFile platformFile = filePickerResult.files[0];
      setState(() {
        path = platformFile.path;
      });
    }
  }

  void playMusic(String url) async {
    await audioPlayer.stop(); // Dừng nhạc đang phát (nếu có)
    await audioPlayer.play(AssetSource(url)); // Phát nhạc mới
    Timer(Duration(seconds: 20), () async {
      await audioPlayer.stop(); // Dừng nhạc sau 20 giây
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Giải phóng tài nguyên của audioPlayer khi không cần thiết nữa
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
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
                    DropdownButtonFormField<String>(
                      value: selectedMusic,
                      hint: Text("Chọn nhạc"),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMusic = newValue;
                          if (newValue != null) {
                            String? selectedPath = musicList.firstWhere((element) => element["name"] == newValue)?["path"];
                            if (selectedPath != null) {
                              playMusic(selectedPath);
                            }
                          }
                        });
                      },
                      items: musicList.map<DropdownMenuItem<String>>((Map<String, String> value) {
                        return DropdownMenuItem<String>(
                          value: value["name"],
                          child: Text(value["name"]!),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
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
                          onPressed: () async{
                            String? selectedPath = musicList.firstWhere((element) => element["name"] == selectedMusic)?["path"];
                            print("Link nhac: ${selectedPath}");
                            var content = Story(
                              userId: user!.id!,
                              content: selectedPath,
                            );
                            var strProduct = jsonEncode(content.toMap());
                            print("Content: ${strProduct}");
                            var success = await storyAPI.create1(File(path!),strProduct);
                            if(success != null){
                              print("Thành công");
                              audioPlayer.stop();
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
                            'Thêm story',
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