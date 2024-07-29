import 'dart:async';
import 'dart:convert';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/apis/friend_api.dart';
import 'package:appmangxahoi/apis/message_api.dart';
import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/screens/message/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListfriendScreen extends StatefulWidget {
  const ListfriendScreen({super.key});

  @override
  State<ListfriendScreen> createState() => _ListfriendScreenState();
}

var usersAPI = UsersAPI();
final messageAPI = MessageAPI();
Users? user;
var friendshipAPI = FriendAPI();
var keywordController = TextEditingController(text: "");
Future<List<dynamic>>? friendsUserFriendship;
Timer? debounce;

class _ListfriendScreenState extends State<ListfriendScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
    keywordController.addListener(() {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        filterFriendList();
      });
    });
  }

  void loadData() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      setState(() {
        var k = shared.getString("user");
        user = Users.fromMap(jsonDecode(k!));
        friendsUserFriendship = friendshipAPI.findByFriendship(user!.id!);
      });
    }
  }

  void filterFriendList() async {
    String keyword = keywordController.text.toLowerCase();
    if (keyword.isEmpty) {
      setState(() {
        friendsUserFriendship = friendshipAPI.findByFriendship(user!.id!);
      });
    } else {
      try {
        Future<List<dynamic>> friendlist =
        friendshipAPI.findFriendshipByFullname(user!.id!, keyword);
        setState(() {
          friendsUserFriendship = friendlist;
        });
      } catch (e) {
        print('Error filtering messages: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách theo dõi'),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 25.0,
                    color: kBlack.withOpacity(0.10),
                  )
                ],
              ),
              child: TextField(
                controller: keywordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kWhite,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      width: 0.0,
                      style: BorderStyle.none,
                    ),
                  ),
                  prefixIcon: Image.asset('assets/images/search.png'),
                  hintText: 'Tìm Kiếm',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: k1LightGray),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            FutureBuilder<List<dynamic>>(
              future: friendsUserFriendship,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không tìm thấy bạn bè'));
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      dynamic friendUser = snapshot.data![index];
                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.grey.withOpacity(0.8),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage('${BareUrl.imageurl}/${friendUser.photo}'),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      friendUser.fullname ?? 'Chưa có tên',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MessageScreen(),
                                                ),
                                              );
                                            },
                                            child: Text('Nhắn tin'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                              Color(0xFF25A0B0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () async{
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                    Text('Xóa bạn bè'),
                                                    content: Text(
                                                        'Bạn có chắc chắn muốn xóa bạn bè không?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('Hủy bỏ'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Đóng dialog
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Chấp nhận'),
                                                        onPressed: () async{
                                                          bool success = await friendshipAPI.removeAddfriend(friendUser!.id);
                                                          print("id:${friendUser!.id}");
                                                          if (success) {
                                                            setState(() {
                                                              loadData();
                                                              friendsUserFriendship = friendshipAPI.findByFriendship(user!.id!);
                                                            });
                                                            Navigator.of(context)
                                                                .pop(); // Đóng dialog
                                                            print("Friendship removed successfully");
                                                          } else {
                                                            setState(() {
                                                              loadData();
                                                              friendsUserFriendship = friendshipAPI.findByFriendship(user!.id!);
                                                            });
                                                            Navigator.of(context)
                                                                .pop(); // Đóng dialog
                                                            print("Failed to remove friendship");
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );


                                            },
                                            child: Text('Bạn bè'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
