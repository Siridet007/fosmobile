import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fos_mobile_v1/model/model.dart';
import 'package:fos_mobile_v1/page/mainpage.dart';
import 'package:fos_mobile_v1/page/purchase/informationpur.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PurchasePage extends StatefulWidget {
  final String? usercode;
  final String? name;
  const PurchasePage({super.key, this.usercode, this.name});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  int purchaseIndex = 0;
  double? width;
  double? height;
  List<GetApproveHead>? approveHeadListAll = [];
  List<GetApproveHead>? approveHeadListToday = [];
  List<GetApproveHead>? approveHeadListApprove = [];
  List<GetHeadTotal>? headList = [];
  int active = 0;
  List<GetMonthTotal>? monthList = [];
  double fontsize = 14.0;

  Future<List<GetApproveHead>?> getApproveHead(flag) async {
    FormData formData = FormData.fromMap(
      {"mode": "approveHead", "flag": flag},
    );

    String domain2 = "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=approveHead&flag=$flag";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(response.data);
    var result = GetApproveHead.fromJsonList(response.data);
    return result;
  }

  Future<List<GetApproveHead>?> getApproveHeadToday() async {
    try {
      FormData formData = FormData.fromMap({"mode": "approveHeadToday"});
      String domain2 = "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=approveHeadToday";
      String urlAPI = domain2;

      Response response = await Dio().post(urlAPI);
      //print(response);

      if (response.data == null) {
        return [
          GetApproveHead(
            prnum: '',
            prdate: '',
            deptname: '',
            prorder: '',
            reqname: '',
            fordeptname: '',
            purby: '',
            forprojects: '',
            depcode: '',
            datediff: '',
            total: '',
            hold: '',
            priceChange: '',
            projectTotal: '',
            montotal: '',
            montotalL: '',
            montotal2: '',
            montotal2L: '',
            montotal3: '',
            montotal3L: '',
            forprojectsCode: '',
            forprojectsName: '',
            prremark: '',
            reqnamecode: '',
            reqnamename: '',
            purbycode: '',
            purbyname: '',
            budget: '',
            dl: '',
            forpro: '',
            totalRec: '',
            totalHold: '',
            totalUhold: '',
            curren: '',
          )
        ];
      } else {
        return GetApproveHead.fromJsonList(response.data);
      }
    } catch (error) {
      print("Error in getApproveHeadToday: $error");
      // Handle the error appropriately (return an empty list or rethrow)
      return [];
    }
  }

  Future<List<GetHeadTotal>?> getHeadTotal() async {
    FormData formData = FormData.fromMap(
      {"mode": "total_hold", "flag": "1"},
    );

    String domain2 = "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=total_hold&flag=1";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    //print(response.data);
    var result = GetHeadTotal.fromJsonList(response.data);
    return result;
  }

  Future<List<GetMonthTotal>?> getMonth() async {
    FormData formData = FormData.fromMap(
      {"mode": "mon_total"},
    );

    String domain2 = "http://pfclapi.synology.me/~F0143/query_purchase_pf/pr.php?mode=mon_total";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(response.data);
    var result = GetMonthTotal.fromJsonList(response.data);
    return result;
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      getApproveHead("1").then((value) {
        setState(() {
          approveHeadListAll = value;
        });
      });
      getHeadTotal().then((value) {
        setState(() {
          headList = value;
          int rec = int.parse(headList!.first.totalRec!);
          int hold = int.parse(headList!.first.totalHold!);
          active = rec - hold;
        });
      });
      getMonth().then((value) {
        setState(() {
          monthList = value;
        });
      });
    });
  }

  Future back(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MainPage(name: widget.name, usercode: widget.usercode),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getApproveHead("1").then((value) {
      setState(() {
        approveHeadListAll = value;
      });
    });
    getHeadTotal().then((value) {
      setState(() {
        headList = value;
        int rec = int.parse(headList!.first.totalRec!);
        int hold = int.parse(headList!.first.totalHold!);
        active = rec - hold;
      });
    });
    getMonth().then((value) {
      setState(() {
        monthList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if(width! < 330){
      fontsize = 12.5;
    }else{
      fontsize = 16.0;
    }
    return WillPopScope(
      onWillPop: () async {
        return await back(context);
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Purchase',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(59, 173, 173, 1),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MainPage(usercode: widget.usercode, name: widget.name),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => _refresh(),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    (headList!.isEmpty || monthList!.isEmpty)
                        ? SizedBox(
                            width: width!,
                            height: height! * .16,
                            child: LoadingAnimationWidget.inkDrop(
                              color: const Color.fromRGBO(59, 173, 173, 1),
                              size: 50,
                            ),
                          )
                        : Container(
                            width: width!,
                            height: height! * .19,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            color: const Color.fromRGBO(179, 229, 229, 1),
                            child: Column(
                              children: [
                                Container(
                                  width: width!,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width! * .3,
                                        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Total : ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                            Text(
                                              headList!.first.totalRec!,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width! * .3,
                                        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Hold : ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              headList!.first.totalHold!,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width! * .29,
                                        //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Active : ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green.shade700,
                                              ),
                                            ),
                                            Text(
                                              active.toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width! * .33,
                                        child: Text(
                                          monthList!.first.montotalL!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        monthList!.first.montotal!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width! * .33,
                                        child: Text(
                                          monthList!.first.montotal2L!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        monthList!.first.montotal2!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width! * .33,
                                        child: Text(
                                          monthList!.first.montotal3L!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        monthList!.first.montotal3!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width! * .33,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: purchaseIndex == 0
                                      ? Colors.black
                                      : const Color.fromRGBO(59, 173, 173, 1),
                                ),
                              ),
                              color: purchaseIndex == 0
                                  ? const Color.fromRGBO(176, 163, 119, 1)
                                  : const Color.fromRGBO(59, 173, 173, 1),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  purchaseIndex = 0;
                                  getApproveHead("1").then((value) {
                                    setState(() {
                                      approveHeadListAll = value;
                                    });
                                  });
                                });
                              },
                              label: Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: purchaseIndex == 0
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              icon: Icon(
                                Icons.all_inbox,
                                color: purchaseIndex == 0
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: width! * .33,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: purchaseIndex == 1
                                  ? const Border(
                                      right: BorderSide(
                                        color: Colors.black,
                                      ),
                                      left: BorderSide(
                                        color: Colors.black,
                                      ),
                                    )
                                  : null,
                              color: purchaseIndex == 1
                                  ? const Color.fromRGBO(176, 163, 119, 1)
                                  : const Color.fromRGBO(59, 173, 173, 1),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  purchaseIndex = 1;
                                  getApproveHead("2").then((value) {
                                    setState(() {
                                      approveHeadListToday = value;
                                    });
                                  });
                                });
                              },
                              label: Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: purchaseIndex == 1
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              icon: Icon(
                                Icons.today,
                                color: purchaseIndex == 1
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: width! * .34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: purchaseIndex == 2
                                      ? Colors.black
                                      : const Color.fromRGBO(59, 173, 173, 1),
                                ),
                              ),
                              color: purchaseIndex == 2
                                  ? const Color.fromRGBO(176, 163, 119, 1)
                                  : const Color.fromRGBO(59, 173, 173, 1),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  purchaseIndex = 2;
                                  getApproveHeadToday().then((value) {
                                    setState(() {
                                      approveHeadListApprove = value;
                                    });
                                  });
                                });
                              },
                              label: Text(
                                'Approved',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: purchaseIndex == 2
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              icon: Icon(
                                Icons.check,
                                color: purchaseIndex == 2
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: purchaseIndex,
                        children: [
                          approveHeadListAll!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: approveHeadListAll!.length,
                                  itemBuilder: (context, index) {
                                    //return tableData[index];
                                    return approveHeadListAll![index]
                                            .prnum!
                                            .isEmpty
                                        ? Container(
                                            width: width,
                                            height: height! * .67,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Have No Data',
                                              style: TextStyle(fontSize: 50),
                                            ),
                                          )
                                        : SizedBox(
                                            width: width!,
                                            height: height! * .2,
                                            child: Card(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              color: approveHeadListAll![index]
                                                          .hold ==
                                                      'H'
                                                  ? Colors.yellow[200]
                                                  : Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          InformationPurchasePage(
                                                        prnum:
                                                            approveHeadListAll![
                                                                    index]
                                                                .prnum,
                                                        prdate:
                                                            approveHeadListAll![
                                                                    index]
                                                                .prdate,
                                                        reqby:
                                                            approveHeadListAll![
                                                                    index]
                                                                .reqname,
                                                        dept:
                                                            approveHeadListAll![
                                                                    index]
                                                                .deptname,
                                                        fordept:
                                                            approveHeadListAll![
                                                                    index]
                                                                .fordeptname,
                                                        purby:
                                                            approveHeadListAll![
                                                                    index]
                                                                .purbyname,
                                                        forprocode:
                                                            approveHeadListAll![
                                                                    index]
                                                                .forprojectsCode,
                                                        forproname:
                                                            approveHeadListAll![
                                                                    index]
                                                                .forprojectsName,
                                                        remark:
                                                            approveHeadListAll![
                                                                    index]
                                                                .prremark,
                                                        budget:
                                                            approveHeadListAll![
                                                                    index]
                                                                .budget,
                                                        used: '',
                                                        addi: '',
                                                        remain: '',
                                                        prorder:
                                                            approveHeadListAll![
                                                                    index]
                                                                .prorder,
                                                        usercode:
                                                            widget.usercode,
                                                        tab: '${purchaseIndex + 1}',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: width!,
                                                  height: height! * .2,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 5, 0, 5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: width! * .17,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Item : ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${index + 1}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'PR.Date. : ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .brown,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListAll![index].prdate}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'PR.NO. : ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: fontsize,
                                                                  color: Colors
                                                                          .amber[
                                                                      700],
                                                                ),
                                                              ),
                                                              Text(
                                                                '${approveHeadListAll![index].prnum}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: fontsize,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Department : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .indigo),
                                                              ),
                                                              Text(
                                                                '${approveHeadListAll![index].deptname}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'For Project : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .deepPurple),
                                                              ),
                                                              Text(
                                                                '${approveHeadListAll![index].forprojectsCode} ${approveHeadListAll![index].forprojectsName}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Total : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListAll![index].total}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Cur. : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .cyan),
                                                              ),
                                                              Text(
                                                                '${approveHeadListAll![index].curren}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Lapsed : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListAll![index].datediff}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'CL : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .pink),
                                                              ),
                                                              Text(
                                                                '${approveHeadListAll![index].dl}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
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
                                )
                              : SizedBox(
                                  width: width,
                                  height: height! * .67,
                                  child: LoadingAnimationWidget.inkDrop(
                                    color:
                                        const Color.fromRGBO(59, 173, 173, 1),
                                    size: 200,
                                  ),
                                ),
                          approveHeadListToday!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: approveHeadListToday!.length,
                                  itemBuilder: (context, index) {
                                    //return tableData[index];
                                    return approveHeadListToday![index]
                                            .prnum!
                                            .isEmpty
                                        ? Container(
                                            width: width,
                                            height: height! * .67,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Have No Data',
                                              style: TextStyle(fontSize: 50),
                                            ),
                                          )
                                        : SizedBox(
                                            width: width!,
                                            height: height! * .2,
                                            child: Card(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              color:
                                                  approveHeadListToday![index]
                                                              .hold ==
                                                          'H'
                                                      ? Colors.yellow[200]
                                                      : Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          InformationPurchasePage(
                                                        prnum:
                                                            approveHeadListToday![
                                                                    index]
                                                                .prnum,
                                                        prdate:
                                                            approveHeadListToday![
                                                                    index]
                                                                .prdate,
                                                        reqby:
                                                            approveHeadListToday![
                                                                    index]
                                                                .reqname,
                                                        dept:
                                                            approveHeadListToday![
                                                                    index]
                                                                .deptname,
                                                        fordept:
                                                            approveHeadListToday![
                                                                    index]
                                                                .fordeptname,
                                                        purby:
                                                            approveHeadListToday![
                                                                    index]
                                                                .purbyname,
                                                        forprocode:
                                                            approveHeadListToday![
                                                                    index]
                                                                .forprojectsCode,
                                                        forproname:
                                                            approveHeadListToday![
                                                                    index]
                                                                .forprojectsName,
                                                        remark:
                                                            approveHeadListToday![
                                                                    index]
                                                                .prremark,
                                                        budget:
                                                            approveHeadListToday![
                                                                    index]
                                                                .budget,
                                                        used: '',
                                                        addi: '',
                                                        remain: '',
                                                        prorder:
                                                            approveHeadListToday![
                                                                    index]
                                                                .prorder,
                                                        usercode:
                                                            widget.usercode,
                                                        tab: '2',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: width!,
                                                  height: height! * .2,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 5, 0, 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
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
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                                Text(
                                                                  '${index + 1}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'PR.Date. : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .brown),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListToday![index].prdate}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'PR.NO. : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                            .amber[
                                                                        700]),
                                                              ),
                                                              Text(
                                                                '${approveHeadListToday![index].prnum}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Department : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .indigo),
                                                              ),
                                                              Text(
                                                                '${approveHeadListToday![index].deptname}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'For Project : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .deepPurple),
                                                              ),
                                                              Text(
                                                                '${approveHeadListToday![index].forprojectsCode} ${approveHeadListToday![index].forprojectsName}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Total : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListToday![index].total}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Cur. : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .cyan),
                                                              ),
                                                              Text(
                                                                '${approveHeadListToday![index].curren}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Lapsed : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListToday![index].datediff}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'CL : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .pink),
                                                              ),
                                                              Text(
                                                                '${approveHeadListToday![index].dl}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
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
                                )
                              : SizedBox(
                                  width: width,
                                  height: height! * .67,
                                  child: LoadingAnimationWidget.inkDrop(
                                    color:
                                        const Color.fromRGBO(59, 173, 173, 1),
                                    size: 200,
                                  ),
                                ),
                          approveHeadListApprove!.isNotEmpty
                              ? ListView.builder(
                                  itemCount: approveHeadListApprove!.length,
                                  itemBuilder: (context, index) {
                                    //return tableData[index];
                                    return approveHeadListApprove![index]
                                            .prnum!
                                            .isEmpty
                                        ? Container(
                                            width: width,
                                            height: height! * .67,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Have No Data',
                                              style: TextStyle(fontSize: 50),
                                            ),
                                          )
                                        : SizedBox(
                                            width: width!,
                                            height: height! * .2,
                                            child: Card(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              color:
                                                  approveHeadListApprove![index]
                                                              .hold ==
                                                          'H'
                                                      ? Colors.yellow[200]
                                                      : Colors.white,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          InformationPurchasePage(
                                                        prnum:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .prnum,
                                                        prdate:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .prdate,
                                                        reqby:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .reqname,
                                                        dept:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .deptname,
                                                        fordept:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .fordeptname,
                                                        purby:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .purbyname,
                                                        forprocode:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .forprojectsCode,
                                                        forproname:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .forprojectsName,
                                                        remark:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .prremark,
                                                        budget:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .budget,
                                                        used: '',
                                                        addi: '',
                                                        remain: '',
                                                        prorder:
                                                            approveHeadListApprove![
                                                                    index]
                                                                .prorder,
                                                        usercode:
                                                            widget.usercode,
                                                        tab: '3',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: width!,
                                                  height: height! * .2,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 5, 0, 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
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
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                                Text(
                                                                  '${index + 1}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'PR.Date. : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .brown),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListApprove![index].prdate}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'PR.NO. : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                            .amber[
                                                                        700]),
                                                              ),
                                                              Text(
                                                                '${approveHeadListApprove![index].prnum}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Department : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .indigo),
                                                              ),
                                                              Text(
                                                                '${approveHeadListApprove![index].deptname}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'For Project : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .deepPurple),
                                                              ),
                                                              Text(
                                                                '${approveHeadListApprove![index].forprojectsCode} ${approveHeadListApprove![index].forprojectsName}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Total : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListApprove![index].total}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Cur. : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .cyan),
                                                              ),
                                                              Text(
                                                                '${approveHeadListApprove![index].curren}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width! * .17,
                                                          ),
                                                          SizedBox(
                                                            width: width! * .4,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  'Lapsed : ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                Text(
                                                                  '${approveHeadListApprove![index].datediff}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          fontsize),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'CL : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        fontsize,
                                                                    color: Colors
                                                                        .pink),
                                                              ),
                                                              Text(
                                                                '${approveHeadListApprove![index].dl}',
                                                                style:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            fontsize),
                                                              ),
                                                            ],
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
                                )
                              : SizedBox(
                                  width: width,
                                  height: height! * .67,
                                  child: LoadingAnimationWidget.inkDrop(
                                    color:
                                        const Color.fromRGBO(59, 173, 173, 1),
                                    size: 200,
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
    );
  }
}
