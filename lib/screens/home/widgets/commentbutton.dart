
import 'dart:convert';

import 'package:appmangxahoi/apis/comment_api.dart';
import 'package:appmangxahoi/entities/friendship.dart';
import 'package:appmangxahoi/entities/comment.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/screens/home/widgets/comment_tile.dart';
import 'package:appmangxahoi/screens/home/widgets/postbuttoncomment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CommentsBottomSheet extends StatefulWidget {
  var content=Contentfriendship();
  CommentsBottomSheet({required this.content});
  static Future<void> showCommentsBottomSheet(
      BuildContext context, Contentfriendship content) async {
    return await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
      isScrollControlled: true,
      builder: (_) => CommentsBottomSheet(content: content), // Pass the required parameter here
    );
  }


  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  List<String> _comments = [];
  Future<List<dynamic>>? comments;
  var commentAPI = CommentAPI();
  Users? user;
  @override
  void initState() {
    super.initState();
    loadData();
    comments = commentAPI.findByContentid(widget.content.id!);
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
    final theme = Theme.of(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 64),
          child: Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: const EdgeInsets.only(bottom: 64),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: FutureBuilder<List<dynamic>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Chưa có bình luận'));
                } else {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.only(top: 16)
                            : EdgeInsets.zero,
                        child: CommentTile(comment: comments[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _header(theme),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _commentTextField(theme),
        ),
      ],
    );
  }

  Widget _header(ThemeData theme) {
    return SizedBox(
      height: 64,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: theme.dividerColor.withAlpha(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'Bình luận',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentTextField(ThemeData theme) {
    var comment1 = TextEditingController(text: "");
    var commentAPI=CommentAPI();
    return Container(
      color: theme.colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: comment1,
              autofocus: true,
              onSubmitted: _submitComment,
              decoration: InputDecoration(
                hintText: 'Viết bình luận',
                filled: true,
                isDense: true,
                fillColor: theme.colorScheme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () async {
              print("IconButton pressed"); // Debugging statement
              var comments1 = Comment(
                contentid: widget.content.id,
                userid: user!.id,
                comment1: comment1.text,
                date: "2023-11-29" ??
                    'No Date',
              );
              if (await commentAPI.create(comments1)) {
                print("Thành công");
              } else {
                print("Thất bại");
              }
              setState(() {
                comments = commentAPI.findByContentid(widget.content.id!);
                comment1.text = "";

              });
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _submitComment(String text) async{

  }
}
