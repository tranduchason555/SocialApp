import 'dart:async';
import 'dart:convert';
import 'package:appmangxahoi/screens/message/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import 'package:appmangxahoi/postingdetails/product_item_screen.dart';
import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/apis/contentfriendship_api.dart';
import 'package:appmangxahoi/apis/friend_api.dart';
import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/entities/friend.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/profile/widgets/profile_background.dart';
import 'package:appmangxahoi/profile/widgets/stat.dart';
import 'package:flutter_svg/svg.dart';
import 'package:appmangxahoi/models/colors.dart';

class ProfileAddFriendScreen extends StatefulWidget {
  final String? email;
  final int? userId;

  ProfileAddFriendScreen({this.email, this.userId});

  @override
  State<ProfileAddFriendScreen> createState() => _ProfileAddFriendScreenState();
}

class _ProfileAddFriendScreenState extends State<ProfileAddFriendScreen> {
  final userAPI = UsersAPI();
  final contentAPI = ContentfriendshipAPI();
  final friendAPI = FriendAPI();
  Future<dynamic>? contentProfile;
  Users? user;
  Friend? friendship;
  Users? userProfile;
  bool _isFriend = false;
  bool _isRequestSent = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      setState(() {
        var k = shared.getString("user");
        user = Users.fromMap(jsonDecode(k!));
        contentProfile=contentAPI.findByUserid1(widget.userId!);
      });
    }
    loadUserProfile();
  }

  void loadUserProfile() async {
    try {
      var profile = await userAPI.findByEmail1(widget.email!, user!.id!);
      setState(() {
        userProfile = profile;
        _isFriend = userProfile!.status ?? false;
        _isRequestSent = userProfile!.status == null ? true : false;
      });
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }
//bool isLikedByUser = snapshot.data!.any((like) => like.userid == user!.id);
  void _toggleFriendStatus() async {
    try {
      if (_isFriend) {
        // Remove the friend

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
                    bool success = await friendAPI.removeAddfriend(userProfile!.friendshipId);
                    print("id:${userProfile!.friendshipId}");
                    if (success) {
                      setState(() {
                        loadData();
                        _isFriend = false;
                        _isRequestSent = false;
                        contentProfile=contentAPI.findByUserid1(widget.userId!);

                      });
                      Navigator.of(context)
                          .pop();
                      print("Friendship removed successfully");
                    } else {
                      setState(() {
                        loadData();
                        _isRequestSent = true;
                        contentProfile=contentAPI.findByUserid1(widget.userId!);
                      });
                      print("3");
                      print("Failed to remove friendship");
                      Navigator.of(context)
                          .pop();
                    }
                  },
                ),
              ],
            );
          }
        );
      } else if (_isRequestSent) {
        // Cancel the friend request
        setState(() {
          loadData();
          _isRequestSent = false;
          contentProfile=contentAPI.findByUserid1(widget.userId!);
        });
        // Send a new friend request
        var friend = Friend(
          userid1: user!.id,
          userid2: userProfile!.id!,
          status: false, // Status false for pending request
        );
        bool success = await friendAPI.create(friend);
        if (success) {
          setState(() {
            loadData();
            _isRequestSent = true;
            contentProfile=contentAPI.findByUserid1(widget.userId!);
          });
          print("Friend request sent successfully");
        } else {
          setState(() {
            loadData();
            _isRequestSent = true;
            contentProfile=contentAPI.findByUserid1(widget.userId!);
          });
          print("Failed to send friend request");
        }
      } else {
// Remove the friend
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title:
                Text('Xóa lời mời kết bạn'),
                content: Text(
                    'Bạn có chắc chắn muốn xóa lời mời kết bạn không?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Hủy bỏ'),
                    onPressed: () {
                      loadData();
                      Navigator.of(context)
                          .pop(); // Đóng dialog
                    },
                  ),
                  TextButton(
                    child: Text('Chấp nhận'),
                    onPressed: () async{
                      bool success = await friendAPI.removeAddfriend(userProfile!.friendshipId);
                      print("id:${userProfile!.friendshipId}");
                      if (success) {
                        setState(() {
                          loadData();
                          _isFriend = false;
                          _isRequestSent = false;
                          contentProfile=contentAPI.findByUserid1(widget.userId!);
                        });
                        print("Friendship removed successfully");
                      } else {
                        setState(() {
                          loadData();
                          _isRequestSent = true;
                          contentProfile=contentAPI.findByUserid1(widget.userId!);
                        });
                        print("3");
                        print("Failed to remove friendship");
                      }
                      Navigator.of(context)
                          .pop();
                    },
                  ),
                ],
              );
            }
        );
      }
    } catch (e) {
      print("Error toggling friend status: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ProfileBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildProfileImage(),
              _buildProfileName(context),
              const SizedBox(height: 35.0),
              _buildActionButtons(),
              const SizedBox(height: 40.0),
              _buildProfileStats(),
              const SizedBox(height: 50.0),
              _buildContentGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 140.0,
            height: 140.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: kBlack),
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
        ),
        ClipPath(
          clipper: ProfileImageClipper(),
          child: Image.network(
            userProfile!.photo!,
            width: 180.0,
            height: 180.0,
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }

  Widget _buildProfileName(BuildContext context) {
    return Text(
      userProfile!.fullname!,
      style: Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(fontWeight: FontWeight.w700),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _toggleFriendStatus,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isFriend
                ? Colors.green
                : _isRequestSent || userProfile!.status == false
                ? Colors.grey
                : Color.fromARGB(255, 211, 232, 235),
            minimumSize: Size(150, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isFriend
                    ? Icons.person
                    : _isRequestSent || userProfile!.status == false
                    ? Icons.pending
                    : Icons.person_add,
                color: _isFriend || _isRequestSent || userProfile!.status == false
                    ? Colors.white
                    : Colors.black,
              ),
              SizedBox(width: 8),
              Text(
                _isFriend
                    ? 'Bạn bè'
                    : _isRequestSent
                    ? 'Thêm bạn bè'
                    : 'Đã gửi lời mời',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isFriend || _isRequestSent || userProfile!.status == false
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MessageScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 211, 232, 235),
            minimumSize: Size(150, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: k1Gray, width: 0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message_rounded, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Tin nhắn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stat(title: 'Bài viết', value: userProfile!.countContent!),
          Stat(title: 'Theo dõi', value: userProfile!.countFriend!),
          Stat(title: 'Lượt thích', value: userProfile!.countLike! ?? 0),
        ],
      ),
    );
  }

  Widget _buildContentGrid() {
    return FutureBuilder(
      future: contentProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Có vẻ như người này chưa đăng gì'));
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
    );
  }
}

class ProfileImageClipper extends CustomClipper<Path> {
  double radius = 35;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width / 2 - radius, radius)
      ..quadraticBezierTo(size.width / 2, 0, size.width / 2 + radius, radius)
      ..lineTo(size.width - radius, size.height / 2 - radius)
      ..quadraticBezierTo(
          size.width, size.height / 2, size.width - radius, size.height / 2 + radius)
      ..lineTo(size.width / 2 + radius, size.height - radius)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width / 2 - radius, size.height - radius)
      ..lineTo(radius, size.height / 2 + radius)
      ..quadraticBezierTo(0, size.height / 2, radius, size.height / 2 - radius)
      ..lineTo(size.width / 2 - radius, radius);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
