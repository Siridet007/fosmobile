// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fos_mobile_v1/model/model.dart';
import 'package:fos_mobile_v1/page/mailpage.dart';

class WritePage extends StatefulWidget {
  final String? recivecode;
  final String? reciveby;
  final String? sendcode;
  final String? ninkname;
  final String? firstname;
  final String? subjects;
  final String? detail;
  final String? priority;
  final String? deadline;
  final String? type;
  final String? flag;
  final String? name;
  final String? username;
  const WritePage({
    super.key,
    this.sendcode,
    this.ninkname,
    this.firstname,
    this.subjects,
    this.priority,
    this.deadline,
    this.type,
    this.flag,
    this.recivecode,
    this.reciveby, this.name, this.username, this.detail,
  });

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  /*final List<String> _contacts = [
    'Lindsay Carter',
    'Another Contact',
    'Someone Else',
    'aaaa',
    'bbbb',
    'cccc',
    'fddd',
    'dfdsffst',
    'sfsfsfsfesfsgfs',
  ];
  List<String> _selectedContacts = [];
  List<String> _selectedContactsCC = [];
  List<PlatformFile> _selectedFiles = [];
  String? _selectedContact;*/

  Future<List<GetMail>?> sendMail(recode, sendcode, sub, detail, flag) async {
    FormData formData = FormData.fromMap(
      {
        "select": "send_automail",
        "mode": "R",
        "receivecode": recode,
        "sendcode": sendcode,
        "subjects": sub,
        "detail": detail,
        "priority": "N",
        "deadline": '0000-00-00',
        "attachqty": '0',
        "foryour": "FYI",
        "type": "1",
        "flag": flag
      },
    );
    //var sss = jsonEncode(formData);
    //var value = '?select=send_automail&mode=R&recivecode=$recode&reciveby=$reby&sendcode=$sendcode&subjects=$sub&detail=$detail&priority=N&deadline=0000-00-00&attachqty=0&foryour=FYI&type=1&flag=$flag';
    String domain =
        "http://pfclapi.synology.me/~F0143/fosmailpf/mail_data.php?select=send_automail";
    var result;
    try {
      Response response = await Dio().post(domain, data: formData);
      print('data ${response.data}');
      result = GetMail.fromJsonList(jsonDecode(response.data));
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future replyFuture(BuildContext context) => showDialog(
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
            'ต้องการตอบกลับอีเมลนี้ใช่หรือไม่',
            style: TextStyle(fontSize: 19),
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
                  sendMail(
                    widget.recivecode,
                    widget.sendcode,
                    _subjectController.text,
                    '${_bodyController.text}\n${detailController.text}',
                    widget.flag,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MailPage(
                        name: widget.name,
                        username: widget.username,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'ใช่',
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
                  'ไม่ใช่',
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

  /*void pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<PlatformFile> files = result.files;

      // Filter out files that exceed the size limit
      List<PlatformFile> validFiles =
          files.where((file) => file.size <= 5242880).toList();

      if (validFiles.isEmpty) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'No files selected or files are too large. Max size is 5MB.'),
        ));
        return;
      }

      setState(() {
        _selectedFiles.addAll(validFiles);
      });
    }
  }

  void removeFile(PlatformFile fileToRemove) {
    setState(() {
      _selectedFiles.remove(fileToRemove);
    });
  }*/

  @override
  void initState() {
    super.initState();
    _subjectController.text = 'Re:${widget.subjects.toString()}';
    detailController.text = '_________________________________________________________________________\n${widget.detail}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Email',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: const Color.fromRGBO(24, 167, 188, 1),
        actions: [
          /*IconButton(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => const ForyourPage(),
              );
              //fyFuture(context);
            },
            icon: const Icon(Icons.bookmark_outlined),
          ),
          IconButton(
            onPressed: () {
              pickFiles();
            },
            icon: const Icon(Icons.attach_file),
          ),*/
          IconButton(
            onPressed: () {
              print('1 ${widget.recivecode}');
              print('2 ${widget.reciveby}');
              print('3 ${widget.sendcode}');
              print('4 ${_subjectController.text}');
              print('5 ${_bodyController.text}\n${detailController.text}');
              print('6 ${widget.flag}');
              replyFuture(context);
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  const Text(
                    'TO : ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${widget.sendcode} ${widget.ninkname} ${widget.firstname}',
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
              /*ListTile(
                title: const Text(
                  'To',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                subtitle: TextField(
                  controller: _toController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: DropdownButton<String>(
                  underline: const SizedBox(),
                  isExpanded: false,
                  value:
                      _selectedContact, // Use a variable to hold the selected contact
                  hint: const Text(
                    'รายชื่อผู้รับ  ',
                    style: TextStyle(fontSize: 16),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _toController.text = newValue!;
                    });
                  },
                  items: _contacts.map((contact) {
                    return DropdownMenuItem<String>(
                      value: contact,
                      child: Text(contact),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return _contacts.map<Widget>((String item) {
                      return Container(); // Empty container to hide selected items in the dropdown
                    }).toList();
                  },
                ),
              ),*/
              /*ListTile(
                title: const Text(
                  'CC',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                subtitle: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: _selectedContactsCC.map<Widget>((contact) {
                    return InputChip(
                      label: Text(contact),
                      onDeleted: () {
                        setState(() {
                          _selectedContactsCC.remove(contact);
                        });
                      },
                    );
                  }).toList(),
                ),
                trailing: DropdownButton<String>(
                  underline: const SizedBox(),
                  isExpanded: false,
                  value: null,
                  hint: const Text(
                    'รายชื่อ CC  ',
                    style: TextStyle(fontSize: 16),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      if (_selectedContactsCC.contains(newValue)) {
                        _selectedContactsCC.remove(newValue);
                      } else {
                        _selectedContactsCC.add(newValue!);
                      }
                    });
                  },
                  items: _contacts.map((contact) {
                    return DropdownMenuItem<String>(
                      value: contact,
                      child: Text(contact),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return _contacts.map<Widget>((String item) {
                      return Container(); // Empty container to hide selected items in the dropdown
                    }).toList();
                  },
                ),
              ),*/
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              TextField(
                controller: _subjectController,
                style: const TextStyle(fontSize: 18),
                cursorColor: const Color.fromRGBO(24, 167, 188, 1),
                decoration: const InputDecoration(hintText: 'เรื่อง'),
                readOnly: true,
              ),
              TextField(
                controller: _bodyController,
                minLines: 10,
                maxLines: 20,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color.fromRGBO(24, 167, 188, 1),
                decoration: const InputDecoration(hintText: 'เขียนอีเมล'),
              ),
              TextField(
                controller: detailController,
                minLines: 10,
                maxLines: 20,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color.fromRGBO(24, 167, 188, 1),
                decoration: const InputDecoration(hintText: 'เขียนอีเมล'),
                readOnly: true,
              ),
              /*Wrap(
                spacing: 4.0, // Gap between adjacent chips.
                runSpacing: 4.0, // Gap between lines.
                children: _selectedFiles
                    .map(
                      (file) => Chip(
                        label: Text(file.name),
                        onDeleted: () => removeFile(file),
                      ),
                    )
                    .toList(),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
