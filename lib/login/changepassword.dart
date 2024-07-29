
import 'dart:convert';

import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/login/login.dart';
import 'package:appmangxahoi/profile/widgets/profile_background.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();

}
final userAPI = UsersAPI();
Users? user;
class _ChangePassPageState extends State<ChangePassPage> {

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return
      Scaffold(
          appBar: AppBar(
            title: const Text('Đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.bold),),
            centerTitle: true,

          ),
          body: Center(
              child: isSmallScreen
                  ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _Logo(),
                    _FormContent(),
                  ],
                ),
              )
                  : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(25.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: const [
                      Expanded(child: _Logo()),
                      Expanded(
                        child: Center(child: _FormContent()),
                      ),
                    ],
                  ),
                ),
              )));
  }
}
class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
// Lấy kích thước màn hình
    var screenSize = MediaQuery.of(context).size;
    // Tính toán chiều cao và chiều rộng dựa trên kích thước màn hình
    double imageHeight = screenSize.height * 0.15; // Ví dụ chiếm 15% chiều cao màn hình
    double imageWidth = screenSize.width * 0.8;   // Ví dụ chiếm 80% chiều rộng màn hình
    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //FlutterLogo(size: isSmallScreen ? 100 : 200),
            /*Text(
            'SnapBook',
            style: Theme.of(context).textTheme.displayLarge,
          ),*/
            SingleChildScrollView(
              child: Transform.translate(
                offset: Offset(0, -10.0), // Điều chỉnh giá trị y để di chuyển hình ảnh lên
                child: Image.asset(
                  "assets/images/logo3.png",
                  height: 150,
                  width: imageWidth,
                ),
              ),
            ),
          ]
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
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
  void initState() {
    super.initState();
    loadData();
  }
  var newpasswordController = TextEditingController(text: "");
  var renewpassword = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly: true,
                  initialValue: user!.email,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.alternate_email),
                    border: OutlineInputBorder(),
                  ),
                ),
                _gap(),
                TextFormField(
                  controller: newpasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải dài hơn 6 kí tự';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      hintText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )),
                ),
                _gap(),
                TextFormField(
                  controller: renewpassword,
                  validator: (value) {
                    if (value == null || value != newpasswordController.text) {
                      return 'Vui lòng nhập đúng mật khẩu vừa nhập';
                    }

                    if (value.length < 6) {
                      return 'Password phải có 6 kí tự trở lên';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Nhập lại mật khẩu',
                      hintText: 'Nhập lại mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )),
                ),
                _gap(),
                _gap(),
                _gap(),
                SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: ()async {
                        if (_formKey.currentState?.validate() ?? false) {
                          user?.password = BCrypt.hashpw(newpasswordController.text, BCrypt.gensalt());
                          user?.roleId = 2;
                          user?.photo = user!.photo?.replaceFirst(BareUrl.imageurl,'');
                          userAPI.update(user!);
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          await pref.clear();
                          setState(() {
                            loadData();
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false,
                          );}
                        else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Vui lòng nhập đúng mật khẩu',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text('Thử lại'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      child:  Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE1F6F4), side: BorderSide.none, shape: const StadiumBorder()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}