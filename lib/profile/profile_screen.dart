import 'dart:convert';
import 'dart:io';
import 'package:appmangxahoi/apis/contentfriendship_api.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/login/changepassword.dart';
import 'package:appmangxahoi/nav/nav.dart';
import 'package:appmangxahoi/postingdetails/product_item_screen.dart';
import 'package:appmangxahoi/profile/profileaddfriend.dart';
import 'package:appmangxahoi/profile/widgets/profile_background.dart';
import 'package:appmangxahoi/profile/widgets/stat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  String _selectedTab = 'photos';
  String? path;
  Users? user;
  _changeTab(String tab) {
    setState(() => _selectedTab = tab);
  }
  Future<List<dynamic>>? content;
  var contentAPI=ContentfriendshipAPI();
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
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.85 : 1.00)
        ..rotateZ(isDrawerOpen ? -math.pi / 20 : 0),
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: isDrawerOpen ? BorderRadius.circular(40) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ProfileBackground(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    isDrawerOpen
                        ? GestureDetector(
                      child: Icon(Icons.arrow_back_ios),
                      onTap: () {
                        setState(() {
                          xOffset = 0;
                          yOffset = 0;
                          isDrawerOpen = false;
                        });
                      },
                    )
                        : GestureDetector(
                      child: Icon(Icons.menu),
                      onTap: () {
                        setState(() {
                          xOffset = 290;
                          yOffset = 80;
                          isDrawerOpen = true;
                        });
                      },
                    ),
                    Container(),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: math.pi / 4,
                              child: Container(
                                width: 140.0,
                                height: 140.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.0, color: Colors.black),
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: ProfileImageClipper(),
                              child: PopupMenuButton<String>(
                                onSelected: (String result) async {
                                  if (result == 'Đổi ảnh đại diện') {
                                    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
                                    if (filePickerResult != null) {
                                      PlatformFile platformFile = filePickerResult.files[0];
                                      setState(() {
                                        path = platformFile.path;
                                      });

                                      if (path != null) {
                                        var users = Users(
                                          id: user!.id!,
                                          fullname: user!.fullname!,
                                          roleId: 2,
                                          address: user!.address!,
                                          email: user!.email!,
                                          age: user!.age!,
                                          phone: user!.phone!,
                                          password: user!.password,
                                        );
                                        var strProduct = jsonEncode(users.toMap());

                                        print("Updating user with data: $strProduct");


                                        // Ensure the file is not null
                                        if (path != null) {
                                          var success = await userAPI.update2(File(path!), strProduct);
                                          if (success != null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Update successful")),
                                            );
                                            // Update UI or fetch new user data
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const Nav(),
                                              ),
                                            );
                                          } else {
                                            print("Update failed");
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Update failed. Please try again.')),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('No file selected.')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Invalid file path.')),
                                        );
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Đổi ảnh đại diện',
                                    child: Text('Đổi ảnh đại diện'),
                                  ),
                                ],
                                child: Image.network(
                                  user!.photo!,
                                  width: 180.0,
                                  height: 180.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )

                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                   user!.fullname!,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4.0),
                  const SizedBox(height: 4.0),
                  Text(
                    user!.email!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 80.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Stat(title: 'Bài viết', value: user!.countContent!??0),
                        Stat(title: 'Theo dõi', value: user!.countFriend!??0),
                        Stat(title: 'Lượt thích', value: user!.countLike!??0),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50.0),
                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => _changeTab('photos'),
                        child: SvgPicture.asset(
                          'assets/icons/Button-photos.svg',
                          color: _selectedTab == 'photos' ? k2AccentStroke : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _changeTab('saved'),
                        child: SvgPicture.asset(
                          'assets/icons/Button-saved.svg',
                          color: _selectedTab == 'saved' ? k2AccentStroke : null,
                        ),
                      ),
                    ],
                  ),*/
                  FutureBuilder<List<dynamic>>(
                    future: contentAPI.findByUserid1(user!.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Bạn chưa có bài đăng nào cả'));
                      } else {
                        List<dynamic> data = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14.0,
                            crossAxisSpacing: 14.0,
                            children: data.map((item) {
                              return StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 1.5,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(19.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("du lieu ${data.first}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductItemScreen(content: item),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      item.contentPhoto!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                    },
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

