import 'dart:async';
import 'dart:convert';
import 'package:appmangxahoi/apis/chat_api.dart';
import 'package:appmangxahoi/entities/chat.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:appmangxahoi/apis/comment_api.dart';
import 'package:appmangxahoi/message_detail/widgets/message_detail_background.dart';
import 'package:appmangxahoi/widgets/custom_button.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageDetailScreen extends StatefulWidget {
  final dynamic messagess;

  MessageDetailScreen({this.messagess});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  Future<List<dynamic>>? messages1;
  var commentAPT = CommentAPI();
  var chatAPI = ChatAPI();
  Users? user;
  var keyword = TextEditingController(text: '');
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    loadData();
    messages1 = commentAPT.findByMessageid(widget.messagess.messageId!);

    keyword.addListener(() {
      setState(() {
        isButtonActive = keyword.text.trim().isNotEmpty;
      });
    });
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
    Size size = MediaQuery.of(context).size;
    return MessageDetailBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset('assets/icons/button_back.svg'),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.0, color: kBlack),
                    ),
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage(widget.messagess.otherUserPhoto!),
                      radius: 35.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.messagess.otherFullName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Trực tuyến',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: messages1,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có tin nhắn'));
                  } else {
                    snapshot.data!.sort((a, b) {
                      DateTime timeA = DateTime.parse(a.date);
                      DateTime timeB = DateTime.parse(b.date);

                      return timeB.compareTo(timeA);
                    });

                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        final message = snapshot.data![index];
                        bool isCurrentUser = message.userid == user!.id!;
                        return Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            Container(
                              constraints:
                              BoxConstraints(maxWidth: size.width * 0.80),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Color(0xFFFAFAFA)
                                    : k2MainThemeColor, // Color change
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(20.0),
                                  bottomRight: const Radius.circular(20.0),
                                  topLeft: index.isEven
                                      ? Radius.zero
                                      : const Radius.circular(20.0),
                                  topRight: index.isOdd
                                      ? Radius.zero
                                      : const Radius.circular(20.0),
                                ),
                              ),
                              child: Text(message.content!),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              height: 86,
              width: size.width,
              margin: const EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                top: 8.0,
                bottom: 50.0,
              ),
              padding: const EdgeInsets.only(
                left: 32.0,
                right: 16.0,
              ),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 25.0,
                    color: kBlack.withOpacity(0.10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: keyword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Soạn tin nhắn...',
                        hintStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  CustomButton(
                    child: SvgPicture.asset(
                      'assets/icons/send.svg',
                      color:
                      isButtonActive ? Colors.black : Colors.grey,
                    ),
                    onTap: () async {
                      if (keyword.text.trim().isNotEmpty) {
                        var chatsss = Chat(
                          messagesid: widget.messagess.messageId,
                          content: keyword.text,
                          userid: widget.messagess.otherUserId,
                        );
                        if (await chatAPI.create(chatsss)) {
                          print("Thành công");
                        } else {
                          print("Thất bại");
                        }
                        setState(() {
                          messages1 = commentAPT.findByMessageid(
                              widget.messagess.messageId!);
                          keyword.text = "";
                          isButtonActive = false;
                        });
                      } else {
                        print("Tin nhắn không thể gửi");
                      }
                    },
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
