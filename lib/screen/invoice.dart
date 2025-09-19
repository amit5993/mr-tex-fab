import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:td/api/constant.dart';
import 'package:td/model/invoice_response.dart';
import 'package:td/presenter/invoice_presenter.dart';
import 'package:td/utils/preference.dart';

import '../model/export_pdf_request.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> implements InvoiceView {
  InvoicePresenter? _presenter;
  List<InvoiceData> list = [];
  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var  search = '';

  var reportId = 0;
  var reportName = '';
  ExportPDFRequest? request;
  var isLong = false;
  var totalBillAmt = 0.0;

  _InvoiceState() {
    _presenter = InvoicePresenter(this);
  }

  @override
  void initState() {
    super.initState();

    reportId = Get.arguments[0];
    reportName = Get.arguments[1];
    request = Get.arguments[2];

    _presenter!.dynamicReport(reportId, page,search, request!);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.dynamicReport(reportId, page, search,request!);
        print('call api');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              // actionBar(context, 'Invoice', true),

              Container(
                //height: MediaQuery.of(context).size.height *0.09,
                height: AppBar().preferredSize.height,
                decoration: const BoxDecoration(
                  color: colorApp,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Visibility(
                          visible: true,
                          child: InkWell(
                              onTap: (() {
                                Get.back();
                              }),
                              child: Image.asset(icBack, height: 25, width: 25))),
                      const SizedBox(
                        width: 20,
                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: /*Image.asset(appIcon, height: 50, width: 50),*/
                              Text(
                            'Invoice',
                            style: heading2(colorWhite),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isLong,
                        child: InkWell(
                          onTap: (() {
                            for (int i = 0; i < list.length; i++) {
                              list[i].isSelected = false;
                            }

                            setState(() {
                              totalBillAmt = 0.0;
                              isLong = false;
                            });
                          }),
                          child: Text(
                            'Cancel',
                            style: heading1(colorWhite),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //Visibility(visible: isBack, child: const SizedBox(width: 25))
                    ],
                  ),
                ),
              ),


              Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  style: bodyText2(colorBlack),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
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
                      _presenter!.dynamicReport(reportId, page, search,request!);
                    });
                  },
                ),
              ),

              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = list[i];
                      return GestureDetector(
                        // onLongPress: () {
                        //   setState(() {
                        //     if(!isLong) {
                        //       isLong = true;
                        //       data.isSelected = true;
                        //       totalBillAmt = data.billAmt!;
                        //     }
                        //   });
                        // },
                        onTap: (() {
                            setState(() {
                              if (data.isSelected) {
                                data.isSelected = false;
                              } else {
                                data.isSelected = true;
                              }

                              totalBillAmt = 0.0;
                              for (int i = 0; i < list.length; i++) {
                                if(list[i].isSelected) {
                                  totalBillAmt += list[i].billAmt!;
                                }
                              }

                              var count = list.where((c) => c.isSelected == true).length;

                              if (count > 0) {
                                isLong = true;
                              } else {
                                isLong = false;
                              }

                            });
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(visible: i == 0, child: verticalView()),
                            divider(),
                            Container(
                              color: data.isSelected ? colorApp.withOpacity(0.1) : colorWhite,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: HtmlWidget(
                                        data.content!,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (() {
                                        if (data.value!.contains('.jpg') ||
                                            data.value!.contains('.png') ||
                                            data.value!.contains('.jpeg') ||
                                            data.value!.contains('.JPG') ||
                                            data.value!.contains('.PNG') ||
                                            data.value!.contains('.JPEG')) {
                                          if (PreferenceData.getFtpUrl().isNotEmpty) {
                                            var url = PreferenceData.getFtpUrl() + data.value!;
                                            print(url);
                                            Get.toNamed('/image_viewer', arguments: [reportName, url]);
                                          }
                                        } else if (data.value!.contains('.pdf') || data.value!.contains('.PDF')) {
                                          print('pdf');
                                          // var r = "{\"${data.key}\":[${data.value}]}";
                                          var pdfUrl = PreferenceData.getFtpUrl() + data.value!;
                                          Get.toNamed('/pdf_viewer', arguments: [reportId, reportName, request, pdfUrl]);
                                        } else {
                                          var r = "{\"${data.key}\":[${data.value}]}";
                                          // var pdfUrl = Constant.pdfUrl + data.value!;
                                          Get.toNamed('/pdf_viewer', arguments: [reportId, reportName, request, '', r]);
                                        }
                                      }),
                                      child: Image.asset(
                                        icPDF,
                                        color: colorRed,
                                        height: 35,
                                        width: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            divider(),
                            verticalView()
                          ],
                        ),
                      );
                    }),
              ),

              Visibility(
                visible: isLong,
                child: Column(
                  children: [
                    divider(),
                    Visibility(
                      visible: totalBillAmt > 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: colorWhite,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: /*Image.asset(appIcon, height: 50, width: 50),*/
                                      Text(
                                    'Total Bill Amount',
                                    style: heading1(colorBlack),
                                  ),
                                ),
                              ),
                              Text(
                                totalBillAmt.toString(),
                                style: heading2(colorBlack),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              //Visibility(visible: isBack, child: const SizedBox(width: 25))
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() {
                        var allValue = '';
                        var key = '';
                        for (int i = 0; i < list.length; i++) {
                          if (list[i].isSelected) {
                            if (allValue.isEmpty) {
                              allValue = list[i].value!;
                            } else {
                              allValue += ', ${list[i].value!}';
                            }
                          }
                          key = list[i].key!;
                        }

                        var r = "{\"$key\":[$allValue]}";
                        // var pdfUrl = Constant.pdfUrl + data.value!;
                        Get.toNamed('/pdf_viewer', arguments: [reportId, reportName, request, '', r]);
                      }),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                          colorGradient1,
                          colorGradient2,
                          //colorWhite,
                        ])),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                              child: Text(
                            'View Report',
                            style: heading2(colorWhite),
                          )),
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

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onGetDynamicReportSuccess(InvoiceResponse data) {
    if (data.success!) {
      var newList = data.value!;
      if (page == 0) {
        list.clear();
      }
      setState(() {
        list.addAll(newList);
      });
    } else {
      page--;
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
