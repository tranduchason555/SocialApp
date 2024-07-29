import 'dart:convert';
import 'package:appmangxahoi/apis/comment_api.dart';
import 'package:appmangxahoi/apis/contentfriendship_api.dart';
import 'package:appmangxahoi/apis/friend_api.dart';
import 'package:appmangxahoi/apis/like_api.dart';
import 'package:appmangxahoi/apis/notification_api.dart';
import 'package:appmangxahoi/apis/save_api.dart';
import 'package:appmangxahoi/apis/story_api.dart';
import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/entities/friend.dart';
import 'package:appmangxahoi/entities/friendship.dart';
import 'package:appmangxahoi/entities/like.dart';
import 'package:appmangxahoi/entities/save.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/login/widgets/background.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/nav/nav.dart';
import 'package:appmangxahoi/notification/notification.dart';
import 'package:appmangxahoi/postingdetails/product_item_screen.dart';
import 'package:appmangxahoi/profile/profile_screen.dart';
import 'package:appmangxahoi/profile/profileaddfriend.dart';
import 'package:appmangxahoi/report/report.dart';
import 'package:appmangxahoi/screens/home/widgets/commentbutton.dart';
import 'package:appmangxahoi/story/createstory.dart';
import 'package:appmangxahoi/story/mystory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLiked = false;
  int _count = 0;
  var keyword = TextEditingController(text: "");
  Users? user;
  Future<List<Users>>? users;
  var friendshipAPI = ContentfriendshipAPI();
  var usersAPI = UsersAPI();
  var storyAPI = StoryAPI();
  var notificationAPI = NotificationAPI();
  Future<List<dynamic>>? content;
  Future<List<dynamic>>? story;
  Future<List<dynamic>>? notification;
  List<dynamic> seenStatuses = [];
  bool isSeen = true;
  var friendshiAPI= FriendAPI();
  var likeAPI = LikeAPI();
  var saveAPI = SaveAPI();
  var contentAPI=ContentfriendshipAPI();

  @override
  void initState() {
    loadData();
    keyword.addListener(() {
      print(keyword.text);
    });
  }

  void markAsSeen(int id) {
    setState(() {
      if (!seenStatuses.contains(id)) {
        seenStatuses.add(id);

        // Call setState or notifyListeners if using a state management solution
      }
    });
  }

  void loadData() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      setState(() {
        var k = shared.getString("user");
        user = Users.fromMap(jsonDecode(k!));
        story = storyAPI.findByUserid(user!.id!);
        //Lưu ý
        content = friendshipAPI.findByUserid(user!.id!);
        notification = notificationAPI.NotificationFriendshipId(user!.id!);
        print(story);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final int notificationCount = 1;

    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'SnapBook',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FutureBuilder(
                future: notification,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var data = snapshot.data;

                    int badgeCount = data != null
                        ? data.length
                        : 0; // Assign 0 if data is null or empty

                    return Stack(
                      clipBehavior: Clip.none,
                      // Allow the badge to overflow the Stack
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()),
                            );
                          },
                          icon: SvgPicture.asset('assets/icons/notif.svg'),
                        ),
                        Positioned(
                          right: 8,
                          // Move the badge closer to the icon
                          top: 1,
                          // Adjust the vertical position to make it closer
                          child: Container(
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: kSelectedTabColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Center(
                              // Ensure the text is centered
                              child: Text(
                                badgeCount.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 25.0,
                      color: Colors.black.withOpacity(0.10),
                    )
                  ],
                ),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: keyword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          width: 0.0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Image.asset('assets/images/search.png'),
                      hintText: 'Tìm kiếm ',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    // Replace this with your data fetching logic
                    if (pattern.isEmpty) {
                      return []; // Return an empty list if no input
                    }
                    try {
                      return await usersAPI.findByFullName(pattern);
                    } catch (e) {
                      // Handle the error gracefully
                      print('Error fetching suggestions: $e');
                      return [];
                    }
                  },
                  itemBuilder: (context, suggestion) {
                    // Replace this with your custom suggestion item widget
                    return ListTile(
                      leading: suggestion.photo != null &&
                          suggestion.photo!.isNotEmpty
                          ? CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          suggestion.photo ??
                              'default_photo_url', // Add a default URL or handle null
                        ),
                      )
                          : Icon(Icons.account_circle, size: 50),
                      // Placeholder icon
                      title: Text(suggestion.fullname),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    // Handle the suggestion selection
                    /* keyword.text = suggestion!.fullname!;*/
                    keyword.text = "";
                    if (user!.id == suggestion!.id!) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileAddFriendScreen(
                            email: suggestion!.email!,
                            userId: suggestion!.id!,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 30.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Createstory(),
                            ),
                          );
                        },
                        child: Transform.translate(
                          offset: Offset(0, -15),
                          // Di chuyển lên trên 10 pixels (giá trị âm di chuyển lên)
                          child: Container(
                            height: 56.0,
                            width: 56.0,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 24.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: k3GradientAccent,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 12.0,
                                  offset: const Offset(0, 4),
                                  color: k3Pink.withOpacity(0.52),
                                ),
                              ],
                            ),
                            child:
                            SvgPicture.asset('assets/icons/only_plus.svg'),
                          ),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    FutureBuilder(
                      future: story,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          print('No data available');
                          return Center(child: Text(' '));
                        } else {
                          var data = snapshot.data!;
                          Map<int, dynamic> uniqueStories = {};
                          for (var item in data) {
                            if (!uniqueStories.containsKey(item.userId)) {
                              uniqueStories[item.userId] = item;
                            }
                          }
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                              uniqueStories.values.map<Widget>((item) {
                                bool isSeen = seenStatuses.contains(item.id);
                                Color borderColor = item.status == false
                                    ? Colors.grey
                                    : (isSeen ? Colors.grey : Colors.blue);
                                return GestureDetector(
                                  onTap: () {
                                    markAsSeen(item.id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyStoryPage(userId: item.userId),
                                      ),
                                    );
                                    setState(() {
                                      loadData();
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 56.0,
                                        width: 56.0,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: borderColor,
                                            width: 4,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 28.0,
                                          backgroundImage:
                                          NetworkImage(item.photoUser),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        item.fullname,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: content,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return FutureBuilder<List<dynamic>>(
                        future: usersAPI.findAll(user!.id!), // Sử dụng biến users đã được khởi tạo
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
                          } else{
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(8.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var item = snapshot.data![index];
                                print(item.fullname);
                                return
                                  Card(
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
                                            backgroundImage: NetworkImage(item.photo!),
                                          ),
                                          SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.fullname ?? 'Chưa có tên',
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

                                                          var friend = Friend(
                                                            userid1: user!.id,
                                                            userid2: item!.id!,
                                                            status: false,
                                                          );
                                                          friendshiAPI.create(friend).then((success) {
                                                            if (success) {
                                                              print("Friend request sent successfully");
                                                              setState(() {
                                                                loadData();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                loadData();
                                                              });
                                                              print("Failed to send friend request");
                                                            }
                                                          });
                                                        },
                                                        child: Text('Kết bạn'),
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: Colors.white,
                                                          backgroundColor: Color(0xFF25A0B0),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => ProfileAddFriendScreen(userId: item.id!, email: item!.email!,),
                                                            ),
                                                          );
                                                        },
                                                        child: Text('Xem thông tin'),
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
                                return null;
                              },
                            );



                          }
                        }
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        var item = snapshot.data![index];
                        bool isSeen = seenStatuses.contains(item.storyId);
                        Color borderColor = item.status == false
                            ? Colors.grey
                            : (isSeen ? Colors.grey : Colors.blue);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductItemScreen(content: item),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                      onTap: () {
                                        markAsSeen(item.storyId);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyStoryPage(
                                                userId: item.userId),
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        height: 56.0,
                                        width: 56.0,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: borderColor,
                                            width: 4,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 25.0,
                                          backgroundImage:
                                          NetworkImage(item.photo),
                                        ),
                                      ),
                                      title: Text(
                                        item.fullname ?? 'No Name',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        item.date != null
                                            ? DateFormat('dd/MM/yyyy')
                                            .format(item.date)
                                            : 'No Date',
                                      ),
                                      trailing: PopupMenuButton<String>(
                                        onSelected: (String value) async{
                                          if (value == 'Báo cáo' && item != null) { // Check for null
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ReportScreen(
                                                  content: item,

                                                ),
                                              ),
                                            );
                                          }
                                          if (value == 'Xóa bài viết' && item != null) {
                                            try {
                                              print(item.id);
                                              bool success = await contentAPI.delete(item.id);
                                              if (success) {
                                                setState(() {
                                                  loadData();
                                                });
                                                print("Thành công");
                                                /*Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Nav(),
                                                  ),
                                                );*/
                                              } else {
                                                /*Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Nav(),
                                                  ),
                                                );*/
                                                setState(() {
                                                  loadData();
                                                });
                                              }
                                            } catch (e) {
                                              print("Có lỗi xảy ra: $e");
                                            }
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'Báo cáo',
                                            child: Text('Báo cáo'),
                                          ),
                                          if(user!.id== item.userId)...[
                                            const PopupMenuItem<String>(
                                              value: 'Xóa bài viết',
                                              child: Text('Xóa bài viết'),
                                            ),
                                          ]
                                        ],
                                        child: const Icon(Icons.more_vert),
                                      )),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 8, 16, 0),
                                      child: Text(
                                        item.content1 ?? 'No Content',
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: _postImage(
                                        item.contentPhoto ??
                                            'default_photo_url',
                                        context),
                                  ),
                                  const SizedBox(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: _postButtons(item),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
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
      ),
    );
  }

  Widget _postButtons(Contentfriendship content1) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder<List<dynamic>>(
              future: likeAPI.findByContentId(content1.id!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  bool isLikedByUser =
                  snapshot.data!.any((like) => like.userid == user!.id);
                  return _ToggleButton(
                    isActive: isLikedByUser,
                    count: content1.countLike!,
                    iconData: Icons.favorite_outline,
                    activeIconData: Icons.favorite,
                    onPressed: () async {
                      if (isLikedByUser) {
                        try {
                          var success =
                          await likeAPI.delete(snapshot.data!.first!.id!);
                          if (success) {
                            setState(() {
                              content1.countLike =
                                  (content1.countLike ?? 0) - 1;
                              loadData();
                            });
                          } else {
                            print("Failed to unlike the post");

                            setState(() {
                              loadData();
                            });
                          }
                        } catch (e) {
                          print("Error unliking the post: $e");
                        }
                      } else {
                        var like = Like(
                          contentId: content1.id!,
                          userid: user!.id!,
                        );
                        try {
                          await likeAPI.create(like);
                          setState(() {
                            content1.countLike = (content1.countLike ?? 0) + 1;
                            loadData();
                          });
                        } catch (e) {
                          print("Error liking the post: $e");
                        }
                      }
                    },
                    onToggle: (isActive, count) {
                      setState(() {
                        content1.countLike = count;
                        loadData();
                      });
                    },
                  );
                } else {
                  return Center(
                    child: Text('No likes found'),
                  );
                }
              },
            ),
          ),
          Spacer(),
          Expanded(
            flex:2,
            child: _CommentButton(content: content1),
          ),
          Spacer(),
          Expanded(
              flex: 1,
              child: FutureBuilder<List<dynamic>>(
                future: saveAPI.findByContentId(content1.id!),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    bool isSaveByUser =
                    snapshot.data!.any((save) => save.userId == user!.id);
                    return _ToggleButton(
                      isActive: isSaveByUser,
                      count: content1.countSave!,
                      iconData: Icons.bookmark_add_outlined,
                      activeIconData: Icons.bookmark_added,
                      onPressed: () async {
                        if (isSaveByUser) {
                          try {
                            var success =
                            await saveAPI.delete(snapshot.data!.first!.id!);
                            if (success) {
                              setState(() {
                                content1.countSave =
                                    (content1.countSave ?? 0) - 1;
                                loadData();
                              });
                            } else {
                              print("Failed to unlike the post");

                            setState(() {
                              loadData();
                            });
                            }
                          } catch (e) {
                            print("Error unliking the post: $e");
                          }
                        } else {
                          var save = Save(
                            contentid: content1.id!,
                            userId: user!.id!,
                          );
                          try {
                            await saveAPI.create(save);
                            setState(() {
                              content1.countSave =
                                  (content1.countSave ?? 0) + 1;
                              loadData();
                            });
                          } catch (e) {
                            print("Error liking the post: $e");
                          }
                        }
                      },
                      onToggle: (isActive, count) {
                        setState(() {
                          content1.countSave = count;
                          loadData();
                        });
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No likes found'),
                    );
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _postImage(String images, BuildContext context) {
    return FutureBuilder<void>(
      future: precacheImage(NetworkImage(images), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const AspectRatio(
              aspectRatio: 16 / 9,
              child: ErrorImageWidget(),
            );
          } else {
            return Image.network(
              images,
              fit: BoxFit.fitWidth,
            );
          }
        } else {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: LoadingImageWidget(),
          );
        }
      },
    );
  }
}

