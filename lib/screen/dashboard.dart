import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/common/utils.dart';
import 'package:td/model/common_response.dart';
import 'package:td/presenter/dashboard_presenter.dart';

import '../model/dashboard_request.dart';
import '../model/dashboard_response.dart';
import '../model/login_response.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> implements DashboardView {
  DashboardPresenter? _presenter;
  List<DashboardData> list = [];

  _DashboardState() {
    _presenter = DashboardPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var r = DashboardRequest();
    var lData = LoginResponse.fromJson(jsonDecode(PreferenceData.getUserInfo()));

    r.fromDate = lData.value!.fromDate!;
    r.uptoDate = lData.value!.uptoDate!;

    _presenter!.getDashboard(r);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorBG,
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 7,
                  childAspectRatio: 2 / 1.2,
                ),
                itemCount: list.length,
                itemBuilder: (BuildContext ctx, index) {
                  var data = list[index];
                  return InkWell(
                    onTap: (() {
                      Get.toNamed('/dashboard_filter', arguments: data);
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorWhite,
                        border: Border.all(color: data.uiColor, width: 0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 5,
                            decoration: BoxDecoration(
                              color: data.uiColor,
                              borderRadius:
                                  const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                            ),
                          ),
                          horizontalViewSmall(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Text(
                                    data.mode!,
                                    style: bodyText2(colorGray),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    Utils.formatAmount(data.amount!),
                                    style: heading2(colorBlack),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              icAccount,
                              height: 22,
                              width: 22,
                              color: data.uiColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onSuccess(DashboardResponse data) {
    if (data.success!) {
      if (data.value! != null) {
        if (data.value!.isNotEmpty) {
          setState(() {
            list.addAll(data.value!);

            for (int i = 0; i < list.length; i++) {
              if (i % 5 == 0) {
                list[i].uiColor = colorBox1;
              } else if (i % 5 == 1) {
                list[i].uiColor = colorBox2;
              } else if (i % 5 == 2) {
                list[i].uiColor = colorBox4;
              } else if (i % 5 == 3) {
                list[i].uiColor = colorBox3;
              } else if (i % 5 == 4) {
                list[i].uiColor = colorRed1;
              }
            }
          });
        }
      }
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
