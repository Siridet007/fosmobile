import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fos_mobile_v1/page/businesspage.dart';
import 'package:fos_mobile_v1/page/login.dart';
import 'package:fos_mobile_v1/page/mailpage.dart';
import 'package:fos_mobile_v1/page/purchasepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final String? usercode;
  final String? name;
  const MainPage({super.key, this.usercode, this.name});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences? sharedPreferences;

  Future removePass() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.remove('passWord');
  }

  Future exitFuture(BuildContext context) => showDialog(
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
                  Icons.question_mark,
                  color: Colors.white,
                ),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'ต้องการออกจากระบบใช่หรือไม่',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(90, 119, 128, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  removePass();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'YES',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(90, 119, 128, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'NO',
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await exitFuture(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'FOS MOBILE (PF)',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                exitFuture(context);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: const Color.fromRGBO(124, 81, 161, 1),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 196, 183, 207),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: [
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                color: const Color.fromRGBO(175, 163, 118, 1),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusinessPage(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/menu-business-today.png',
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                color: const Color.fromRGBO(24, 167, 188, 1),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MailPage(
                            username: widget.usercode, name: widget.name),
                      ),
                    );
                  },
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/menu-mail.png',
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                color: const Color.fromRGBO(59, 173, 173, 1),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PurchasePage(
                        usercode: widget.usercode,
                        name: widget.name,
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/menu-purchase.png',
                      color: Colors.white,
                      fit: BoxFit.cover,
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
