import 'dart:convert';

import 'package:appmangxahoi/apis/save_api.dart';
import 'package:appmangxahoi/entities/save.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavPageScreen extends StatefulWidget {
  const FavPageScreen({Key? key}) : super(key: key);

  @override
  _FavPageScreenState createState() => _FavPageScreenState();
}

class _FavPageScreenState extends State<FavPageScreen> {
  List<bool> _isInfoVisible = [];

  void _toggleInfo(int index) {
    setState(() {
      _isInfoVisible[index] = !_isInfoVisible[index];
    });
  }

  void _navigateToDetail(int index) {
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(index: index),
      ),
    );*/
  }

  Users? user;
  var saveAPI = SaveAPI();
  Future<List<dynamic>>? saves;
  @override
  void initState() {
    super.initState(); // Ensure state is properly initialized
    loadData();
    setState(() {});
  }

  void loadData() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      setState(() {
        var k = shared.getString("user");
        user = Users.fromMap(jsonDecode(k!));
        saves=saveAPI.findByUserid(user?.id ?? 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yêu thích',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: saves,
              // Safely accessing user ID

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Bạn chưa yêu thích bài viết nào'));
                } else {
                  // Initialize _isInfoVisible based on the fetched data length
                  if (_isInfoVisible.length != snapshot.data!.length) {
                    _isInfoVisible =
                        List.generate(snapshot.data!.length, (_) => false);
                  }
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: List.generate(snapshot.data!.length, (index) {
                      var item = snapshot.data![index];
                      return GestureDetector(
                        onTap: () => _navigateToDetail(index),
                        onLongPress: () => _toggleInfo(index),
                        child: Container(
                          width: (size.width + 300) / 2, // Adjusted width
                          height: (size.width) / 2, // Kept height the same
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset: Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(item.contentPhoto),
                              // Accessing user photo properly
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                bottom: _isInfoVisible[index] ? 0 : -100,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(item.userPhoto),
                                        // Placeholder image
                                        radius: 20,
                                      ),
                                      Text(
                                        item.fullname,
                                        // Replace with dynamic data if available
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => {
                                          print("1"),
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    Text('Xóa bài viết yêu thích'),
                                                content: Text(
                                                    'Bạn có chắc chắn muốn xóa bài viết yêu thích này không?'),
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
                                                    onPressed: () {
                                                      if (saveAPI.delete(item.id) != null)
                                                      {print("Thành công");
                                                      setState(() {
                                                        saves=saveAPI.findByUserid(user?.id ?? 0);
                                                      });
                                                      Navigator.pop(context);
                                                      }
                                                      else
                                                      {print("Thất bại");
                                                      setState(() {
                                                        saves=saveAPI.findByUserid(user?.id ?? 0);
                                                      });
                                                      }
                                                      setState(() {
                                                        saves=saveAPI.findByUserid(user?.id ?? 0);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        },
                                        child: Icon(
                                          Icons.bookmark_add_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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

Widget _postButtons(dynamic content1) {
  return Padding(
    padding: const EdgeInsets.only(left: 40.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: _ToggleButton(
            isActive: false,
            count: 2,
            iconData: Icons.bookmark_add_outlined,
            activeIconData: Icons.bookmark_added,
            onToggle: (isActive, count) {},
          ),
        ),
      ],
    ),
  );
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
/*
class DetailPage extends StatelessWidget {
  final int index;

  DetailPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page $index'),
      ),
      body: Center(
        child: Text('Detail information for item $index'),
      ),
    );
  }
}*/
