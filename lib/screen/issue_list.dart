import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/model/common_response.dart';
import 'package:td/model/issue_entry_response.dart';

import '../common/common_search_bar.dart';
import '../model/export_pdf_request.dart';
import '../model/filter_response.dart';
import '../model/order_list_response.dart';
import '../presenter/issue_list_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import 'package:intl/intl.dart';

class IssueList extends StatefulWidget {
  const IssueList({super.key});

  @override
  State<IssueList> createState() => _IssueListState();
}

class _IssueListState extends State<IssueList> implements IssueListView {
  IssueListPresenter? _presenter;

  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  var deletePosition = -1;

  List<IssueData> list = [];

  FilterData? filterData;

  _IssueListState() {
    _presenter = IssueListPresenter(this);
  }

  //todo
  //edit and delete same value pass
  //insert  id = 0 SerId = 1st listing id

  @override
  void initState() {
    super.initState();

    filterData = Get.arguments;

    _presenter!.getIssueList(filterData!.id!, page, '');

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getIssueList(filterData!.id!, page, search);
        print('call api');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorBG,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var data = await Get.toNamed('/add_issue', arguments: [filterData]);
              if (data != null) {
                if (data) {
                  page = 0;
                  search = '';
                  list = [];
                  _presenter!.getIssueList(filterData!.id!, page, search);
                }
              }
            },
            backgroundColor: colorApp,
            child: const Icon(
              Icons.add,
              color: colorWhite,
            ),
          ),
          body: Column(
            children: [
              actionBar(context, filterData!.name!, true),
              CommonSearchBar(
                onSearchChanged: (string) {
                  setState(() {
                    search = string;
                    page = 0;
                    list.clear();
                    _presenter!.getIssueList(filterData!.id!, page, search);
                  });
                },
                labelStyle: bodyText2(colorGray),
                inputStyle: heading1(colorText),
              ),
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = list[i];
                      return listCell(data, i);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listCell(IssueData data, int i) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: const BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$sVoucherNo : ${data.vno!}',
                            style: heading2(colorApp),
                          ),
                          Text(
                            //data.date!,
                            DateFormat('dd/MM/yyyy').format(DateTime.parse(data!.date!)),
                            style: bodyText2(colorBlack),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: data.btnChange!,
                      child: InkWell(
                          onTap: (() async {
                            var rData = await Get.toNamed('/add_issue', arguments: [filterData, data]);
                          }),
                          child: iconWidget(colorBox1, icEdit)),
                    ),
                    horizontalViewSmall(),
                    Visibility(
                      visible: data.btnDelete!,
                      child: InkWell(
                          onTap: (() async {
                            deletePosition = i;
                            // deleteDialog(context, data.outwardTrnId!, data.typeId!, 'Issue Entry');
                            customConfirmationDialog(
                                context, 'Confirmation...!', 'Are you sure you want to delete?', 'Yes', 'No',
                                () {
                              _presenter!.deleteIssue(data.outwardTrnId!, data.typeId!, 'Issue Entry');
                            });
                          }),
                          child: iconWidget(const Color(0xFFF44336), icDelete)),
                    ),
                    horizontalViewSmall(),
                    Visibility(
                      visible: data.btnPrint!,
                      child: InkWell(
                          onTap: (() async {
                            if (data.report!.length > 0) {
                              if (data.report!.length == 1) {
                                openReport(data.outwardTrnId.toString(), data.report![0].id!, data.report![0].name!);
                              } else {
                                bottomSheetPrintDialog(data);
                              }
                            } else {
                              toastMassage("Report not found");
                            }
                          }),
                          child: iconWidget(colorBox4, icPrinter)),
                    ),
                  ],
                ),
              ),
              divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Issuer : ',
                      style: bodyText1(colorGray),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.issuer!.isNotEmpty ? data.issuer! : '',
                      style: heading2(colorBlack),
                    ),
                    Visibility(
                      visible: data.transportName!.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalView(),
                          Text(
                            'Transport : ',
                            style: bodyText1(colorGray),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.transportName!.isNotEmpty ? data.transportName! : '',
                            style: heading2(colorBlack),
                          ),
                        ],
                      ),
                    ),
                    verticalView(),
                    Visibility(
                      visible: data.issueItemDetails != null && data.issueItemDetails!.length > 0,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Issuer Items ',
                                  style: bodyText1(colorGray),
                                ),
                              ),
                              Visibility(
                                visible: data.issueItemDetails!.length > 1,
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
                                      fontSize: 12,
                                      fontFamily: "Medium",
                                      color: colorAppLite,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalView(),
                          Container(
                              decoration: const BoxDecoration(
                                  color: colorOffWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.isShow ? data.issueItemDetails!.length : 1,
                                  itemBuilder: (BuildContext context, i) {
                                    var iidData = data.issueItemDetails![i];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 25.0,
                                                height: 25.0,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: colorApp,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    iidData.srno!.toString(),
                                                    style: bodyText1(colorWhite),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  iidData.qualName!,
                                                  style: heading1(colorText),
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: colorBlue,
                                                    borderRadius: BorderRadius.all(Radius.circular(25))),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                                                  child: Text(
                                                    iidData.jobType!,
                                                    style: bodyText1(colorWhite),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                          decoration: const BoxDecoration(
                                              color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(3))),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    itemDetailsView('Qty : ${iidData.qty!.toString()}'),
                                                    itemDetailsView('Rate : ${iidData.rate!.toString()}'),
                                                  ],
                                                ),
                                              ),
                                              const Divider(height: 0.5, thickness: 0.5, color: colorOffWhite),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    itemDetailsView('Amount : ${iidData.amt!.toString()}'),
                                                    itemDetailsView('Unit : ${iidData.unit!.toString()}'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                            visible: (data.issueItemDetails!.length - 1) != i,
                                            child: const Divider(height: 1, thickness: 1, color: colorWhite)),
                                      ],
                                    );
                                  })),
                        ],
                      ),
                    ),
                    // verticalView(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Visibility(
                    //       visible: data.btnChange!,
                    //       child: InkWell(
                    //         onTap: (() async {
                    //           var rData = await Get.toNamed('/add_issue', arguments: [filterData, data]);
                    //           // if (refreshFlag != null) {
                    //           //   if (refreshFlag) {
                    //           //     _presenter!.getAccountMasterList(page, search, filter);
                    //           //   }
                    //           // }
                    //         }),
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width / 4,
                    //           decoration: const BoxDecoration(color: colorBox1, borderRadius: BorderRadius.all(Radius.circular(5))),
                    //           child: Padding(
                    //             padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    //             child: Center(
                    //               child: Text(
                    //                 'Edit',
                    //                 style: bodyText2(colorWhite),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 5),
                    //     Visibility(
                    //       visible: data.btnDelete!,
                    //       child: InkWell(
                    //         onTap: (() async {
                    //           deletePosition = i;
                    //           deleteDialog(context, data.outwardTrnId!, data.typeId!, 'Issue Entry');
                    //         }),
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width / 4,
                    //           decoration: const BoxDecoration(color: colorRed1, borderRadius: BorderRadius.all(Radius.circular(5))),
                    //           child: Padding(
                    //             padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    //             child: Center(
                    //               child: Text(
                    //                 'Delete',
                    //                 style: bodyText2(colorWhite),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 5),
                    //     Visibility(
                    //       visible: data.btnPrint!,
                    //       child: InkWell(
                    //         onTap: (() async {
                    //           if (data.report!.length > 0) {
                    //             if (data.report!.length == 1) {
                    //               openReport(data.outwardTrnId.toString(), data.report![0].id!, data.report![0].name!);
                    //             } else {
                    //               bottomSheetPrintDialog(data);
                    //             }
                    //           } else {
                    //             toastMassage("Report not found");
                    //           }
                    //
                    //           //bottomSheetPrintDialog();
                    //         }),
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width / 4,
                    //           decoration: const BoxDecoration(color: colorBox4, borderRadius: BorderRadius.all(Radius.circular(5))),
                    //           child: Padding(
                    //             padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    //             child: Center(
                    //               child: Text(
                    //                 'Print',
                    //                 style: bodyText2(colorWhite),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // verticalView(),
                  ],
                ),
              ),
            ],
          ),
        ),
        verticalView()
      ],
    );
  }

  Widget iconWidget(Color color, String icon) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: color, //colorBox4,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.2), // Shadow color with transparency
            spreadRadius: 1, // How much the shadow spreads
            blurRadius: 2, // Softness of the shadow
            offset: Offset(0, 1), // Offset in x and y direction
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          icon,
          color: colorWhite,
        ),
      ),
    );
  }

  openReport(String outwardTrnId, int reportId, String reportName) {
    List<String> trnId = [];
    trnId.add(outwardTrnId);

    var r = ExportPDFRequest();
    r.trnId = trnId;

    Get.toNamed('/pdf_viewer', arguments: [reportId, reportName, r]);

    // print(data.report![0].id);
    // print(reportName);
    // print(data.outwardTrnId);
  }

  bottomSheetPrintDialog(IssueData d) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: colorApp,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Reports',
                            style: heading2(colorWhite),
                          ),
                        ),
                        InkWell(
                            onTap: (() {
                              Get.back();
                            }),
                            child: const Icon(
                              Icons.close_outlined,
                              color: colorWhite,
                            )),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: d.report!.length,
                    itemBuilder: (BuildContext context, i) {
                      var issueData = d.report![i];
                      return InkWell(
                        onTap: (() {
                          Get.back();
                          openReport(d.outwardTrnId!.toString(), issueData.id!, issueData.name!);
                        }),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      issueData.name!,
                                      style: bodyText2(colorText),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_right),
                                ],
                              ),
                            ),
                            Visibility(
                                visible: (d.report!.length - 1) != i,
                                child: const Divider(height: 1, thickness: 1, color: colorOffWhite)),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ],
        );
      },
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

  deleteDialog(BuildContext context, int id, int serId, String mode) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colorOffWhite,
            title: const Text("Confirmation", style: TextStyle(fontSize: 18, color: colorBlack, fontFamily: "Medium")),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete?', style: blackTitle1()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "NO",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "YES",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _presenter!.deleteIssue(id, serId, mode);
                },
              )
            ],
          );
        });
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onGetIssueSuccess(IssueEntryResponse data) {
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
  void onDeleteIssue(CommonResponse data) {
    try {
      if (data.success!) {
        if (deletePosition != -1) {
          setState(() {
            list.removeAt(deletePosition);
            deletePosition = -1;
          });
        }
      }
    } on Exception catch (error) {
      print(error);
    }
  }
}
