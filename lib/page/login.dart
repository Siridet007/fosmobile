// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fos_mobile_v1/model/secure.dart';
import 'package:fos_mobile_v1/page/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  bool remember = false;
  double? width;
  double? height;

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(prefs);
    setState(() {
      userName.text = prefs.getString('userName') ??
          ''; // โหลดค่า username และตั้งค่าใน TextField
      remember = prefs.getBool('remember') ??
          false; // โหลดค่า rememberMe และตั้งค่าใน Checkbox
      if (remember) {
        passWord.text = prefs.getString('passWord') ??
            ''; // ถ้า rememberMe เป็น true โหลดค่า password และตั้งค่าใน TextField
      }
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName.text);
    await prefs.setBool('remember', remember);
    if (remember) {
      await prefs.setString('passWord', passWord.text);
    } else {
      await prefs.remove('passWord');
    }
  }

  Future<void> checklogin() async {
    String urlAPI = "http://pfclapi.synology.me/~F0143/fosmailpf/fos25_data.php?select=check_login&usercode=${userName.text}&passwords=${passWord.text}";
    Response response = await Dio().post(urlAPI);
    //print(jsonDecode(response.data));
    var result;
    if (response.data.trim().isEmpty) {
      result = null;
    } else {
      result = jsonDecode(response.data);
      //print(result.first['name_eng']);
    }
    if (result != null) {
      _saveData();
      if (remember) {
        await SecureStorageHelper.saveCredentials(userName.text, passWord.text);
      } else {
        await SecureStorageHelper.deleteCredentials();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MainPage(usercode: userName.text, name: result.first['name_eng']),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(90, 119, 128, 1),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
              ),
              const Text(
                '  Alert',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(90, 119, 128, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'เข้าใจแล้ว',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'FOS MOBILE (PF)',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(124, 81, 161, 1),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height! * .89,
            color: const Color.fromARGB(255, 196, 183, 207),
            //padding: EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    'http://pfclapi.synology.me/~F0143/personpic/${userName.text}.jpg',
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/notperson.png',
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                /*Container(
                  //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  width: 300,
                  height: 150,
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/notperson.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),*/
                Container(
                  width: 300,
                  height: 60,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_title.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 220,
                  color: const Color.fromRGBO(169, 205, 205, 1),
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'USERNAME',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[700]),
                            ),
                            Container(
                              width: 130,
                              height: 35,
                              color: Colors.white,
                              child: TextField(
                                controller: userName,
                                style: const TextStyle(fontSize: 18),
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                  hintText: 'รหัสพนักงาน',
                                  hintStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PASSWORD',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[700],
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 35,
                              color: Colors.white,
                              child: TextField(
                                controller: passWord,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(Radius.zero),
                                    ),
                                    hintText: 'รหัสผ่าน',
                                    hintStyle: TextStyle(fontSize: 16)),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.grey[500];
                              }
                              return Colors.grey[600];
                            }),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey[600]),
                            foregroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.black),
                          ),
                          onPressed: () {
                            checklogin();
                          },
                          icon: const Icon(Icons.login),
                          label: const Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              color: Colors.white,
                              child: Checkbox(
                                fillColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.grey;
                                  }
                                  return Colors.grey;
                                }),
                                value: remember,
                                onChanged: (value) {
                                  setState(() {
                                    remember = value!;
                                  });
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  remember = !remember;
                                });
                              },
                              child: const Text(
                                'REMEMBER USERNAME',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
