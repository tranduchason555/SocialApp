import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appmangxahoi/favorite/favpage.dart';
import 'package:appmangxahoi/profile/drawerscreen.dart';
import 'package:appmangxahoi/profile/profile_screen.dart';
import 'package:appmangxahoi/upload/upload_tap.dart';
import 'package:appmangxahoi/widgets/custom_button.dart';
import 'package:appmangxahoi/models/colors.dart';
import 'package:appmangxahoi/screens/home/home_screen.dart';
import 'package:appmangxahoi/screens/message/message_screen.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  bool _isLoggedIn = true;

  final _pages = [
    HomeScreen(),
    MessageScreen(),
    FavPageScreen(),
         Stack(
      children: [
  DrawerScreen(),
  ProfileScreen(),
  ],
  )
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getString('user') != null;
    });
  }

  void _changePageTo(int index) {
    setState(() => {_selectedIndex = index});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: _isLoggedIn && _selectedIndex != 1
          ? CustomButton(
        child: SvgPicture.asset(
          'assets/icons/plus.svg',
          color: Colors.white,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadTap(),
            ),
          );
        },
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _isLoggedIn && _selectedIndex != 1
          ? Container(
        height: 80.0,
        width: double.infinity,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 19.0),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              offset: const Offset(0, 4),
              color: kBlack.withOpacity(0.15),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _changePageTo(0),
              child: SvgPicture.asset(
                'assets/icons/home.svg',
                color: _selectedIndex == 0 ? kSelectedTabColor : null,
              ),
            ),
            GestureDetector(
              onTap: () => _changePageTo(1),
              child: SvgPicture.asset(
                'assets/icons/message.svg',
                color: _selectedIndex == 1 ? kSelectedTabColor : null,
              ),
            ),
            const SizedBox(),
            GestureDetector(
              onTap: () => _changePageTo(2),
              child: SvgPicture.asset(
                'assets/icons/favorite_border.svg',
                color: _selectedIndex == 2 ? kSelectedTabColor : null,
              ),
            ),
            GestureDetector(
              onTap: () => _changePageTo(3),
              child: SvgPicture.asset(
                'assets/icons/profile.svg',
                color: _selectedIndex == 3 ? kSelectedTabColor : null,
              ),
            ),
          ],
        ),
      )
          : null,
      drawer: _isLoggedIn ? DrawerScreen() : null,
    );
  }
}