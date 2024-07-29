import 'dart:async';
import 'dart:convert';

import 'package:appmangxahoi/apis/users_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/screens/message/widgets/message_background.dart';
import 'package:appmangxahoi/screens/message/widgets/message_item.dart';
import 'package:appmangxahoi/apis/message_api.dart';
import 'package:appmangxahoi/nav/nav.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final messageAPI = MessageAPI();
  Users? user;
  TextEditingController keywordController = TextEditingController();
  List<dynamic> allMessages = [];
  List<dynamic> filteredMessages = [];
  Timer? debounce;
  var userAPI = UsersAPI();

  @override
  void initState() {
    super.initState();
    loadData();
    keywordController.addListener(() {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        filterMessages();
      });
    });
  }

  @override
  void dispose() {
    keywordController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void loadData() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      setState(() {
        var k = shared.getString("user");
        user = Users.fromMap(jsonDecode(k!));
        fetchMessages();
      });
    }
  }

  void fetchMessages() async {
    try {
      List<dynamic> messages = await messageAPI.findByUserid(user!.id!);
      setState(() {
        allMessages = messages;
        filteredMessages = messages;
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void filterMessages() async {
    var keyword = keywordController.text.toLowerCase();
    print('Filtering messages with keyword: $keyword');

    if (keyword.isEmpty) {
      setState(() {
        filteredMessages = allMessages;
      });
    } else {
      try {
        List<dynamic> messages = await messageAPI.findByFullname(user!.id!, keyword);
        print('Filtered messages: ${messages.length}');
        setState(() {
          filteredMessages = messages;
        });
      } catch (e) {

        print('Error filtering messages: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Nav()),
            ),
            icon: SvgPicture.asset('assets/icons/button_back.svg'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tin nhắn',
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
                      hintText: 'Tìm Kiếm',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: k1LightGray),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                filteredMessages.isEmpty
                    ? Center(child: Text('Bạn không có tin nhắn nào cả'))
                    : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    dynamic message = filteredMessages[index];
                    return MessageItem(
                      message: message,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