class _ToggleButton extends StatefulWidget {
  final bool isActive;
  final int count;
  final IconData iconData;
  final IconData activeIconData;
  final Future<void> Function()? onPressed;
  final void Function(bool isActive, int count) onToggle; // Add this

  const _ToggleButton({
    Key? key,
    required this.isActive,
    required this.count,
    required this.iconData,
    required this.activeIconData,
    this.onPressed,
    required this.onToggle, // Add this
  }) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<_ToggleButton> {
  late bool _isActive;
  late int _count;

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
    _count = widget.count;
  }

  void _handleTap() async {
    if (widget.onPressed != null) {
      await widget.onPressed!();
    }
    setState(() {
      _isActive = !_isActive;
      if (_isActive) {
        _count++;
      } else {
        if (_count > 0) {
          _count--;
        }
      }
      widget.onToggle(_isActive, _count); // Call the callback function
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Row(
        children: [
          Icon(
            _isActive ? widget.activeIconData : widget.iconData,
            color: _isActive ? Colors.red : Colors.grey,
          ),
          const SizedBox(width: 8.0),
          Text(
            _count.toString(),
            style: TextStyle(
              color: _isActive ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentButton extends StatefulWidget {
  var content = Contentfriendship();

  _CommentButton({required this.content});

  @override
  State<_CommentButton> createState() => _CommentButtonState();
}

class LoadingImageWidget extends StatelessWidget {
  const LoadingImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.secondaryContainer,
      child: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.errorContainer,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: theme.colorScheme.onErrorContainer,
          size: 42,
        ),
      ),
    );
  }
}

class _CommentButtonState extends State<_CommentButton> {
  late int _commentCount;
  Future<List<dynamic>>? comments;
  var commentAPI = CommentAPI();

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    comments = commentAPI.findByContentid(widget.content.id!);
    // Update comment count if needed
    comments?.then((commentList) {
      setState(() {
        _commentCount = commentList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding:const EdgeInsets.only(right: 1, left: 16) ,
        child: Row(

          children: [
            FutureBuilder<List<dynamic>>(
              future: comments, // Assuming comments is Future<List<dynamic>>?
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Transform.scale(
                    scale: 1,
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        CommentsBottomSheet.showCommentsBottomSheet(
                          context,
                          widget.content,
                        ).then((_) {
                          // Fetch new comments and update state
                          fetchComments();
                        });
                      },
                    ),
                  );

                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Transform.scale(
                    scale: 1,
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        CommentsBottomSheet.showCommentsBottomSheet(
                          context,
                          widget.content,
                        ).then((_) {
                          // Fetch new comments and update state
                          fetchComments();
                        });
                      },
                    ),
                  );
                }
              },
            ),
            FutureBuilder<List<dynamic>>(
              future: comments, // Assuming comments is Future<List<dynamic>>?
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('${snapshot.data!.length}');
                }
              },
            ),
          ],
        ));

  }
}

