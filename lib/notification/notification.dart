import 'dart:async';
import 'dart:convert';

import 'package:appmangxahoi/apis/friend_api.dart';
import 'package:appmangxahoi/apis/notification_api.dart';
import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/listfriend/listfriend.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/notification/widget/background.dart';
import 'package:appmangxahoi/screens/home/widgets/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/friend.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notificationAPI = NotificationAPI();
  Users? user;
  Future<void>? notificationsFuture;
  TextEditingController keywordController = TextEditingController();
  Timer? debounce;
  List<dynamic> allMessages = [];
  List<dynamic> filteredMessages = [];
  var usersAPI = UsersAPI();
  var friendAPI=FriendAPI();
  var notifications;
  @override
  void initState() {
    super.initState();
    notificationsFuture = loadData();
    keywordController.addListener(() {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        filterMessages();
      });
    });
  }

  Future<dynamic> loadData() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      var k = shared.getString("user");
      user = Users.fromMap(jsonDecode(k!));
       notifications = await notificationAPI.NotificationFriendshipId(user!.id!);
      setState(() {
        allMessages = notifications;
        filteredMessages = notifications;
      });
    }
  }

  @override
  void dispose() {
    keywordController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void filterMessages() {
    String keyword = keywordController.text.toLowerCase();
    setState(() {
      if (keyword.isEmpty) {
        filteredMessages = allMessages;
      } else {
        filteredMessages = allMessages.where((message) {
          var fullName = message.fullname.toLowerCase();
          return fullName.contains(keyword);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MessageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Text(
              'Thông báo',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30.0),
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
                  hintText: 'Tìm kiếm',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: k1LightGray),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            FutureBuilder<void>(
              future: notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (filteredMessages.isEmpty) {
                    return Center(child: Text('Bạn không có bất kỳ thông báo nào cả'));
                  }

                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var item = filteredMessages[index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  var response = await notificationAPI.delete(item.id);
                                  if (response != null) {
                                    print("Thất bại");
                                     await loadData();
                                     // Reload the data to update the list
                                    setState(() {loadData();});
                                  } else {
                                    print("Thành công");
                                    await loadData(); // Reload the data to update the list
                                    setState(() {loadData();});
                                  }
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red[700]!,
                              )
                            ],
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 45),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(item.userPhoto!),
                            ),
                            title: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.fullname,
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.contentId != null) ...[
                                  Text(
                                    "Bạn của bạn vừa đăng bài viết mới",
                                  ),
                                  if (item.dateContent != null && item.dateContent is DateTime)
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(item.dateContent as DateTime),
                                      style: TextStyle(fontSize: 12),
                                    )
                                  else
                                    Text(
                                      'No Date',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                ] else if (item.commentId != null) ...[
                                  Text(
                                    "Bạn của bạn vừa đăng bình luận mới",
                                  ),
                                  if (item.dateComment != null && item.dateComment is DateTime)
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(item.dateComment as DateTime),
                                      style: TextStyle(fontSize: 12),
                                    )
                                  else
                                    Text(
                                      'No Date',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                ] else if (item.storyId != null) ...[
                                  Text(
                                    "Bạn của bạn vừa đăng tin mới",
                                  ),
                                  if (item.dateStory != null && item.dateStory is DateTime)
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(item.dateStory as DateTime),
                                      style: TextStyle(fontSize: 12),
                                    )
                                  else
                                    Text(
                                      'No Date',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                ] else if (item.messageId != null) ...[
                                  Text(
                                    "Bạn của bạn vừa gửi tin nhắn",
                                  ),
                                  if (item.dateMessage != null && item.dateMessage is DateTime)
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(item.dateMessage as DateTime),
                                      style: TextStyle(fontSize: 12),
                                    )
                                  else
                                    Text(
                                      'No Date',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                ] else if (item.likeId != null) ...[
                                  Text(
                                    "Bạn của bạn vừa thích bài viết",
                                  ),
                                  if (item.dateLike != null && item.dateLike is DateTime)
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(item.dateLike as DateTime),
                                      style: TextStyle(fontSize: 12),
                                    )
                                  else
                                    Text(
                                      'No Date',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                ] else if (item.friendshipId != null) ...[
                                  StatefulBuilder(
                                    builder: (context, setState) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(item.statusFriendship != true)
                                          Text("đã gửi lời mời kết bạn cho bạn")
                                        else (Text('và bạn đã là bạn bè')),
                                        if (item.dateFriendship != null &&
                                            item.dateFriendship is DateTime)
                                          Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(item.dateFriendship as DateTime),
                                            style: TextStyle(fontSize: 12),
                                          )
                                        else
                                          Text(
                                            'No Date',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        if (item.statusFriendship == false)
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  var friend = Friend(
                                                    id: item.friendshipId,
                                                    userid1: user!.id,
                                                    userid2: item.userId,
                                                    status: true,
                                                  );
                                                  await friendshipAPI.update(friend);
                                                  print("Thành công");
                                                  
                                                  print('friendstatus  =  true');
                                                  setState(() {
                                                    item.statusFriendship = true;
                                                    loadData();
                                                    notificationsFuture = loadData();
                                                  });
                                                  await loadData(); // Reload the data to update the list
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xFF7DB9B3),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Chấp nhận",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () async{
                                                  print("1");
                                                  if(notificationAPI.delete(item.id) != null){
                                                    if (friendAPI.removeAddfriend(item.friendshipId) != null)
                                                    {print("Thành công");
                                                    await loadData(); // Reload the data to update the list
                                                    setState(() {
                                                      notificationsFuture = loadData();
                                                      loadData();
                                                    });
                                                    }
                                                    else
                                                    {print("Thất bại");}
                                                    setState(() {
                                                      notificationsFuture = loadData();
                                                      loadData();
                                                    });
                                                  }

                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                  side: BorderSide(color: Colors.grey),
                                                ),
                                                child: Text(
                                                  "Từ chối",
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[300],
                        indent: MediaQuery.of(context).size.width * 0.08,
                        endIndent: MediaQuery.of(context).size.width * 0.08,
                      ),
                      itemCount: filteredMessages.length,
                    ),
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
