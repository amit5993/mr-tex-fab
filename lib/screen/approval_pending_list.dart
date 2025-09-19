import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:td/model/common_response.dart';
import 'package:td/model/issue_entry_response.dart';

import '../common/check_response_code.dart';
import '../model/approval_pending_response.dart';
import '../model/export_pdf_request.dart';
import '../model/filter_response.dart';
import '../model/order_list_response.dart';
import '../presenter/approval_pending_presenter.dart';
import '../presenter/issue_list_presenter.dart';
import '../utils/color.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import 'package:intl/intl.dart';

class ApprovalPendingList extends StatefulWidget {
  const ApprovalPendingList({super.key});

  @override
  State<ApprovalPendingList> createState() => _ApprovalPendingListState();
}

class _ApprovalPendingListState extends State<ApprovalPendingList> implements ApprovalPendingView {
  ApprovalPendingPresenter? _presenter;

  final TextEditingController remarkController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  var mainListPosition = -1;
  var subListPosition = -1;

  List<ApprovalPendingData> list = [];

  FilterData? filterData;
  int typeId = 0;

  _ApprovalPendingListState() {
    _presenter = ApprovalPendingPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    filterData = Get.arguments;
    typeId = filterData!.id!;

    _presenter!.getApprovalPendingList(typeId, page, '');

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getApprovalPendingList(typeId, page, search);
        print('call api');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('dd/MM/yyyy');

    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              actionBar(context, filterData!.name!, true),
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
                      _presenter!.getApprovalPendingList(typeId, page, search);
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
                            elevation: 2,
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            color: colorWhite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '$sVoucherNo : ${data.vno!}',
                                          style: heading2(colorApp),
                                        ),
                                      ),
                                      Text(
                                        data.date!,
                                        // formatter.format(DateTime.parse(data.date!)),
                                        style: bodyText2(colorBlack),
                                      ),
                                    ],
                                  ),
                                ),
                                divider(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      HtmlWidget(
                                        data.content!,
                                      ),
                                      verticalView(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: (() {
                                            setState(() {
                                              //data.isShow != data.isShow;
                                              if (data.isShow) {
                                                data.isShow = false;
                                              } else {
                                                data.isShow = true;
                                              }
                                            });
                                          }),
                                          child: Text(
                                            data.isShow ? 'Hide' : 'Show More',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Medium",
                                              color: colorAppLite,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: data.isShow,
                                        child: Container(
                                            decoration: const BoxDecoration(color: colorOffWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: data.approvalItemDetails == null ? 0 : data.approvalItemDetails!.length,
                                                itemBuilder: (BuildContext context, index) {
                                                  var iidData = data.approvalItemDetails![index];
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(10),
                                                        child: HtmlWidget(
                                                          iidData.content!,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Visibility(
                                                            visible: data.btnApprove!,
                                                            child: InkWell(
                                                              onTap: (() async {
                                                                mainListPosition = i;
                                                                subListPosition = index;
                                                                remarkDialog(context, typeId, iidData.trnId!, iidData.srno!, true);
                                                              }),
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width / 4,
                                                                decoration: const BoxDecoration(
                                                                    color: colorBox1, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Approve',
                                                                      style: bodyText2(colorWhite),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Visibility(
                                                            visible: data.btnCancel!,
                                                            child: InkWell(
                                                              onTap: (() async {
                                                                mainListPosition = i;
                                                                subListPosition = index;
                                                                remarkDialog(context, typeId, iidData.trnId!, iidData.srno!, false);
                                                              }),
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width / 4,
                                                                decoration: const BoxDecoration(
                                                                    color: colorRed1, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: bodyText2(colorWhite),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      verticalView(),
                                                      Visibility(
                                                          visible: (data.approvalItemDetails!.length - 1) != index,
                                                          child: const Divider(height: 0.5, thickness: 0.5, color: colorBlack)),
                                                    ],
                                                  );
                                                })),
                                      ),
                                      verticalView(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: data.btnApprove!,
                                            child: InkWell(
                                              onTap: (() async {
                                                mainListPosition = i;
                                                subListPosition = -1;
                                                remarkDialog(context, typeId, data.trnId!, 0, true);
                                              }),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 4,
                                                decoration: const BoxDecoration(color: colorBox1, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                                  child: Center(
                                                    child: Text(
                                                      'Approve',
                                                      style: bodyText2(colorWhite),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Visibility(
                                            visible: data.btnCancel!,
                                            child: InkWell(
                                              onTap: (() async {
                                                mainListPosition = i;
                                                subListPosition = -1;
                                                remarkDialog(context, typeId, data.trnId!, 0, false);
                                              }),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 4,
                                                decoration: const BoxDecoration(color: colorRed1, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                                  child: Center(
                                                    child: Text(
                                                      'Cancel',
                                                      style: bodyText2(colorWhite),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Visibility(
                                            visible: data.btnPrint!,
                                            child: InkWell(
                                              onTap: (() async {
                                                List<String> trnId = [];

                                                if (data.report!.length > 0) {
                                                  trnId.add(data.trnId.toString());

                                                  var r = ExportPDFRequest();
                                                  r.trnId = trnId;

                                                  Get.toNamed('/pdf_viewer', arguments: [data.report![0].id, data.report![0].name, r]);

                                                  print(data.report![0].id);
                                                  print(data.report![0].name);
                                                  print(data.typeId);
                                                } else {
                                                  toastMassage("Report not found");
                                                }
                                              }),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 4,
                                                decoration: const BoxDecoration(color: colorBox4, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                                  child: Center(
                                                    child: Text(
                                                      'Print',
                                                      style: bodyText2(colorWhite),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      verticalView(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // divider(),
                          // verticalView()
                        ],
                      );
                    }),
              ),
              Container(
                color: colorApp.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                              onTap: (() {
                                mainListPosition = -1;
                                subListPosition = -1;
                                remarkDialog(context, typeId, 0, 0, true);
                              }),
                              child: btnHalf(context, 'Approve All'))),
                      Expanded(
                          child: InkWell(
                              onTap: (() {
                                mainListPosition = -1;
                                subListPosition = -1;
                                remarkDialog(context, typeId, 0, 0, false);
                              }),
                              child: btnHalf(context, 'Cancel All'))),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemDetailsView(String s) {
    return Expanded(
      child: Text(
        s,
        style: bodyText1(colorText),
      ),
    );
  }

  remarkDialog(BuildContext context, int typeId, int trnId, int srno, bool isApprove) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colorOffWhite,
            title: const Text("Enter Description", style: TextStyle(fontSize: 18, color: colorBlack, fontFamily: "Medium")),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  //Text('Are you sure you want to delete?', style: blackTitle1()),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: colorOffWhite,
                        border: Border.all(color: colorGray),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              //focusNode: myFocusNode,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              enabled: true,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              controller: remarkController,
                              autofocus: false,
                              onChanged: (text) {},
                              style: blackTitle(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                /*focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green, width: 5.0),
                ),*/
                                hintText: sRemark,
                                hintStyle: heading1(colorGray),
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                //isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Close",
                  style:heading1(colorApp),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  sSubmit,
                  style:heading1(colorApp),
                ),
                onPressed: () {
                  _presenter!.setApprovalCancel(typeId, trnId, srno, isApprove, remarkController.text.toString());

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void onError(int errorCode) {
    CheckResponseCode.getResponseCode(errorCode, context);
  }

  @override
  void onGetListSuccess(ApprovalPendingResponse data) {
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
        // toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  void onsetApprovalCancelSuccess(CommonResponse data) {
    if (data.success!) {
      toastMassage(data.resultMessage!);
      remarkController.text = '';

      if (mainListPosition == -1 && subListPosition == -1) {
        page = 0;
        list = [];
        _presenter!.getApprovalPendingList(typeId, page, '');
      } else if (subListPosition != -1) {
        if (list.length > subListPosition) {
          list[mainListPosition].approvalItemDetails!.removeAt(subListPosition);
        }
        subListPosition = -1;
        mainListPosition = -1;
      } else {
        if (mainListPosition != -1) {
          if (list.length > mainListPosition) {
            list.removeAt(mainListPosition);
          }
          mainListPosition = -1;
        }
      }

      setState(() {});
    }
  }
}
