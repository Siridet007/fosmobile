import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fos_mobile_v1/model/model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  double? width;
  double? height;
  List<GetCustomer>? customerList = [];

  Future<List<GetCustomer>?> getCustomerBusiness() async {
    String domain2 =
        "http://pfclapi.synology.me/~F0143/fosmailpf/business_data.php?select=customer";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(jsonDecode(response.data));
    var result = GetCustomer.fromJsonList(jsonDecode(response.data));
    return result;
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      getCustomerBusiness().then((value) {
        setState(() {
          customerList = value;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCustomerBusiness().then((value) {
      setState(() {
        customerList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Customer',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(175, 163, 118, 1),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: Column(
          children: [
            Container(
              width: width,
              height: height! * .07,
              color: const Color.fromRGBO(127, 136, 136, 1),
              child: Row(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    alignment: Alignment.center,
                    width: width! * .5,
                    child: const Text(
                      'Date',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    alignment: Alignment.center,
                    width: width! * .5,
                    child: const Text(
                      'Person',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            customerList!.isEmpty
                ? Expanded(
                    child: LoadingAnimationWidget.inkDrop(
                      color: const Color.fromRGBO(175, 163, 118, 1),
                      size: 200,
                    ),
                  )
                : Expanded(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child: ListView.builder(
                      itemCount: customerList!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              alignment: Alignment.center,
                              width: width! * .5,
                              height: height! * .06,
                              child: Text(
                                '${customerList![index].sHOWDATE1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              alignment: Alignment.center,
                              width: width! * .5,
                              height: height! * .06,
                              child: Text(
                                '${customerList![index].tOT}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
