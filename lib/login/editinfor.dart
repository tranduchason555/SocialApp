import 'dart:convert';
import 'dart:io';

import 'package:appmangxahoi/apis/base_url.dart';
import 'package:appmangxahoi/apis/users_api.dart';
import 'package:appmangxahoi/login/changephoto.dart';
import 'package:appmangxahoi/login/login.dart';
import 'package:appmangxahoi/nav/nav.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

final userAPI = UsersAPI();
Users? user;

class _EditProfileState extends State<EditProfile> {
  String? selectedPath;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.getString("user") != null) {
      setState(() {
        var k = shared.getString("user");
        user = Users.fromMap(jsonDecode(k!));
      });
    }
  }

  void _updatePath(String? path) {
    setState(() {
      selectedPath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: isSmallScreen
            ? SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Logo(onFileSelected: _updatePath),
              if (user != null) _FormContent(user: user!, filePath: selectedPath),
            ],
          ),
        )
            : SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              children: [
                Expanded(child: _Logo(onFileSelected: _updatePath)),
                Expanded(
                  child: Center(
                    child: user != null
                        ? _FormContent(user: user!, filePath: selectedPath)
                        : const CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  final void Function(String?) onFileSelected;

  const _Logo({Key? key, required this.onFileSelected}) : super(key: key);

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  String? path;

  void selectAFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult != null) {
      PlatformFile platformFile = filePickerResult.files.first;
      setState(() {
        path = platformFile.path;
      });
      widget.onFileSelected(path);
    }
  }

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
          SizedBox(height: 50),
          SingleChildScrollView(
            child: Transform.translate(
              offset: const Offset(0, -20.0),
              child: Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: path == null
                          ? Image.network(user!.photo.toString())
                          : Image.file(File(path!)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        selectAFile();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xFFE1F6F4),
                        ),
                        child: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              user!.email!,
              textAlign: TextAlign.center,
              style: isSmallScreen
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  final Users user;
  final String? filePath;

  const _FormContent({Key? key, required this.user, this.filePath}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  late TextEditingController fullnameController;
  late TextEditingController ageController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fullnameController = TextEditingController(text: widget.user.fullname.toString());
    ageController = TextEditingController(text: widget.user.age);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController = TextEditingController(text: widget.user.address);
    _loadData();
  }
  void _loadData() async {
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
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: fullnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thông tin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Họ tên',
                    hintText: 'Nhập họ tên',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                _gap(),
                TextFormField(
                  controller: ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thông tin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tuổi',
                    hintText: 'Nhập tuổi',
                    prefixIcon: Icon(Icons.favorite),
                    border: OutlineInputBorder(),
                  ),
                ),
                _gap(),
                TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thông tin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                _gap(),
                TextFormField(
                  controller: addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thông tin';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    hintText: 'Nhập địa chỉ',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                ),
                _gap(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: const Color(0xFFE1F6F4),
                    ),
                    onPressed: () async {

                      if (_formKey.currentState!.validate()) {


                        if (widget.filePath == null) {
                          Users updatedUser = Users(
                            id: widget.user.id,
                            fullname: fullnameController.text,
                            email: widget.user.email,
                            password: widget.user.password,
                            age: ageController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            photo: widget.user!.photo?.replaceFirst(BareUrl.imageurl,''),
                            roleId: 2,
                          );
                          var success = await userAPI.update(updatedUser);
                          if (success != null) {
                            print("Update successful");
                            setState(() {
                              _loadData();
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Nav(),
                              ),
                            );
                          } else {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Thành công')),
                            );
                            setState(() {
                              _loadData();
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Nav(),
                              ),
                            );
                          }
                          setState(() {
                            _loadData();
                          });
                        }
                        else{
                          Users updatedUser = Users(
                            id: widget.user.id,
                            fullname: fullnameController.text,
                            email: widget.user.email,
                            password: widget.user.password,
                            age: ageController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            roleId: 2,
                          );
                          var strProduct = jsonEncode(updatedUser.toMap());

                          print("Updating user with data: $strProduct");
                          var success = await userAPI.update2(File(widget.filePath!), strProduct);

                          if (success != null) {
                            print("Update successful");
                            setState(() {
                              _loadData();
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Nav(),
                              ),
                            );
                          } else {
                            setState(() {
                              _loadData();
                            });
                            print("Update failed");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Thành công')),
                            );
                          }
                          setState(() {
                            _loadData();
                          });
                        }


                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Đổi thông tin',
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
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
