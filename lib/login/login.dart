import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appmangxahoi/login/widgets/background.dart';
import '../apis/users_api.dart';
import '../entities/user.dart';
import '../nav/nav.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              padding: const EdgeInsets.all(32.0),
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
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    var screenSize = MediaQuery.of(context).size;
    double imageHeight = screenSize.height * 0.15;
    double imageWidth = screenSize.width * 0.8;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(0, -10.0),
            child: Image.asset(
              "assets/images/logo3.png",
              height: 150,
              width: imageWidth,
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
  State<_FormContent> createState() => _FormContentState();
}

class _FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UsersAPI _userApi = UsersAPI();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng không để trống';
                  }

                  bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) {
                    return 'Vui lòng nhập email hợp lệ';
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng không để trống';
                  }

                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Nhập mật khẩu của bạn',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                title: const Text('Ghi nhớ'),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: const Color(0xFFE1F6F4),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final user = Users(
                        email: email,
                        password: password,
                      );
                      final sharedPrefs = await SharedPreferences.getInstance();
                      bool loginSuccess;
                      try {
                        loginSuccess = await _userApi.login(user);
                      } catch (e) {
                        loginSuccess = false;
                        print('Login error: $e'); // Debugging statement
                      }
                      if (loginSuccess) {
                        final loggedInUser = await _userApi.findByEmail(email);
                        final userJson = jsonEncode(loggedInUser.toMap());
                        await sharedPrefs.setString('user', userJson);
                        print("Logged in user data: ${loggedInUser.toMap()}"); // Debugging statement
                        if(loggedInUser.roleId == 2){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Nav(),
                            ),
                          );
                        } else {
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
                                      'Xin lỗi bạn không đăng nhập tài khoản này',
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
                          ); // Debugging statement
                        }
                      } else {
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
                                    'Sai tài khoản hoặc mật khẩu',
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
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Không có tài khoản?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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
