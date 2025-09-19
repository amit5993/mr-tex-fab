import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:td/model/order_list_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/account_master_response.dart';
import '../presenter/account_master_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class AccountMaster extends StatefulWidget {
  const AccountMaster({super.key});

  @override
  State<AccountMaster> createState() => _AccountMasterState();
}

class _AccountMasterState extends State<AccountMaster> implements AccountMasterView {
  AccountMasterPresenter? _presenter;

  List<AccountMasterData> list = [];
  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  Map<String, List<String>> filter = HashMap();

  _AccountMasterState() {
    _presenter = AccountMasterPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    _presenter!.getAccountMasterList(page, '', filter);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getAccountMasterList(page, search, filter);
        print('call api');
      }
    });
  }

  void clearFilter() {
    filter = HashMap();
    page = 0;
    search = '';
    _presenter!.getAccountMasterList(page, search, filter);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     var data = await Get.toNamed('/account_filter');
          //
          //     if (data != null) {
          //       filter = data;
          //       page = 0;
          //       search = '';
          //       _presenter!.getAccountMasterList(page, search, filter);
          //     }
          //   },
          //   backgroundColor: colorApp,
          //   child: const Icon(
          //     Icons.filter_list,
          //     color: colorWhite,
          //   ),
          // ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  style: bodyText2(colorBlack),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        color: colorApp,
                      ),
                    ),
                    suffixIcon: const InkWell(
                      child: Icon(Icons.search),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                    hintText: 'Search',
                  ),
                  onChanged: (string) {
                    setState(() {
                      search = string;
                      page = 0;
                      list.clear();
                      _presenter!.getAccountMasterList(page, search, filter);
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = list[i];
                      return Column(
                        children: [
                          // Visibility(visible: i == 0, child: verticalView()),
                          // divider(),
                          Card(
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            color: colorWhite,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data.displayName!,
                                          style: bodyText2(colorApp),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (() async {
                                          var refreshFlag = await Get.toNamed('/add_edit_account_master', arguments: data);
                                          if (refreshFlag != null) {
                                            if (refreshFlag) {
                                              _presenter!.getAccountMasterList(page, search, filter);
                                            }
                                          }
                                        }),
                                        child: Container(
                                          decoration: const BoxDecoration(color: colorBox1, borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                            child: Text(
                                              'Edit',
                                              style: bodyText1(colorWhite),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: (() async {
                                          await Clipboard.setData(ClipboardData(text: copyData(data)));
                                          toastMassage('Copied to your clipboard !');
                                        }),
                                        child: Container(
                                          decoration: const BoxDecoration(color: colorBox4, borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                            child: Text(
                                              'Copy',
                                              style: bodyText1(colorWhite),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalView(),
                                  Visibility(
                                    visible: data.gst!.isNotEmpty,
                                    child: Text(
                                      data.gst!,
                                      style: bodyText2(colorText),
                                    ),
                                  ),
                                  Visibility(visible: data.gst!.isNotEmpty, child: verticalView()),
                                  Visibility(
                                    visible: data.add1!.isNotEmpty && data.add2!.isNotEmpty,
                                    child: Text(
                                      '${data.add1!} ${data.add2!}',
                                      style: bodyText2(colorText),
                                    ),
                                  ),
                                  Visibility(visible: data.add1!.isNotEmpty && data.add2!.isNotEmpty, child: verticalView()),
                                  Text(
                                    'Dhara : ${data.dhara!}',
                                    style: bodyText2(colorText),
                                  ),
                                  verticalView(),
                                  Text(
                                    'CrDays : ${data.crDays!}',
                                    style: bodyText2(colorText),
                                  ),
                                  verticalView(),
                                  Text(
                                    'Remark : ${data.remark!}',
                                    style: bodyText2(colorApp),
                                  ),
                                  dividerAppColor(),
                                  Visibility(
                                    visible: data.mobile!.isNotEmpty,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                icCallBlack,
                                                height: 15,
                                                width: 15,
                                                color: colorApp,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                data.mobile.toString(),
                                                style: bodyText2(colorApp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (() {
                                            _makeWhatsapp(data.mobile!);
                                          }),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                  colorGradient1,
                                                  colorGradient2,
                                                  //colorWhite,
                                                ]),
                                                //color: colorApp,
                                                border: Border.all(color: colorApp),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(50),
                                                )),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    icWhatsappBlack,
                                                    height: 15,
                                                    width: 15,
                                                    color: colorWhite,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'Whatsapp',
                                                    style: bodyText3(colorWhite),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    data.email!,
                                    style: bodyText2(colorApp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // divider(),
                          // verticalView()
                        ],
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (filter.isNotEmpty) {
                            clearFilter();
                          } else {
                            var data = await Get.toNamed('/account_filter');

                            if (data != null) {
                              filter = data;
                              page = 0;
                              search = '';
                              _presenter!.getAccountMasterList(page, search, filter);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(elevation: 6.0, backgroundColor: colorApp, textStyle: const TextStyle(color: colorWhite)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(filter.isNotEmpty ? icFilterClear : icFilter, height: 20, width: 20, color: colorWhite),
                            const SizedBox(width: 10),
                            Text(filter.isNotEmpty ? 'Clear Filter' : 'Filter', style: const TextStyle(color: colorWhite)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          var refreshFlag = await Get.toNamed('/add_edit_account_master');
                          if (refreshFlag != null) {
                            if (refreshFlag) {
                              _presenter!.getAccountMasterList(page, search, filter);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(elevation: 6.0, backgroundColor: colorApp, textStyle: const TextStyle(color: colorWhite)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              icAccount,
                              height: 20,
                              width: 20,
                              color: colorWhite,
                            ),
                            const SizedBox(width: 10),
                            const Text('Add Master', style: TextStyle(color: colorWhite)),
                          ],
                        ),
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

  String copyData(AccountMasterData data) {
    var buffer = StringBuffer();
    buffer.write(data.displayName!);
    buffer.write('\n');
    if (data.gst!.isNotEmpty) {
      buffer.write(data.gst!);
      buffer.write('\n');
    }

    if (data.add1!.isNotEmpty && data.add2!.isNotEmpty) {
      buffer.write('${data.add1!} ${data.add2!}');
      buffer.write('\n');
    }

    buffer.write('Dhara : ${data.dhara!}');
    buffer.write('\n');
    buffer.write('CrDays : ${data.crDays!}');
    buffer.write('\n');
    if (data.remark!.isNotEmpty) {
      buffer.write('Remark : ${data.remark!}');
      buffer.write('\n');
    }

    print(buffer.toString());

    return buffer.toString();
  }

  Future<void> _makeWhatsapp(String phone) async {
    String url = '';

    if (Platform.isAndroid) {
      url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull('Hello')}";
    } else {
      url = "whatsapp://wa.me/$phone/?text=${Uri.encodeFull('Hello')}";
    }
    await launchUrl(Uri.parse(url));
  }

  @override
  void onError(int errorCode) {}

  @override
  void onOrderListSuccess(AccountMasterResponse data) {
    if (data.success!) {
      if (data.value! != null) {
        if (page == 0) {
          list.clear();
        }
        setState(() {
          list.addAll(data.value!);
        });
      }
    } else {
      page--;
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
