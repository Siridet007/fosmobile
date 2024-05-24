// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fos_mobile_v1/model/model.dart';
import 'package:fos_mobile_v1/page/mail/writepage.dart';
import 'package:fos_mobile_v1/page/mailpage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InboxPage extends StatefulWidget {
  final String? recivecode;
  final String? receiveBy;
  final String? rname;
  final String? sendcode;
  final String? ninkname;
  final String? firstname;
  final String? mailno;
  final String? subjects;
  final String? priority;
  final String? deadline;
  final String? type;
  final String? flag;
  final String? name;
  final String? username;
  final String? mode;
  const InboxPage({
    super.key,
    this.receiveBy,
    this.rname,
    this.sendcode,
    this.ninkname,
    this.firstname,
    this.mailno,
    this.subjects,
    this.recivecode,
    this.priority,
    this.deadline,
    this.type,
    this.flag,
    this.name,
    this.username,
    this.mode,
  });

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  double? width;
  double? height;
  String amount = '';
  int? ccAmount;
  List<GetMailDetail>? mailDetailList = [];
  List<GetCC>? ccList = [];
  bool ccLoad = false;
  double fontsize = 0.0;

  Future<List<GetMailDetail>?> getMailDetail(mailno) async {
    String domain2 =
        "http://pfclapi.synology.me/~F0143/fosmailpf/mail_data.php?select=open_mail&mailno=$mailno";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(jsonDecode(response.data));
    var result = GetMailDetail.fromJsonList(jsonDecode(response.data));
    return result;
  }

  Future<List<GetCC>?> getMailCC(mailno) async {
    String domain2 =
        "http://pfclapi.synology.me/~F0143/fosmailpf/mail_data.php?select=show_cc&mailno=$mailno";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(jsonDecode(response.data));
    var result;
    if (response.data.trim().isEmpty) {
      result = null;
    } else {
      result = GetCC.fromJsonList(jsonDecode(response.data));
    }
    return result;
  }

  Future back(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MailPage(name: widget.name, username: widget.username),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getMailDetail(widget.mailno).then((value) {
      setState(() {
        mailDetailList = value;
      });
    });
    getMailCC(widget.mailno).then((value) {
      setState(() {
        ccList = value;
        //print(ccList);
        if (ccList == null) {
          ccAmount = 0;
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                ccLoad = true;
              });
            },
          );
        } else {
          ccAmount = ccList!.length;
          ccLoad = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if(width! < 330){
      fontsize = 13.0;
    }else{
      fontsize = 16.0;
    }
    return WillPopScope(
      onWillPop: () async {
        return await back(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'Email',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(24, 167, 188, 1),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MailPage(name: widget.name, username: widget.username),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            widget.mode != '3'
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WritePage(
                            recivecode: widget.recivecode,
                            reciveby: widget.receiveBy,
                            sendcode: widget.sendcode,
                            ninkname: widget.ninkname,
                            firstname: widget.firstname,
                            subjects: widget.subjects,
                            priority: widget.priority,
                            deadline: widget.deadline,
                            type: widget.type,
                            flag: widget.flag,
                            name: widget.name,
                            username: widget.username,
                            detail: mailDetailList!.first.detail,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.reply),
                    tooltip: 'Reply',
                  )
                : Container(),
          ],
        ),
        body: Container(
          color: const Color.fromRGBO(228, 225, 218, 1),
          width: width,
          height: height,
          child: Column(
            children: [
              Container(
                width: width,
                height: height! * .25,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: const Color.fromRGBO(34, 54, 63, 1)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.network(
                            'http://pfclapi.synology.me/~F0143/personpic/${widget.sendcode}-3.jpg',
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'http://pfclapi.synology.me/~F0143/personpic/${widget.sendcode}-3.JPG',
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'http://pfclapi.synology.me/~F0143/personpic/${widget.sendcode}.jpg',
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/notperson.png',
                                        fit: BoxFit.cover,
                                        width: 90,
                                        height: 90,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        SizedBox(
                          width: width! * .13,
                          //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TO : ',
                                style: TextStyle(color: Colors.white,fontSize: fontsize),
                              ),
                              Text(
                                'FROM : ',
                                style: TextStyle(color: Colors.white,fontSize: fontsize),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                'CC : ',
                                style: TextStyle(color: Colors.white,fontSize: fontsize),
                              ),
                              !ccLoad
                                  ? Text(
                                      amount,
                                      style:
                                          TextStyle(color: Colors.white,fontSize: fontsize),
                                    )
                                  : Text(
                                      '$ccAmount',
                                      style:
                                          TextStyle(color: Colors.white,fontSize: fontsize),
                                    ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.receiveBy} ${widget.rname}',
                              style: TextStyle(color: Colors.white,fontSize: fontsize),
                            ),
                            Text(
                              '${widget.sendcode} ${widget.ninkname} ${widget.firstname}',
                              style: TextStyle(color: Colors.white,fontSize: fontsize),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            !ccLoad
                                ? Container(
                                    child: LoadingAnimationWidget.newtonCradle(
                                        color: const Color.fromRGBO(
                                            24, 167, 188, 1),
                                        size: 50),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      height: height! * .138,
                                      width: width! * .55,
                                      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                      child: ccList == null
                                          ? Container()
                                          : ListView.builder(
                                              itemCount: ccList!.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: width! * .05,
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width! * .13,
                                                      child: Text(
                                                        '${ccList![index].recivecode}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Text(
                                                        '${ccList![index].recivename}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                        ),
                        Text(
                          'SUBJECT : ',
                          style: TextStyle(color: Colors.white,fontSize: fontsize),
                        ),
                        Container(
                          width: width! * .48,
                          child: Text(
                            '${widget.subjects}',
                            style: TextStyle(
                              color: Colors.white,fontSize: fontsize
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height! * .61,
                color: const Color.fromRGBO(228, 225, 218, 1),
                //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: mailDetailList!.isEmpty
                    ? Container(
                        child: LoadingAnimationWidget.inkDrop(
                            color: const Color.fromRGBO(24, 167, 188, 1),
                            size: 200),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text('${mailDetailList!.first.detail}'),
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
