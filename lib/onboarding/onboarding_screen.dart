import 'dart:async';

import 'package:appmangxahoi/login/login.dart';
import 'package:appmangxahoi/nav/nav.dart';
import 'package:appmangxahoi/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

import '../../models/colors.dart';
import 'widgets/background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  final List<String> images = ['hinh8.png', 'hinh21.png', 'hinh1.png']; // Replace with your image paths
  Timer? _timer;

  _onPageChanged(index) {
    setState(() => _pageIndex = index);
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _pageIndex = (_pageIndex + 1) % images.length;
      _pageController.animateToPage(
        _pageIndex,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView( // Added SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PageView.builder
              SizedBox(
                height: size.height * 0.7, // Adjust height as needed
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Chào mừng đến',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'SnapBook',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 57.0),
                        AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          child: SizedBox(
                            key: ValueKey<int>(_pageIndex),
                            width: 350, // Adjust the width as needed
                            height: 300, // Adjust the height as needed
                            child: Image.asset(
                              'assets/images/${images[_pageIndex]}',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  onPageChanged: _onPageChanged,
                ),
              ),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) => Container(
                    height: 12.0,
                    width: 12.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pageIndex == index ? kBlack : null,
                      border: Border.all(width: 1.0, color: kBlack),
                    ),
                  ),
                ),
              ),
              // Button at bottom right
              SizedBox(
                height: size.height * 0.3, // Adjust height as needed
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: -50,
                        right: -50,
                        child: Transform.rotate(
                          angle: math.pi / 4,
                          child: Container(
                            height: size.width * 0.7,
                            width: size.width * 0.68,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: kBlack),
                              borderRadius: BorderRadius.circular(87.0),
                            ),
                            child: Container(
                              height: size.width * 0.65,
                              width: size.width * 0.62,
                              decoration: BoxDecoration(
                                color: _pageIndex.isEven ? k2MainThemeColor : k2MainThemeColor,
                                borderRadius: BorderRadius.circular(79.0),
                              ),
                              child: Transform.rotate(
                                angle: -math.pi / 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tiếp tục',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                        color: _pageIndex.isEven ? kBlack : null,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    SvgPicture.asset(
                                      'assets/icons/arrow_forward.svg',
                                      color: _pageIndex.isEven ? kBlack : kBlack,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
