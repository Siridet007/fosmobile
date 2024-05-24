// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fos_mobile_v1/model/model.dart';
import 'package:fos_mobile_v1/page/purchasepage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InformationPurchasePage extends StatefulWidget {
  const InformationPurchasePage(
      {super.key,
      this.prnum,
      this.prdate,
      this.reqby,
      this.dept,
      this.fordept,
      this.purby,
      this.forprocode,
      this.forproname,
      this.remark,
      this.budget,
      this.used,
      this.addi,
      this.remain,
      this.prorder,
      this.usercode,
      this.tab});
  final String? prnum;
  final String? prdate;
  final String? reqby;
  final String? dept;
  final String? fordept;
  final String? purby;
  final String? forprocode;
  final String? forproname;
  final String? remark;
  final String? budget;
  final String? used;
  final String? addi;
  final String? remain;
  final String? prorder;
  final String? usercode;
  final String? tab;

  @override
  State<InformationPurchasePage> createState() =>
      _InformationPurchasePageState();
}

class _InformationPurchasePageState extends State<InformationPurchasePage> {
  TextEditingController description = TextEditingController();
  TextEditingController remark = TextEditingController();
  double? width;
  double? height;
  String? prnum;
  String? prdate;
  String? reqby;
  String? dept;
  String? fordept;
  String? purby;
  String? forprocode;
  String? forproname;
  String? budget;
  String? amount;
  String? used;
  String? addi;
  String? remain;
  String? prorder;
  bool budgetCheck = false;
  var takePrnum;
  var takeUsercode;
  var takeProrder;

  var takeItemno;

  var takeinvencode;
  var takeqty;

  List<GetApproveDetail>? approveDetailList = [];
  List<GetProject>? projectList = [];
  TextEditingController ccController = TextEditingController();
  TextEditingController msController = TextEditingController();
  TextEditingController quantity = TextEditingController();

  int pageindex = 0;
  double fontsize = 14.0;

  List<PopupMenuItem<String>> buildPopupMenuItems() {
    List<PopupMenuItem<String>> items = [
      const PopupMenuItem(
        value: '1',
        child: Text('HOLD'),
      ),
      const PopupMenuItem(
        value: '2',
        child: Text('HOLD ALL'),
      ),
      const PopupMenuItem(
        value: '3',
        child: Text('UNHOLD'),
      ),
      const PopupMenuItem(
        value: '4',
        child: Text('UNHOLD ALL'),
      ),
    ];

    // Filter the items based on the condition
    if (approveDetailList!.first.hold == 'H') {
      items = items
          .where((item) => item.value == '3' || item.value == '4')
          .toList();
    }
    return items;
  }

  Future<List<GetApproveDetail>?> getApproveDetail(appr, prnum) async {
    FormData formData = FormData.fromMap(
      {"mode": appr, "prnum": prnum},
    );

    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=$appr&prnum=$prnum";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(response.data);
    var result = GetApproveDetail.fromJsonList(response.data);
    return result;
  }

  Future<List<GetProject>?> getProject(code) async {
    FormData formData = FormData.fromMap(
      {"mode": "projectAmount", "forprojects_code": code},
    );

    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=projectAmount&forprojects_code=$code";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    //print(response.data);
    var result = GetProject.fromJsonList(response.data);
    return result;
  }

