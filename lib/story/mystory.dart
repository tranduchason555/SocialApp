import 'package:audioplayers/audioplayers.dart';
import 'package:appmangxahoi/apis/story_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'dart:async';

class MyStoryPage extends StatefulWidget {
  final dynamic userId;

  MyStoryPage({required this.userId});

  @override
  State<MyStoryPage> createState() => _MyStoryPageState();
}

class _MyStoryPageState extends State<MyStoryPage> with SingleTickerProviderStateMixin {
  final StoryController controller = StoryController();
  final AudioPlayer audioPlayer = AudioPlayer();
  Timer? _timer;
  var storyAPI = StoryAPI();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(seconds: 60), () {
      _stopMusic();
      Navigator.pop(context);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    _stopMusic();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playMusic(String url) async {
    try {
      await audioPlayer.setSource(AssetSource(url));
      print(url); // Lưu ý: chỉ cần đường dẫn từ thư mục assets
      await audioPlayer.resume();
    } catch (e) {
      print("Error: $e");
    }
  }

  void _stopMusic() async {
    await audioPlayer.stop();
  }

  Widget _buildMusicIcon(String url) {
    _playMusic(url);
    return RotationTransition(
      turns: _animation,
      child: Icon(
        Icons.music_note,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: storyAPI.findByUserid1(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<dynamic> stories = snapshot.data!;
                return StoryView(
                  storyItems: stories.map((story) {
                    return StoryItem.pageImage(
                      url: story.photo,
                      imageFit: BoxFit.fitWidth,
                      controller: controller,
                      duration: Duration(seconds: 10),
                    );
                  }).toList(),
                  controller: controller,
                  onStoryShow: (storyItem, index) {
                    _stopMusic();
                    var currentStory = stories[index];
                    _playMusic(currentStory.content);
                  },
                );
              }
            },
          ),
          FutureBuilder(
            future: storyAPI.findByUserid1(widget.userId),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                dynamic story = snapshot.data;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 65, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(story.first.photoUser),
                                radius: 20,
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story.first.fullname,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    story.first.date != null
                                        ? DateFormat('dd/MM/yyyy').format(story.first.date)
                                        : 'No Date',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _stopMusic();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (story.first.content == "music/ChungTaRoiSeHanhPhuc-JackJ97-12903446.mp3") ...[
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            _buildMusicIcon(story.first.content),

                          ],
                          if (story.first.content == "music/DungLamTraiTimAnhDau.wav") ...[
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            _buildMusicIcon(story.first.content),
                          ],
                          if (story.first.content == "music/EmOnKhong.wav") ...[
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            _buildMusicIcon(story.first.content),
                          ]
                          ,if (story.first.content == "music/TTLLNDCE.wav") ...[
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            _buildMusicIcon(story.first.content),
                          ]
                          ,if (story.first.content == "music/XinDungLangIm.wav") ...[
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            _buildMusicIcon(story.first.content),
                          ]
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
