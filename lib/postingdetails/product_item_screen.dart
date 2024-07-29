import 'dart:convert';
import 'dart:ui';
import 'package:appmangxahoi/apis/contentfriendship_api.dart';
import 'package:appmangxahoi/apis/save_api.dart';
import 'package:appmangxahoi/entities/save.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appmangxahoi/apis/comment_api.dart';
import 'package:appmangxahoi/apis/like_api.dart';
import 'package:appmangxahoi/entities/friendship.dart';
import 'package:appmangxahoi/entities/like.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/screens/home/widgets/commentbutton.dart';
import 'package:appmangxahoi/widgets/custom_button.dart';

class ProductItemScreen extends StatefulWidget {
  dynamic content;
  ProductItemScreen({this.content});

  @override
  _ProductItemScreenState createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  int _count = 0;
  int commentCount = 0;
  int saveCount = 0;
  var likeAPI = LikeAPI();
  var contentAPI=ContentfriendshipAPI();
  Users? user;
  var saveAPI=SaveAPI();
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<dynamic>>(
        future: contentAPI.findByContentId(widget.content.id!),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var item = snapshot.data!;
            return Stack(
              children: [
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width, // Adjust width as needed
                      maxHeight: MediaQuery.of(context).size.height * 0.55, // Adjust height as needed
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item.first.contentPhoto!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                    ),
                  ),
                ),
                Positioned(
                  top: 110, // Move up by 35 points
                  left: 20,
                  child: Row(
                    children: [
                      buttonArrow(context),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        backgroundImage: NetworkImage(item.first.photo!), // Path to user avatar
                        radius:25,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.first.fullname ?? 'Unknown', // Ensure fullname is not null
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Text(
                            item.first.date != null
                                ? DateFormat('dd/MM/yyyy').format(item.first.date)
                                : 'No Date',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 18,
                  left: 15,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Black color with 50% opacity
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          item.first.content1 ?? '', // Ensure content1 is not null
                          style: GoogleFonts.raleway(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                        const Divider(color: Colors.white),
                        _postButtons(widget.content),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text('Có vẻ như chưa có lượt thích nào'),
            );
          }
        },
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
                            });
                          } else {
                            print("Failed to unlike the post");
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
                          });
                        } catch (e) {
                          print("Error liking the post: $e");
                        }
                      }
                    },
                    onToggle: (isActive, count) {
                      setState(() {
                        content1.countLike = count;
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
                              });
                            } else {
                              print("Failed to unlike the post");
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
                            });
                          } catch (e) {
                            print("Error liking the post: $e");
                          }
                        }
                      },
                      onToggle: (isActive, count) {
                        setState(() {
                          content1.countSave = count;
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
            color: _isActive ? Colors.red : Colors.white,
          ),
          const SizedBox(width: 8.0),
          Text(
            _count.toString(),
            style: TextStyle(
              color: _isActive ? Colors.red : Colors.white,
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
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white,),
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
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
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
                  return Text('${snapshot.data!.length}'
                  ,style: TextStyle(color: Colors.white),);
                }
              },
            ),
          ],
        ));

  }
}

Widget buttonArrow(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      clipBehavior: Clip.hardEdge,
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}