  Future<List<GetApproveDetail>?> appproveData(prnum, usercode, prorder) async {
    FormData formData = FormData.fromMap(
      {
        "mode": "Approve",
        "prnum": prnum,
        "usercode": usercode,
        "prorder": prorder
      },
    );
    String domain =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=Approve&prnum=$prnum&usercode=$usercode&prorder=$prorder";
    var result;
    try {
      Response response = await Dio().post(domain, data: formData);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future<List<GetApproveDetail>?> disappproveData(
      prnum, usercode, prorder) async {
    FormData formData = FormData.fromMap(
      {
        "mode": "DisApprove",
        "prnum": prnum,
        "usercode": usercode,
        "prorder": prorder
      },
    );
    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=DisApprove&prnum=$prnum&usercode=$usercode&prorder=$prorder";
    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future<List<GetApproveDetail>?> unappproveData(
      prnum, usercode, prorder) async {
    FormData formData = FormData.fromMap(
      {
        "mode": "UnApprove",
        "prnum": prnum,
        "usercode": usercode,
        "prorder": prorder
      },
    );
    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=UnApprove&prnum=$prnum&usercode=$usercode&prorder=$prorder";
    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future<List<GetApproveDetail>?> editData(prnum, invencode, qty) async {
    FormData formData = FormData.fromMap(
      {
        "mode": "edit_qty_pr",
        "prnum": prnum,
        "invcode": invencode,
        "qty_edit": qty
      },
    );
    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=edit_qty_pr&prnum=$prnum&invcode=$invencode&qty_edit=$qty";
    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI, data: formData);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future<List<GetApproveDetail>?> holdData(prnum, usercode, itemno) async {
    FormData formData = FormData.fromMap(
      {"mode": "Hold", "prnum": prnum, "usercode": usercode, "itemno": itemno},
    );
    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=Hold&prnum=$prnum&usercode=$usercode&itemno=$itemno";
    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI, data: formData);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future<List<GetApproveDetail>?> holdAllData(prnum) async {
    FormData formData = FormData.fromMap(
      {
        "mode": "HoldAll",
        "prnum": prnum,
      },
    );
    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=HoldAll&prnum=$prnum";
    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI, data: formData);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future<List<GetApproveDetail>?> unHoldData(prnum, usercode, itemno) async {
    FormData formData = FormData.fromMap(
      {
        "mode": "Unhold",
        "prnum": prnum,
        "usercode": usercode,
        "itemno": itemno
      },
    );
    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=Unhold&prnum=$prnum&usercode=$usercode&itemno=$itemno";
    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future<List<GetApproveDetail>?> unHoldAllData(prnum, usercode) async {
    FormData formData = FormData.fromMap(
      {"mode": "UnholdAll", "prnum": prnum, "usercode": usercode},
    );
    String domain2 =
        "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=UnholdAll&prnum=$prnum&usercode=$usercode";
    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI);
      result = GetApproveDetail.fromJsonList(response.data);
    } catch (e) {
      print('Error $e');
    }
    return result;
  }

  Future holdFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Hold?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  print('$takePrnum $takeUsercode $takeItemno');
                  holdData(takePrnum, takeUsercode, takeItemno);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PurchasePage(usercode: widget.usercode),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Future holdAllFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Hold All?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  holdAllData(takePrnum);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PurchasePage(usercode: widget.usercode),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Future unHoldFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Unhold?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  unHoldData(takePrnum, takeUsercode, takeItemno);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PurchasePage(usercode: widget.usercode),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Future unHoldAllFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Unhold All?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  unHoldAllData(takePrnum, takeUsercode);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PurchasePage(usercode: widget.usercode),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Future approveFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Approve?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  print('$takePrnum  $takeUsercode  $takeProrder');
                  appproveData(takePrnum, takeUsercode, takeProrder);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PurchasePage(usercode: widget.usercode),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Future disFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Disapprove?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  print('$takePrnum  $takeUsercode  $takeProrder');
                  disappproveData(takePrnum, takeUsercode, takeProrder);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PurchasePage(usercode: widget.usercode),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Future unFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Unapprove?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  print('$takePrnum  $takeUsercode  $takeProrder');
                  unappproveData(takePrnum, takeUsercode, takeProrder);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PurchasePage(usercode: widget.usercode),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  /*Future clarifyFuture(BuildContext context) => showDialog(
        useRootNavigator: false,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          scrollable: true,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: SizedBox(
            height: height! * .5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('CC : '),
                    Container(
                      width: width! * .58,
                      height: 50,
                      color: Colors.white,
                      child: TextField(
                        controller: ccController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          labelText: 'ชื่อหรือรหัส',
                          labelStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'ถ้าต้องการให้ส่งเมล์ถามตอบให้พิมพ์คำถาม \nถ้าไม่ใส่จะเป็นการให้โทรมาชี้แจง',
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  'MESSAGE',
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  width: width! * .8,
                  color: Colors.white,
                  child: TextField(
                    controller: msController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    minLines: 8,
                    maxLines: 8,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );*/

  /* Future editFuture(BuildContext context) => showDialog(
        useRootNavigator: false,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
          scrollable: true,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(59, 173, 173, 1),
                ),
                child: const Icon(Icons.question_mark),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: SizedBox(
            height: height! * .2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: width! * .15,
                      child: const Text(
                        'Code : ',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const Text('F01192'),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: [
                    SizedBox(
                      width: width! * .15,
                      child: const Text(
                        'Name : ',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Text('First ศิริเดช'),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width! * .15,
                      child: const Text(
                        'Qty : ',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                    Container(
                      width: width! * .2,
                      height: height! * .06,
                      color: Colors.white,
                      alignment: Alignment.centerRight,
                      child: TextField(
                        controller: quantity,
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  //editData(prnum, takeinvencode, quantity);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(59, 173, 173, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );*/

  @override
  void initState() {
    super.initState();
    print(widget.tab);
    prnum = widget.prnum;
    prdate = widget.prdate;
    reqby = widget.reqby;
    dept = widget.dept;
    fordept = widget.fordept;
    purby = widget.purby;
    forprocode = widget.forprocode;
    forproname = widget.forproname;
    budget = widget.budget;
    prorder = widget.prorder;
    takePrnum = prnum;
    takeProrder = prorder;
    takeUsercode = widget.usercode;
    if (budget == "Y") {
      budgetCheck = true;
      getProject(forprocode).then((value) {
        setState(() {
          projectList = value;
          amount = projectList!.first.projectAmount;
          used = projectList!.first.projectUsed;
          remain = projectList!.first.balance;
          addi = projectList!.first.additional;
        });
      });
    } else {
      budgetCheck = false;
    }

    remark.text = widget.remark!;
    String? app;
    if (widget.tab == '3') {
      app = 'approveDetailToday';
    } else {
      app = 'approveDetail';
    }
    getApproveDetail(app, prnum).then((value) {
      setState(() {
        approveDetailList = value;
        quantity.text = approveDetailList!.first.prqu!;
        takeItemno = approveDetailList!.first.itemno;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if(width! < 330){
      fontsize = 14;
    }else{
      fontsize = 16.0;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(59, 173, 173, 1),
        title: const Text(
          'Details',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        actions: [
          approveDetailList!.isEmpty
              ? Container()
              : widget.tab == '3'
                  ? Container()
                  : PopupMenuButton(
                      icon: const Icon(Icons.h_plus_mobiledata),
                      tooltip: 'Status',
                      color: Colors.cyan[100],
                      onSelected: (value) {
                        if (value == '1') {
                          holdFuture(context);
                        } else if (value == '2') {
                          holdAllFuture(context);
                        } else if (value == '3') {
                          unHoldFuture(context);
                        } else if (value == '4') {
                          unHoldAllFuture(context);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: '1',
                            child: Text('HOLD'),
                          ),
                          const PopupMenuItem(
                            value: '2',
                            child: Text('HOLD ALL'),
                          ),
                          const PopupMenuItem(
                            value: '3',
                            child: Text('UNHOLD'),
                          ),
                          const PopupMenuItem(
                            value: '4',
                            child: Text('UNHOLD ALL'),
                          ),
                        ];
                      },
                    ),
          approveDetailList!.isEmpty
              ? Container()
              : widget.tab == '3'
                  ? Container()
                  : PopupMenuButton(
                      icon: const Icon(Icons.check),
                      tooltip: 'Approve',
                      color: Colors.cyan[100],
                      onSelected: (value) {
                        if (value == '1') {
                          approveFuture(context);
                        } else if (value == '2') {
                          disFuture(context);
                        } else if (value == '3') {
                          unFuture(context);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: '1',
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                fontFamily: 'en',
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: '2',
                            child: Text(
                              'Disapprove',
                              style: TextStyle(
                                fontFamily: 'en',
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: '3',
                            child: Text(
                              'Unapprove',
                              style: TextStyle(
                                fontFamily: 'en',
                              ),
                            ),
                          ),
                        ];
                      },
                    ),
        ],
      ),
      body: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              color: const Color.fromRGBO(179, 229, 229, 1),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width! * .55,
                        child: Row(
                          children: [
                            SizedBox(
                              width: width! * .31,
                              child: Text(
                                'PR.No. : ',
                                style: TextStyle(
                                  fontSize: fontsize,
                                  color: Colors.amber[700],
                                ),
                              ),
                            ),
                            Text(
                              prnum!,
                              style: TextStyle(fontSize: fontsize),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Date : ',
                            style: TextStyle(
                              fontSize: fontsize,
                              color: Colors.brown,
                            ),
                          ),
                          Text(
                            prdate!,
                            style: TextStyle(fontSize: fontsize),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width! * .31,
                        child: Text(
                          'Requested By : ',
                          style:
                              TextStyle(fontSize: fontsize, color: Colors.blueGrey),
                        ),
                      ),
                      Text(
                        reqby!,
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width! * .31,
                        child: Text(
                          'Department : ',
                          style:
                              TextStyle(fontSize: fontsize, color: Colors.cyan[800]),
                        ),
                      ),
                      Text(
                        dept!,
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width! * .31,
                        child: Text(
                          'For Department : ',
                          style: TextStyle(fontSize: fontsize, color: Colors.blue),
                        ),
                      ),
                      Text(
                        fordept!,
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width! * .31,
                        child: Text(
                          'Purchase By : ',
                          style: TextStyle(
                              fontSize: fontsize, color: Colors.deepOrange[400]),
                        ),
                      ),
                      Text(
                        purby!,
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width! * .31,
                        child: Text(
                          'For Project : ',
                          style:
                              TextStyle(fontSize: fontsize, color: Colors.deepPurple),
                        ),
                      ),
                      Text(
                        '${forprocode!} ${forproname!}',
                        style: TextStyle(fontSize: fontsize),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: width! < 330 ? height! * .64 : height! * .7,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: approveDetailList!.isEmpty
                  ? Container(
                      child: LoadingAnimationWidget.hexagonDots(
                          color: const Color.fromRGBO(59, 173, 173, 1),
                          size: 200),
                    )
                  : ListView.builder(
                      itemCount: approveDetailList!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: width!,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            color: approveDetailList![index].hold == 'H'
                                ? Colors.yellow[200]
                                : Colors.white,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  pageindex = index;
                                  quantity.text =
                                      approveDetailList![index].prqu!;
                                  takeItemno = approveDetailList![index].itemno;
                                });
                              },
                              child: Container(
                                width: width!,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: pageindex == index
                                          ? Colors.red
                                          : Colors.black,
                                      width: pageindex == index ? 3 : 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width! * .17,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Item : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .4,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Code : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.brown),
                                              ),
                                              Text(
                                                approveDetailList![index]
                                                    .prinvcode!,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: width! * .17,
                                        ),
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.indigo),
                                              ),
                                              SizedBox(
                                                //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                width: width! * .62,
                                                child: Text(
                                                  approveDetailList![index]
                                                      .prinvname!,
                                                  style: TextStyle(
                                                      fontSize: fontsize),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: width! * .17,
                                        ),
                                        SizedBox(
                                          width: width! * .3,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Price : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                approveDetailList![index]
                                                    .prunitpr!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .2,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Qty : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                approveDetailList![index].prqu!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .2,
                                          child: Row(
                                            children: [
                                              Text(
                                                'DL : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.yellow[700]),
                                              ),
                                              Text(
                                                '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: width! * .17,
                                        ),
                                        SizedBox(
                                          width: width! * .3,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Total : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.orange),
                                              ),
                                              Text(
                                                approveDetailList![index]
                                                    .total!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .2,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Cur : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.pink),
                                              ),
                                              Text(
                                                approveDetailList![index]
                                                    .curren!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .2,
                                          child: Row(
                                            children: [
                                              Text(
                                                'DA : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.teal),
                                              ),
                                              Text(
                                                '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: width! * .17,
                                        ),
                                        SizedBox(
                                          width: width! * .3,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Unit : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.deepPurple),
                                              ),
                                              Text(
                                                approveDetailList![index]
                                                    .prunit!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .2,
                                          child: Row(
                                            children: [
                                              Text(
                                                'H : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.indigo),
                                              ),
                                              Text(
                                                approveDetailList![index].hold!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .2,
                                          child: Row(
                                            children: [
                                              Text(
                                                'M : ',
                                                style: TextStyle(
                                                    fontSize: fontsize,
                                                    color: Colors.deepPurple),
                                              ),
                                              Text(
                                                approveDetailList![index].mark!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: fontsize),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: approveDetailList!.isEmpty
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color.fromRGBO(179, 229, 229, 1),
                      content: SizedBox(
                        height: budgetCheck ? (height! * .65) : (height! * .48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width! * .17,
                              child: Text(
                                'Remark',
                                style: TextStyle(
                                  fontSize: fontsize,
                                ),
                              ),
                            ),
                            Container(
                              width: width! * .75,
                              height: height! * .28,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(remark.text),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            budgetCheck
                                ? Column(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width! * .23,
                                              color: const Color.fromRGBO(
                                                  179, 229, 229, 1),
                                              child: Text(
                                                'Budget : ',
                                                style: TextStyle(fontSize: fontsize),
                                              ),
                                            ),
                                            Text(
                                              amount!,
                                              style:
                                                  TextStyle(fontSize: fontsize),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Container(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width! * .23,
                                              color: const Color.fromRGBO(
                                                  179, 229, 229, 1),
                                              child: Text(
                                                'Used : ',
                                                style: TextStyle(fontSize: fontsize),
                                              ),
                                            ),
                                            Text(
                                              used!,
                                              style:
                                                  TextStyle(fontSize: fontsize),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Container(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width! * .23,
                                              color: const Color.fromRGBO(
                                                  179, 229, 229, 1),
                                              child: Text(
                                                'Remaining : ',
                                                style: TextStyle(fontSize: fontsize),
                                              ),
                                            ),
                                            Text(
                                              remain!,
                                              style:
                                                  TextStyle(fontSize: fontsize),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Container(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width! * .23,
                                              color: const Color.fromRGBO(
                                                  179, 229, 229, 1),
                                              child: Text(
                                                'Additional : ',
                                                style: TextStyle(fontSize: fontsize),
                                              ),
                                            ),
                                            Text(
                                              addi!,
                                              style:
                                                  TextStyle(fontSize: fontsize),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  )
                                : Container(),
                            Container(
                              width: width!,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    width: width! * .23,
                                    color:
                                        const Color.fromRGBO(179, 229, 229, 1),
                                    child: Text(
                                      'Subtotal : ',
                                      style: TextStyle(fontSize: fontsize),
                                    ),
                                  ),
                                  Text(
                                    approveDetailList!.first.prsubt2!,
                                    style: TextStyle(fontSize: fontsize),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            Container(
                              width: width!,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    width: width! * .23,
                                    color:
                                        const Color.fromRGBO(179, 229, 229, 1),
                                    child: Text(
                                      'Discount : ',
                                      style: TextStyle(fontSize: fontsize),
                                    ),
                                  ),
                                  Text(
                                    approveDetailList!.first.prdis2!,
                                    style: TextStyle(fontSize: fontsize),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            Container(
                              width: width!,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    width: width! * .23,
                                    color:
                                        const Color.fromRGBO(179, 229, 229, 1),
                                    child: Text(
                                      'Net Total : ',
                                      style: TextStyle(fontSize: fontsize),
                                    ),
                                  ),
                                  Text(
                                    approveDetailList!.first.pramount2!,
                                    style: TextStyle(fontSize: fontsize),
                                  ),
                                ],
                              ),
                            ),
                            const Divider()
                          ],
                        ),
                      ),
                      actions: [
                        Container(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                              (states) => const Color.fromRGBO(59, 173, 173, 1),
                            )),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
              tooltip: 'Details',
              backgroundColor: const Color.fromRGBO(59, 173, 173, 1),
              child: const Icon(Icons.article),
            ),
    );
  }
}
