import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/model/order_list_response.dart';
import 'package:td/presenter/order_list_presenter.dart';

import '../common/common_search_bar.dart';
import '../model/common_response.dart';
import '../model/export_pdf_request.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> implements OrderListView {
  OrderListPresenter? _presenter;

  List<OrderListData> list = [];
  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  var deletePosition = -1;
  var newVarNo = '';
  int newTypeId = 0;
  int dueDays = 0;
  var labelSupplier = 'Supplier';

  _OrderListState() {
    _presenter = OrderListPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    _presenter!.getOrderList(page, '');

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getOrderList(page, search);
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
              var data = await Get.toNamed('/add_order', arguments: [newVarNo, newTypeId, dueDays, labelSupplier]);
              if (data != null) {
                if (data) {
                  page = 0;
                  search = '';
                  list = [];
                  _presenter!.getOrderList(page, search);
                }
              }
            },
            backgroundColor: colorApp,
            child: const Icon(Icons.add, color: colorWhite),
          ),
          body: Column(
            children: [
              CommonSearchBar(
                onSearchChanged: (string) {
                  setState(() {
                    search = string;
                    page = 0;
                    list.clear();
                    _presenter!.getOrderList(page, search);
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

  Widget listCell(OrderListData data, int i) {
    return Column(
      children: [
        //Visibility(visible: i == 0, child: verticalView()),
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
                            'Order No. : ${data.orderNo}',
                            style: heading2(colorApp),
                          ),
                          Text(
                            data.date!,
                            style: bodyText1(colorBlack),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: data.btnChange!,
                      child: InkWell(
                          onTap: (() async {
                            var refreshFlag = await Get.toNamed('/add_order',
                                arguments: [newVarNo, newTypeId, dueDays, labelSupplier, data]);
                            if (refreshFlag != null) {
                              if (refreshFlag) {
                                _presenter!.getOrderList(page, search);
                              }
                            }
                          }),
                          child: iconWidget(colorBox1, icEdit)),
                    ),
                    horizontalViewSmall(),
                    Visibility(
                      visible: data.btnDelete!,
                      child: InkWell(
                          onTap: (() async {
                            deletePosition = i;
                            //deleteDialog(context, data.sordTrnId!, data.typeId!, 'Sale Order');
                            customConfirmationDialog(context, "Confirmation...!",
                                "Are you sure you want to delete this order?", "Yes", "No", () {
                              _presenter!.deleteOrder(data.sordTrnId!, data.typeId!, 'Sale Order');
                            });
                          }),
                          child: iconWidget(const Color(0xFFF44336), icDelete)),
                    ),
                    horizontalViewSmall(),
                    Visibility(
                      visible: data.btnPrint!,
                      child: InkWell(
                          onTap: (() async {
                            List<String> trnId = [];

                            if (data.report!.length > 0) {
                              if (data.report!.length == 1) {
                                openReport(data.sordTrnId.toString(), data.report![0].id!, data.report![0].name!);
                              } else {
                                bottomSheetPrintDialog(data);
                              }
                            } else {
                              toastMassage("Report not found");
                            }

                            // if (data.report!.length > 0) {
                            //   trnId.add(data.sordTrnId.toString());
                            //   var r = ExportPDFRequest();
                            //   r.trnId = trnId;
                            //   Get.toNamed('/pdf_viewer', arguments: [data.report![0].id, data.report![0].name, r]);
                            // } else {
                            //   toastMassage("Report not found");
                            // }
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
                      'Customer : ',
                      style: bodyText1(colorGray),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.customer!,
                      style: heading2(colorBlack),
                    ),
                    verticalView(),
                    Text(
                      '${data.labelSupplier} : ',
                      style: bodyText1(colorGray),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.supplier!,
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
                    Container(
                      decoration:
                          const BoxDecoration(color: colorOffWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Pcs ',
                                    style: bodyText2(colorText),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.tPcs!.toString(),
                                    style: bodyText2(colorText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0.5, thickness: 0.5, color: colorWhite),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Amount ',
                                    style: bodyText2(colorText),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.amount!.toString(),
                                    style: bodyText2(colorText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0.5, thickness: 0.5, color: colorWhite),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Bale ',
                                    style: bodyText2(colorText),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.bale!,
                                    style: bodyText2(colorText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0.5, thickness: 0.5, color: colorWhite),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Status ',
                                    style: bodyText2(colorText),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.status!,
                                    style: bodyText2(colorText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //verticalView(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Visibility(
                    //       visible: data.btnChange!,
                    //       child: InkWell(
                    //         onTap: (() async {
                    //           var refreshFlag = await Get.toNamed('/add_order',
                    //               arguments: [newVarNo, newTypeId, dueDays, labelSupplier, data]);
                    //           if (refreshFlag != null) {
                    //             if (refreshFlag) {
                    //               _presenter!.getOrderList(page, search);
                    //             }
                    //           }
                    //         }),
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width / 4,
                    //           decoration: const BoxDecoration(
                    //               color: colorBox1, borderRadius: BorderRadius.all(Radius.circular(5))),
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
                    //           deleteDialog(context, data.sordTrnId!, data.typeId!, 'Sale Order');
                    //         }),
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width / 4,
                    //           decoration: const BoxDecoration(
                    //               color: colorRed1, borderRadius: BorderRadius.all(Radius.circular(5))),
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
                    //           List<String> trnId = [];
                    //
                    //           if (data.report!.length > 0) {
                    //             if (data.report!.length == 1) {
                    //               openReport(data.sordTrnId.toString(), data.report![0].id!, data.report![0].name!);
                    //             } else {
                    //               bottomSheetPrintDialog(data);
                    //             }
                    //           } else {
                    //             toastMassage("Report not found");
                    //           }
                    //
                    //           // if (data.report!.length > 0) {
                    //           //   trnId.add(data.sordTrnId.toString());
                    //           //   var r = ExportPDFRequest();
                    //           //   r.trnId = trnId;
                    //           //   Get.toNamed('/pdf_viewer', arguments: [data.report![0].id, data.report![0].name, r]);
                    //           // } else {
                    //           //   toastMassage("Report not found");
                    //           // }
                    //         }),
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width / 4,
                    //           decoration: const BoxDecoration(
                    //               color: colorBox4, borderRadius: BorderRadius.all(Radius.circular(5))),
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

  openReport(String sordTrnId, int reportId, String reportName) {
    List<String> trnId = [];
    trnId.add(sordTrnId);

    var r = ExportPDFRequest();
    r.trnId = trnId;

    Get.toNamed('/pdf_viewer', arguments: [reportId, reportName, r]);

    // print(data.report![0].id);
    // print(reportName);
    // print(data.outwardTrnId);
  }

  bottomSheetPrintDialog(OrderListData d) {
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
                          openReport(d.sordTrnId!.toString(), issueData.id!, issueData.name!);
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
                  _presenter!.deleteOrder(id, serId, mode);
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
  void onOrderListSuccess(OrderListResponse data) {
    if (data.success!) {
      if (data.value! != null) {
        if (page == 0) {
          list.clear();
        }
        setState(() {
          list.addAll(data.value!);

          if (list.length > 0) {
            newVarNo = list[0].newVno.toString();
            newTypeId = list[0].newTypeId!;
            dueDays = list[0].dueDays!;
            labelSupplier = list[0].labelSupplier!;
          }
        });
      }
    } else {
      page--;
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  void onOrderDeleteSuccess(CommonResponse data) {
    try {
      if (data.success!) {
        if (deletePosition != -1) {
          setState(() {
            list.removeAt(deletePosition);
            deletePosition = -1;
          });
        }
      } else {
        if (data.resultMessage! != null) {
          toastMassage(data.resultMessage!);
        }
      }
    } on Exception catch (error) {
      print(error);
    }
  }
}
