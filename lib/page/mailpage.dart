import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fos_mobile_v1/model/model.dart';
import 'package:fos_mobile_v1/page/login.dart';
import 'package:fos_mobile_v1/page/mail/inboxpage.dart';
import 'package:fos_mobile_v1/page/mainpage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MailPage extends StatefulWidget {
  final String? username;
  final String? name;
  const MailPage({super.key, this.username, this.name});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  TextEditingController search = TextEditingController();
  int _selectedIndex = 0;
  List<GetMail>? mailList = [];
  List<GetMail>? tomeList = [];
  List<GetMail>? sendList = [];
  List<GetMail>? inboxList = [];
  List<GetMail>? tome = [];
  List<GetMail>? send = [];

  Future<List<GetMail>?> getMail(usercode, mode) async {
    String domain2 =
        "http://pfclapi.synology.me/~F0143/fosmailpf/mail_data.php?select=mailperson&usercode=$usercode&mode=$mode";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(jsonDecode(response.data));
    var result = GetMail.fromJsonList(jsonDecode(response.data));
    return result;
  }

  Future<List<GetMail>?> filterInbox() async {
    return inboxList?.toList();
  }

  Future<List<GetMail>?> filterTome() async {
    return tome?.toList();
  }

  Future<List<GetMail>?> filterSend() async {
    return send?.toList();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      getMail(widget.username, "inbox").then((value) {
        setState(() {
          inboxList = value;
          filterInbox().then((value) {
            setState(() {
              mailList = value;
            });
          });
        });
      });
      getMail(widget.username, "tome").then((value) {
        setState(() {
          tome = value;
          filterTome().then((value) {
            setState(() {
              tomeList = value;
            });
          });
        });
      });
      getMail(widget.username, "sent").then((value) {
        setState(() {
          send = value;
          filterSend().then((value) {
            setState(() {
              sendList = value;
            });
          });
        });
      });
    });
  }

  Future back(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MainPage(name: widget.name, usercode: widget.username),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getMail(widget.username, "inbox").then((value) {
      setState(() {
        inboxList = value;
        filterInbox().then((value) {
          setState(() {
            mailList = value;
          });
        });
      });
    });
    getMail(widget.username, "tome").then((value) {
      setState(() {
        tome = value;
        filterTome().then((value) {
          setState(() {
            tomeList = value;
          });
        });
      });
    });
    getMail(widget.username, "sent").then((value) {
      setState(() {
        send = value;
        filterSend().then((value) {
          setState(() {
            sendList = value;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await back(context);
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Container(
            width: MediaQuery.of(context).size.width * .4,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextField(
              controller: search,
              style: const TextStyle(fontSize: 18),
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'ค้นหาอีเมล',
                  hintStyle: TextStyle(fontSize: 16)),
              onChanged: (value) {
                setState(() {
                  if (_selectedIndex == 0) {
                    mailList = inboxList!
                        .where((element) =>
                            (element.sendcode! + element.firstname!)
                                .toLowerCase()
                                .contains(search.text.toLowerCase()))
                        .toList();
                  } else if (_selectedIndex == 1) {
                    tomeList = tome!
                        .where((element) =>
                            (element.sendcode! + element.firstname!)
                                .toLowerCase()
                                .contains(search.text.toLowerCase()))
                        .toList();
                  } else if (_selectedIndex == 2) {
                    sendList = send!
                        .where((element) =>
                            (element.sendcode! + element.firstname!)
                                .toLowerCase()
                                .contains(search.text.toLowerCase()))
                        .toList();
                  }
                });
              },
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    name: widget.name,
                    usercode: widget.username,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: const Color.fromRGBO(24, 167, 188, 1),
        ),
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: _refresh,
          color: const Color.fromRGBO(24, 167, 188, 1),
          backgroundColor: const Color.fromRGBO(200, 215, 212, 1),
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    mailList!.isEmpty
                        ? Center(
                            child: LoadingAnimationWidget.inkDrop(
                                color: const Color.fromRGBO(24, 167, 188, 1),
                                size: 200),
                          )
                        : ListView.builder(
                            itemCount: mailList!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InboxPage(
                                            recivecode:
                                                mailList![index].recivecode,
                                            receiveBy:
                                                mailList![index].reciveby,
                                            rname: mailList![index].rname,
                                            sendcode: mailList![index].sendcode,
                                            ninkname: mailList![index].nickname,
                                            firstname:
                                                mailList![index].firstname,
                                            mailno: mailList![index].mailno,
                                            subjects: mailList![index].subjects,
                                            deadline: mailList![index].deadline,
                                            priority: mailList![index].priority,
                                            type: mailList![index].type,
                                            flag: mailList![index].flag,
                                            name: widget.name,
                                            username: widget.username,
                                            mode: '1',
                                          ),
                                        ),
                                      );
                                    },
                                    leading: ClipOval(
                                      child: Image.network(
                                        'http://pfclapi.synology.me/~F0143/personpic/${mailList![index].sendcode}-3.jpg',
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.network(
                                            'http://pfclapi.synology.me/~F0143/personpic/${mailList![index].sendcode}-3.JPG',
                                            fit: BoxFit.cover,
                                            width: 60,
                                            height: 60,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.network(
                                                'http://pfclapi.synology.me/~F0143/personpic/${mailList![index].sendcode}.jpg',
                                                fit: BoxFit.cover,
                                                width: 60,
                                                height: 60,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/notperson.png',
                                                    fit: BoxFit.cover,
                                                    width: 60,
                                                    height: 60,
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    title: Text(
                                        '${mailList![index].sendcode} ${mailList![index].nickname} ${mailList![index].firstname}'),
                                    subtitle: Text(
                                      '${mailList![index].subjects}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: mailList![index].status == '1'
                                        ? const Icon(
                                            Icons.circle_notifications,
                                            color: Colors.red,
                                          )
                                        : null,
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                    tomeList!.isEmpty
                        ? Center(
                            child: LoadingAnimationWidget.inkDrop(
                                color: const Color.fromRGBO(24, 167, 188, 1),
                                size: 200),
                          )
                        : ListView.builder(
                            itemCount: tomeList!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InboxPage(
                                            recivecode:
                                                tomeList![index].recivecode,
                                            receiveBy:
                                                tomeList![index].reciveby,
                                            rname: tomeList![index].rname,
                                            sendcode: tomeList![index].sendcode,
                                            ninkname: tomeList![index].nickname,
                                            firstname:
                                                tomeList![index].firstname,
                                            mailno: tomeList![index].mailno,
                                            subjects: tomeList![index].subjects,
                                            deadline: tomeList![index].deadline,
                                            priority: tomeList![index].priority,
                                            type: tomeList![index].type,
                                            flag: tomeList![index].flag,
                                            name: widget.name,
                                            username: widget.username,
                                            mode: '2',
                                          ),
                                        ),
                                      );
                                    },
                                    leading: ClipOval(
                                      child: Image.network(
                                        'http://pfclapi.synology.me/~F0143/personpic/${tomeList![index].sendcode}-3.jpg',
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.network(
                                            'http://pfclapi.synology.me/~F0143/personpic/${tomeList![index].sendcode}-3.JPG',
                                            fit: BoxFit.cover,
                                            width: 60,
                                            height: 60,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.network(
                                                'http://pfclapi.synology.me/~F0143/personpic/${tomeList![index].sendcode}.jpg',
                                                fit: BoxFit.cover,
                                                width: 60,
                                                height: 60,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/notperson.png',
                                                    fit: BoxFit.cover,
                                                    width: 60,
                                                    height: 60,
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    /*leading: CircleAvatar(
                                      radius: 30,                                
                                      backgroundImage: NetworkImage(
                                          'http://pfclapi.synology.me/~F0143/personpic/${tomeList![index].sendcode}.jpg'),
                                    ),*/
                                    title: Text(
                                        '${tomeList![index].sendcode} ${tomeList![index].nickname} ${tomeList![index].firstname}'),
                                    subtitle:
                                        Text('${tomeList![index].subjects}'),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                    sendList!.isEmpty
                        ? Center(
                            child: LoadingAnimationWidget.inkDrop(
                                color: const Color.fromRGBO(24, 167, 188, 1),
                                size: 200),
                          )
                        : ListView.builder(
                            itemCount: sendList!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InboxPage(
                                            recivecode:
                                                sendList![index].recivecode,
                                            receiveBy:
                                                sendList![index].reciveby,
                                            rname: sendList![index].rname,
                                            sendcode: sendList![index].sendcode,
                                            ninkname: sendList![index].nickname,
                                            firstname:
                                                sendList![index].firstname,
                                            mailno: sendList![index].mailno,
                                            subjects: sendList![index].subjects,
                                            deadline: sendList![index].deadline,
                                            priority: sendList![index].priority,
                                            type: sendList![index].type,
                                            flag: sendList![index].flag,
                                            name: widget.name,
                                            username: widget.username,
                                            mode: '3',
                                          ),
                                        ),
                                      );
                                    },
                                    leading: ClipOval(
                                      child: Image.network(
                                        'http://pfclapi.synology.me/~F0143/personpic/${sendList![index].sendcode}-3.jpg',
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.network(
                                            'http://pfclapi.synology.me/~F0143/personpic/${sendList![index].sendcode}-3.JPG',
                                            fit: BoxFit.cover,
                                            width: 60,
                                            height: 60,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.network(
                                                'http://pfclapi.synology.me/~F0143/personpic/${sendList![index].sendcode}.jpg',
                                                fit: BoxFit.cover,
                                                width: 60,
                                                height: 60,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/notperson.png',
                                                    fit: BoxFit.cover,
                                                    width: 60,
                                                    height: 60,
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    /*leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          'http://pfclapi.synology.me/~F0143/personpic/${sendList![index].sendcode}.jpg'),
                                    ),*/
                                    title: Text(
                                        '${sendList![index].sendcode} ${sendList![index].nickname} ${sendList![index].firstname}'),
                                    subtitle:
                                        Text('${sendList![index].subjects}'),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        endDrawer: Drawer(
          backgroundColor: const Color.fromRGBO(192, 207, 204, 1),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(170, 195, 195, 1)),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'http://pfclapi.synology.me/~F0143/personpic/${widget.username}.jpg',
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text('${widget.username} ${widget.name}')
                  ],
                ),
              ),
              ListTile(
                title: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: _selectedIndex == 0
                      ? const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                          color: Color.fromRGBO(24, 167, 188, 1),
                        )
                      : null,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        'INBOX',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: _selectedIndex == 1
                      ? const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                          color: Color.fromRGBO(24, 167, 188, 1),
                        )
                      : null,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.attach_email,
                        color: Colors.black,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        'TOME',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: _selectedIndex == 2
                      ? const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                          color: Color.fromRGBO(24, 167, 188, 1),
                        )
                      : null,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.send_sharp,
                        color: Colors.black,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        'SENT',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WritePage(),
                ),
              );
            });
          },
          backgroundColor: const Color.fromRGBO(24, 167, 188, 1),
          child: const Icon(
            Icons.border_color,
            color: Colors.white,
          ),
        ),*/
      ),
    );
  }
}
