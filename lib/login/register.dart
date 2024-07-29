import 'dart:convert';

import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/entities/user.dart';
import 'package:appmangxahoi/login//widgets/background.dart';
import 'package:appmangxahoi/login/login.dart';
import 'package:appmangxahoi/login/register.dart';
import 'package:appmangxahoi/nav/nav.dart';
import 'package:appmangxahoi/screens/home/home_screen.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Background(
      child: Scaffold(
          backgroundColor: Colors.transparent,
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
                  ))),
    );
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
          SizedBox(
            height: 40,
          ),
          SingleChildScrollView(
            child: Transform.translate(
              offset: Offset(0, -0.0), // Điều chỉnh giá trị y để di chuyển hình ảnh lên
              child: Image.asset(
                "assets/images/logo3.png",
                height: 150,
                width: imageWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Chào mừng đến SnapBook!",
              textAlign: TextAlign.center,
              style: isSmallScreen
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.black),
            ),
          )
        ],
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
  bool _rememberMe = false;
  var fullname=TextEditingController(text: "");
  var age = TextEditingController(text: "");
  var phone= TextEditingController(text: "");
  var email= TextEditingController(text: "");
  var address= TextEditingController(text: "");
  var password=TextEditingController(text: "");
  var repassword=TextEditingController(text: "");
  var userAPI=UsersAPI();
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
                TextFormField(
                  controller: fullname,
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Họ tên',
                    hintText: 'Mời nhập họ tên',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: age,
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tuổi',
                    hintText: 'Mời nhập tuổi',
                    prefixIcon: Icon(Icons.favorite),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: phone,
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: 'Mời nhập số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: address,
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    hintText: 'Mời nhập địa chỉ',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: email,
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }

                    bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Mời nhập email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),

                _gap(),
                TextFormField(
                  controller: password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống';
                    }

                    if (value.length < 6) {
                      return 'Password phải có 6 kí tự trở lên';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Mời nhập password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: const OutlineInputBorder(),
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
                  controller: repassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng không để trống';
                    }

                    if (value.length < 6) {
                      return 'Password phải có 6 kí tự trở lên';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Repassword',
                      hintText: 'Mời nhập lại password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: const OutlineInputBorder(),
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
                /*CheckboxListTile(
                  value: _rememberMe,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _rememberMe = value;
                    });
                  },
                  title: const Text('Remember me'),
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                _gap(),*/
                SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          backgroundColor: Color(0xFFE1F6F4)),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      onPressed: () async{
                        if (_formKey.currentState?.validate() ?? false) {
                          if(password.text==repassword.text){
                            var users=Users(
                              fullname: fullname.text,
                              address: address.text,
                              age: age.text,
                              phone: phone.text,
                              password: BCrypt.hashpw(password.text, BCrypt.gensalt()),
                              email: email.text,
                              photo: "noimage.jpg",
                                roleId: 2
                            );
                            var shared = await SharedPreferences.getInstance();
                            if(await userAPI.create(users)){
                              var user =await userAPI.findByEmail(email.text!);
                              var k =jsonEncode(user.toMap());
                              shared.setString("user", k);
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
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 60,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Chúc mừng bạn đã thành công',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white, backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text('Tiếp tục'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const Nav(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            
                            }else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Đăng ký thất bại"),
                                      content: Text("Thất bại"),
                                    );
                                  });
                            }
                          }else{
                            print("Loi");
                          }
                         
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          backgroundColor: Colors.white),
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'Đã có tài khoản?',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }

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
