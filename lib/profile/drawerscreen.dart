import 'dart:convert';
import 'package:appmangxahoi/listfriend/listfriend.dart';
import 'package:appmangxahoi/login/changepassword.dart';
import 'package:appmangxahoi/login/editinfor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/user.dart';
import '../login/login.dart';
import '../models/colors.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Users? user;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSelectedTabColor,
      child: Padding(
        padding: EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(user?.photo ?? ''),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  user?.fullname ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                NewRow(
                  text: 'Chỉnh sửa thông tin',
                  icon: Icons.person,
                  onPressed: ()=>{
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => EditProfile(),
                  ),
                  ),
                  },
                ),
                SizedBox(height: 20),
                NewRow(
                  text: 'Đổi mật khẩu',
                  icon: Icons.password,
                  onPressed:  ()=>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassPage(),
                      ),
                    ),
                  },
                ),
                SizedBox(height: 20),
                NewRow(
                  text: 'Danh sách theo dõi',
                  icon: Icons.account_box,
                  onPressed: ()=>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListfriendScreen(),
                      ),
                    ),
                  },
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.cancel,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const NewRow({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      splashColor: Colors.white,
      highlightColor: Colors.transparent,
    );
  }
}