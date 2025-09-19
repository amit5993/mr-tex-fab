import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:td/common/utils.dart';
import 'package:td/model/export_pdf_response.dart';
import 'package:td/model/report_by_menu_response.dart';
import 'package:td/presenter/sale_purchase_report_presenter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:td/utils/string.dart';

import '../api/constant.dart';
import '../model/dashboard_filter_response.dart';
import '../model/export_pdf_request.dart';
import '../model/filter_response.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/widget.dart';

class SalePurchaseReport extends StatefulWidget {
  // const SalePurchaseReport({super.key});

  const SalePurchaseReport({Key? key, required this.type, required this.dashboardFilterData}) : super(key: key);

  final String type;
  final DashboardFilterData dashboardFilterData;

  @override
  State<SalePurchaseReport> createState() => _SalePurchaseReportState();
}

class _SalePurchaseReportState extends State<SalePurchaseReport> implements SalePurchaseReportView {
  static const String GROUP1 = 'Group1';
  static const String GROUP2 = 'Group2';
  static const String GROUP3 = 'Group3';
  static const String GROUP4 = 'Group4';

  SalePurchaseReportPresenter? _presenter;
  List<ReportMenuData> list = [];
  List<Filter> filterList = [];
  List<Filter> groupList = [];
  List<Filter> optionList = [];
  List<FilterData> selectedList = [];
  List<String> dateFilterList = [];

  String dateFilter = '';

  // List<DefaultFilter> defaultFilterList = [];
  var reportId = 0;
  var reportName = '';
  var reportMode = '';
  var fromDate = '';
  var toDate = '';
  var isVoucher = false;
  var tag = '';
  var savePath = '';

  String grp1 = '';
  String grp2 = '';
  String grp3 = '';
  String grp4 = '';
  String options = '';

  TextEditingController fromVoucherController = TextEditingController();
  TextEditingController toVoucherController = TextEditingController();

  var dateFormatter = DateFormat('dd/MMM/yyyy');

  double progress = 0;
  bool didDownloadPDF = false;

  _SalePurchaseReportState() {
    _presenter = SalePurchaseReportPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.dashboardFilterData.defaultFilter != null) {
      print(widget.dashboardFilterData.defaultFilter!.length);
    } else {
      print('null');
    }

    dateFilterList.add('Today');
    dateFilterList.add('This Week');
    dateFilterList.add('Last 30 Days');
    dateFilterList.add('This Quarter');
    dateFilterList.add('Financial Year');
    dateFilterList.add('Custom');

    dateFilter = 'Custom';

    _presenter!.getReportByMenu(widget.type);
  }

  onClickFilterListCell(Filter data) async {
    tag = data.tag!;

    List<String> spList = data.spName!.split(',');
    List<String> s = [];
    for (int i = 0; i < spList.length; i++) {
      // if (spList[i].trim().isNotEmpty) {
      s.add(spList[i].trim());
      // }
    }

    // switch (tag) {
    //   case GROUP1:
    //     bottomGroupDialog(GROUP1, s);
    //     break;
    //   case GROUP2:
    //     bottomGroupDialog(GROUP2, s);
    //     break;
    //   case GROUP3:
    //     bottomGroupDialog(GROUP3, s);
    //     break;
    //   case GROUP4:
    //     bottomGroupDialog(GROUP4, s);
    //     break;
    //   default:
    //     openFilterScreen(data);
    // }
  }

  openFilterScreen(Filter data) async {
    tag = data.tag!;

    List<FilterData> filterList =
        await Get.toNamed('/filter_screen', arguments: [data, selectedList]) as List<FilterData>;

    if (filterList != null) {
      /**
       * remove all old data with selected tag
       * */
      List<FilterData> tempList = [];
      for (int i = 0; i < selectedList.length; i++) {
        if (selectedList[i].tag != tag) {
          tempList.add(selectedList[i]);
        }
      }
      selectedList.clear();
      selectedList = tempList;

      /**
       * selected data add in list
       * */
      for (int i = 0; i < filterList.length; i++) {
        if (!selectedList.contains(filterList[i])) {
          filterList[i].tag = tag;
          filterList[i].spName = data.name!;
          selectedList.add(filterList[i]);
        }
      }
      setState(() {});
    }
  }

  void onClickViewReport() {
    List<String> conum = [];
    List<String> custId = [];
    List<String> custGrp = [];
    List<String> suppId = [];
    List<String> suppGrp = [];
    List<String> agentId = [];
    List<String> agentGrp = [];
    List<String> hasteId = [];
    List<String> qualId = [];
    List<String> accountId = [];
    List<String> refId = [];
    List<String> partyGrp = [];
    String mode = '';
    String city = '';
    String designNo = '';

    for (int i = 0; i < selectedList.length; i++) {
      var d = selectedList[i];

      //Tag = "Cust";
      // Tag = "Comp";
      // Tag = "Agent";
      // Tag = "Supp";
      // Tag = "Haste";
      // Tag = "Qual";
      // Tag = "GCust";
      // Tag = "GSupp";
      // Tag = "GAgent";
      // Tag = "GParty";
      // Tag = "Party";
      // Tag = "Book";

      if (d.tag == "Cust") {
        custId.add(d.id.toString());
      } else if (d.tag == "Comp") {
        conum.add(d.id.toString());
      } else if (d.tag == "Agent") {
        agentId.add(d.id.toString());
      } else if (d.tag == "Supp") {
        suppId.add(d.id.toString());
      } else if (d.tag == "Haste") {
        hasteId.add(d.id.toString());
      } else if (d.tag == "Qual") {
        qualId.add(d.id.toString());
      } else if (d.tag == "Party") {
        accountId.add(d.id.toString());
      } else if (d.tag == "GCust") {
        custGrp.add(d.id.toString());
      } else if (d.tag == "GSupp") {
        suppGrp.add(d.id.toString());
      } else if (d.tag == "GAgent") {
        agentGrp.add(d.id.toString());
      } else if (d.tag == "GParty") {
        partyGrp.add(d.id.toString());
      } else if (d.tag == "Book") {
        refId.add(d.id.toString());
      } else if (d.tag == "Mode") {
        if (mode.isEmpty) {
          mode = d.name!;
        } else {
          mode = '$mode,${d.name!}';
        }
      } else if (d.tag == "City") {
        if (city.isEmpty) {
          city = d.name!;
        } else {
          city = '$city,${d.name!}';
        }
      } else if (d.tag == "Dsg") {
        if (designNo.isEmpty) {
          designNo = d.name!;
        } else {
          designNo = '$designNo,${d.name!}';
        }
      }
    }

    options = '';
    int indexGrp1 = groupList.indexWhere((st) => st.tag == GROUP1);
    int indexGrp2 = groupList.indexWhere((st) => st.tag == GROUP2);
    int indexGrp3 = groupList.indexWhere((st) => st.tag == GROUP3);
    int indexGrp4 = groupList.indexWhere((st) => st.tag == GROUP4);
    int indexOptions = optionList.indexWhere((st) => st.tag == 'Options');

    if (indexGrp1 != -1) {
      grp1 = groupList[indexGrp1].selectedName!;
    }
    if (indexGrp2 != -1) {
      grp2 = groupList[indexGrp2].selectedName!;
    }
    if (indexGrp3 != -1) {
      grp3 = groupList[indexGrp3].selectedName!;
    }
    if (indexGrp4 != -1) {
      grp4 = groupList[indexGrp4].selectedName!;
    }
    if (indexOptions != -1) {
      var optionString = optionList[indexOptions].selectedName!;
      if (optionString.isNotEmpty) {
        options = '${optionList[indexOptions].name}; $optionString';
      }
    }

    var r = ExportPDFRequest();
    r.accountId = accountId;
    r.agentGrp = agentGrp;
    r.agentId = agentId;
    r.conum = conum;
    r.custGrp = custGrp;
    r.custId = custId;
    r.hasteId = hasteId;
    r.partyGrp = partyGrp;
    r.qualId = qualId;
    r.refId = refId;
    r.suppGrp = suppGrp;
    r.suppId = suppId;
    r.fromDate = fromDate;
    r.uptoDate = toDate;
    r.frVno = fromVoucherController.text.toString();
    r.toVno = toVoucherController.text.toString();
    r.group1 = grp1;
    r.group2 = grp2;
    r.group3 = grp3;
    r.group4 = grp4;
    r.options = options;
    r.mode = mode;
    r.city = city;
    r.designNo = designNo;

    if (widget.type == Constant.menuInvoiceVoucher || reportMode != 'Normal') {
      Get.toNamed('/invoice', arguments: [reportId, reportName, r]);
    } else {
      Get.toNamed('/pdf_viewer', arguments: [reportId, reportName, r]);
      // _presenter!.getExportPDFFile(reportId, r);
    }
  }

  _selectDate(BuildContext context, bool isFromDate) async {
    dateFilter = 'Custom';

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: isFromDate ? DateTime.now() : DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: colorApp, // <-- SEE HERE
              onPrimary: colorBlack, // <-- SEE HERE
              onSurface: colorBlack, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      if (isFromDate) {
        fromDate = dateFormatter.format(selected!);
      } else {
        toDate = dateFormatter.format(selected!);
      }
    });

    print("----------------");
    print(fromDate);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorBG,
          body: Column(
            children: [
              Visibility(
                  visible: widget.dashboardFilterData.repName != null, child: actionBar(context, widget.type, true)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalView(),

                      reportScrollView(),

                      // verticalViewBig(),
                      // InkWell(
                      //   onTap: (() {
                      //     _openFilterDialog(context);
                      //   }),
                      //   child: Container(
                      //     margin: const EdgeInsets.symmetric(horizontal: 10),
                      //     decoration: const BoxDecoration(
                      //         color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(15),
                      //       child: Row(
                      //         children: [
                      //           Expanded(
                      //             child: Text(
                      //               reportName,
                      //               style: heading1(colorBlack),
                      //             ),
                      //           ),
                      //           horizontalView(),
                      //           const Icon(
                      //             Icons.arrow_drop_down_sharp,
                      //             color: colorText,
                      //             size: 18,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      verticalViewBig(),

                      voucherWidget(),
                      Visibility(visible: isVoucher, child: verticalViewBig()),

                      dateWidget(),
                      verticalViewBig(),

                      filterWidget(),
                      verticalViewBig(),

                      optionWidget(),
                      Visibility(visible: optionList.isNotEmpty, child: verticalViewBig()),

                      groupWidget(),
                      Visibility(visible: groupList.isNotEmpty, child: verticalViewBig()),

                      selectedFilterWidget(),
                      Visibility(visible: selectedList.isNotEmpty, child: verticalViewBig()),
                    ],
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (() {
                  onClickViewReport();

                  // Get.toNamed('/pdf_viewer', arguments: selectedList);
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
                      'Show Report',
                      style: heading2(colorWhite),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget reportScrollView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
      child: list.length > 4
          ? ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Scrollbar(
                child: ListView.builder(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = list[i];
                      return reportListCell(data);
                    }),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list == null ? 0 : list.length,
              itemBuilder: (BuildContext context, i) {
                var data = list[i];
                return reportListCell(data);
              }),
    );
  }

  void _openFilterDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            //padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Select Filter Type',
                    style: heading1(colorBlack),
                  ),
                ),
                divider(),
                verticalViewSmall(),
                ListView.builder(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = list[i];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (() {
                          Get.back();

                          for (int i = 0; i < list.length; i++) {
                            list[i].isSelect = false;
                          }

                          data.isSelect = true;
                          reportId = data.reportId!;
                          reportName = data.repName!;
                          reportMode = data.repMode!;
                          // filterList = data.filter!;
                          // defaultFilterList = data.defaultFilter!;

                          groupFilterList(data.filter!);

                          fromDate = data.fromDate!;
                          toDate = data.toDate!;
                          isVoucher = data.isVoucher!;
                          if (data.ftp!.isNotEmpty) {
                            PreferenceData.setFtpUrl(data.ftp![0].url!);
                          }

                          // checkGroupAvailability(filterList);
                          setState(() {});
                        }),
                        child: Column(
                          children: [
                            Visibility(visible: i == 0, child: verticalView()),
                            Row(
                              children: [
                                horizontalView(),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: checkBoxDecoration(),
                                  child: Visibility(
                                    visible: data.isSelect,
                                    child: Center(
                                      child: Image.asset(
                                        icCheck,
                                        height: 12,
                                        width: 12,
                                        color: colorApp,
                                      ),
                                    ),
                                  ),
                                ),
                                horizontalView(),
                                Text(
                                  data.repName!,
                                  style: bodyText2(colorText),
                                ),
                                horizontalView(),
                              ],
                            ),
                            verticalView(),
                            Visibility(visible: i != (list.length - 1), child: divider()),
                            verticalView()
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget voucherWidget() {
    return Visibility(
      visible: isVoucher,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sVoucherNo,
              style: heading1(colorBlack),
            ),
            verticalView(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration:
                        const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        //focusNode: myFocusNode,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        controller: fromVoucherController,
                        autofocus: false,
                        onChanged: (text) {},
                        style: bodyText2(colorText),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'From Voucher No.',
                          hintStyle: bodyText2(colorGray),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          //isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalView(),
                Expanded(
                  child: Container(
                    decoration:
                        const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        //focusNode: myFocusNode,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        controller: toVoucherController,
                        autofocus: false,
                        onChanged: (text) {},
                        style: bodyText2(colorText),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'To Voucher No.',
                          hintStyle: bodyText2(colorGray),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          //isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dateWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sDate,
            style: heading1(colorBlack),
          ),
          verticalView(),
          // Wrap(
          //   direction: Axis.horizontal,
          //   runSpacing: 5,
          //   children: dateFilterList.map((s) {
          //     final isSelected = dateFilter.contains(s);
          //     return InkWell(
          //       splashColor: Colors.transparent,
          //       highlightColor: Colors.transparent,
          //       onTap: (() {
          //         setState(() {
          //           dateFilter = s;
          //         });
          //       }),
          //       child: Container(
          //         margin: const EdgeInsets.only(right: 5),
          //         decoration: BoxDecoration(
          //             color: isSelected ? colorApp : colorWhite,
          //             borderRadius: const BorderRadius.all(Radius.circular(50))),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //           child: Text(
          //             s,
          //             style: bodyText1(isSelected ? colorWhite : colorText),
          //           ),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),

          Row(
            children: [
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     //margin: const EdgeInsets.symmetric(horizontal: 5),
              //     decoration:
              //         const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
              //     child: Padding(
              //       padding: const EdgeInsets.all(10),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           horizontalViewSmall(),
              //           Expanded(
              //             child: InkWell(
              //               splashColor: Colors.transparent,
              //               highlightColor: Colors.transparent,
              //               onTap: (() {
              //                 _selectDate(context, true);
              //               }),
              //               child: Column(
              //                 children: [
              //                   Text('Choose from date', style: bodyText3(colorGray)),
              //                   Text(
              //                     fromDate,
              //                     style: heading1(colorText),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           horizontalViewSmall(),
              //           Expanded(
              //             child: InkWell(
              //               splashColor: Colors.transparent,
              //               highlightColor: Colors.transparent,
              //               onTap: (() {
              //                 _selectDate(context, false);
              //               }),
              //               child: Column(
              //                 children: [
              //                   Text('Choose to date', style: bodyText3(colorGray)),
              //                   Text(
              //                     toDate,
              //                     style: heading1(colorText),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           horizontalViewSmall(),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Container(
                  //margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration:
                      const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // horizontalViewSmall(),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (() {
                            _selectDate(context, true);
                          }),
                          child: Text(
                            fromDate,
                            style: bodyText2(colorText),
                          ),
                        ),
                        // horizontalViewSmall(),
                      ],
                    ),
                  ),
                ),
              ),
              horizontalViewSmall(),
              Expanded(
                flex: 1,
                child: Container(
                  //margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration:
                      const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // horizontalViewSmall(),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (() {
                            _selectDate(context, false);
                          }),
                          child: Text(
                            toDate,
                            style: bodyText2(colorText),
                          ),
                        ),
                        // horizontalViewSmall(),
                      ],
                    ),
                  ),
                ),
              ),
              horizontalViewSmall(),
              Expanded(
                flex: 1,
                child: Container(
                  //margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration:
                      const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // horizontalViewSmall(),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (() {
                            bottomDateFilterDialog();
                          }),
                          child: Text(
                            dateFilter,
                            style: bodyText2(colorText),
                          ),
                        ),
                        // horizontalViewSmall(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget filterWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sFilter,
            style: heading1(colorBlack),
          ),
          verticalView(),
          Wrap(
            direction: Axis.horizontal,
            runSpacing: 5,
            children: filterList.map((s) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (() {
                        openFilterScreen(s);
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          border: Border.all(color: colorApp, width: 1.2),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Text(
                              s.name!,
                              style: bodyText2(colorText),
                            ),
                          ),
                        ),
                      ))
                ],
              );
            }).toList(),
          ),
          // GridView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 5,
          //       mainAxisSpacing: 5,
          //       childAspectRatio: 4,
          //     ),
          //     itemCount: filterList == null ? 0 : filterList.length,
          //     itemBuilder: (BuildContext context, i) {
          //       var data = filterList[i];
          //       return InkWell(
          //         splashColor: Colors.transparent,
          //         highlightColor: Colors.transparent,
          //         onTap: (() {
          //           openFilterScreen(data);
          //         }),
          //         child: Container(
          //           decoration:
          //           const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
          //           child: Row(
          //             children: [
          //               horizontalView(),
          //               Expanded(
          //                 child: Text(
          //                   data.name!,
          //                   style: bodyText2(colorText),
          //                 ),
          //               ),
          //               horizontalView(),
          //               const Icon(
          //                 Icons.chevron_right,
          //                 color: colorText,
          //                 size: 18,
          //               ),
          //               horizontalView(),
          //             ],
          //           ),
          //         ),
          //       );
          //     })
        ],
      ),
    );
  }

  Widget optionWidget() {
    return Visibility(
      visible: optionList.length > 0,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: optionList == null ? 0 : optionList.length,
          itemBuilder: (BuildContext context, i) {
            var data = optionList[i];
            return optionCell(data);
          }),
    );
  }

  Widget groupWidget() {
    return Visibility(
      visible: groupList.length > 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sGroup,
              style: heading1(colorBlack),
            ),
            verticalView(),
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 4,
                ),
                itemCount: groupList == null ? 0 : groupList.length,
                itemBuilder: (BuildContext context, i) {
                  var data = groupList[i];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: (() {
                      bottomGroupDialog(data, data.dropDownList!);
                    }),
                    child: Container(
                      decoration:
                          const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          horizontalView(),
                          Expanded(
                            child: data.selectedName!.isNotEmpty
                                ? Text(
                                    data.selectedName!,
                                    style: bodyText2(colorText),
                                  )
                                : Text(
                                    'Tap to select',
                                    style: bodyText2(colorLightGray),
                                  ),
                          ),
                          horizontalView(),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: colorText,
                            size: 18,
                          ),
                          horizontalView(),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget selectedFilterWidget() {
    return Visibility(
      visible: selectedList.length > 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sYourFilter,
              style: heading1(colorBlack),
            ),
            verticalView(),
            Container(
              decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedList == null ? 0 : selectedList.length,
                  itemBuilder: (BuildContext context, i) {
                    var data = selectedList[i];
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (() {}),
                      child: Column(
                        children: [
                          Visibility(visible: i == 0, child: verticalView()),
                          Row(
                            children: [
                              horizontalView(),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: colorApp, borderRadius: BorderRadius.all(Radius.circular(25))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Center(
                                      child: Text(
                                        data.tag.toUpperCase(),
                                        style: bodyText3(colorWhite),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              horizontalView(),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  data.name!,
                                  style: bodyText2(colorText),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: (() {
                                  setState(() {
                                    selectedList.removeAt(i);
                                  });
                                }),
                                child: Image.asset(
                                  icDelete,
                                  color: colorGray,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              horizontalView(),
                            ],
                          ),
                          verticalView(),
                          Visibility(visible: i != (selectedList.length - 1), child: divider()),
                          Visibility(visible: i != (selectedList.length - 1), child: verticalView()),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget reportListCell(ReportMenuData data) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: (() {
        for (int i = 0; i < list.length; i++) {
          list[i].isSelect = false;
        }

        data.isSelect = true;
        reportId = data.reportId!;
        reportName = data.repName!;
        reportMode = data.repMode!;
        // filterList = data.filter!;
        // defaultFilterList = data.defaultFilter!;

        groupFilterList(data.filter!);

        fromDate = data.fromDate!;
        toDate = data.toDate!;
        isVoucher = data.isVoucher!;
        if (data.ftp!.isNotEmpty) {
          PreferenceData.setFtpUrl(data.ftp![0].url!);
        }

        // checkGroupAvailability(filterList);
        setState(() {});
      }),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: data.isSelect
                ? BoxDecoration(
                    color: colorApp.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: colorApp),
                  )
                : const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: checkBoxDecoration(),
                    child: Visibility(
                      visible: data.isSelect,
                      child: Center(
                        child: Image.asset(
                          icCheck,
                          height: 12,
                          width: 12,
                          color: colorApp,
                        ),
                      ),
                    ),
                  ),
                  horizontalView(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        data.repName!,
                        overflow: TextOverflow.ellipsis,
                        style: data.isSelect ? heading1(colorApp) : bodyText2(colorBlack),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          divider(),
        ],
      ),
    );
  }

  Widget selectedGroup(Filter data) {
    return Visibility(
      visible: data.spName!.isNotEmpty,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: (() {
          // onClickFilterListCell(t,grpValue);
          bottomGroupDialog(data, data.dropDownList!);
        }),
        child: Container(
          width: MediaQuery.of(context).size.width / 4.3,
          margin: const EdgeInsets.only(left: 1.5, right: 1.5, top: 1, bottom: 10),
          decoration: const BoxDecoration(color: colorApp, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 2, 10),
            child: Row(
              children: [
                Expanded(
                  //padding: const EdgeInsets.all(3.0),
                  child: Text(
                    data.selectedName!,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText1(colorWhite),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: colorWhite,
                  size: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget optionCell(Filter data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name!,
            style: heading1(colorBlack),
          ),
          verticalView(),
          Wrap(
            direction: Axis.horizontal,
            runSpacing: 5,
            children: data.dropDownList!.map((s) {
              // final isSelected = data.selectedName!.contains(s);
              final isSelected = data.selectedName!.split(',').any((item) => item.trim() == s);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (() {
                        if (data.selectedName!.isEmpty) {
                          data.selectedName = s;
                        } else {
                          // if (data.selectedName!.contains(s)) {
                          if (data.selectedName!.split(',').any((item) => item.trim() == s)) {
                            // Remove the string `s` from the selectedName
                            data.selectedName = data.selectedName!.split(',').where((name) => name != s).join(',');
                          } else {
                            // Add the string `s` to the selectedName
                            data.selectedName = '${data.selectedName!},$s';
                          }
                        }

                        setState(() {});
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                            color: isSelected ? colorApp : colorWhite,
                            borderRadius: const BorderRadius.all(Radius.circular(50))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: checkBoxDecoration(),
                                child: Visibility(
                                  visible: isSelected,
                                  child: Center(
                                    child: Image.asset(
                                      icCheck,
                                      height: 12,
                                      width: 12,
                                      color: colorApp,
                                    ),
                                  ),
                                ),
                              ),
                              horizontalView(),
                              Text(
                                s,
                                style: bodyText1(isSelected ? colorWhite : colorText),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bottomGroupDialog(Filter fData, List<String> list) {
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
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            fData.tag!,
                            style: heading1(colorWhite),
                          ),
                        ),
                        InkWell(
                            onTap: (() {
                              Get.back();
                            }),
                            child: const Icon(
                              Icons.close,
                              color: colorWhite,
                            )),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, i) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (() {
                          // switch (title) {
                          //   case GROUP1:
                          //     grp1 = list[i];
                          //     break;
                          //   case GROUP2:
                          //     grp2 = list[i];
                          //     break;
                          //   case GROUP3:
                          //     grp3 = list[i];
                          //     break;
                          //   case GROUP4:
                          //     grp4 = list[i];
                          //     break;
                          // }

                          fData.selectedName = list[i];

                          setState(() {});

                          Get.back();
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                list[i],
                                style: heading1(colorText),
                              ),
                            ),
                            Visibility(
                                visible: (list.length - 1) != i,
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

  bottomDateFilterDialog() {
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
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Date Filter',
                            style: heading1(colorWhite),
                          ),
                        ),
                        InkWell(
                            onTap: (() {
                              Get.back();
                            }),
                            child: const Icon(
                              Icons.close,
                              color: colorWhite,
                            )),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dateFilterList.length,
                    itemBuilder: (BuildContext context, i) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (() {
                          selectedDateFilterValue(i);

                          setState(() {
                            dateFilter = dateFilterList[i];
                          });

                          Get.back();
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                dateFilterList[i],
                                style: heading1(colorText),
                              ),
                            ),
                            Visibility(
                                visible: (dateFilterList.length - 1) != i,
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

  selectedDateFilterValue(int i) {
    DateTime now = DateTime.now();
    toDate = dateFormatter.format(now);
    if (i == 0) {
      //today
      fromDate = dateFormatter.format(now);
    } else if (i == 1) {
      //this week
      fromDate = dateFormatter.format(now.subtract(Duration(days: now.weekday)));
    } else if (i == 2) {
      //last 30 days
      fromDate = dateFormatter.format(DateTime(now.year, now.month - 1, now.day));
    } else if (i == 3) {
      //this quarter
      fromDate = dateFormatter.format(DateTime(now.year, now.month - 3, now.day));
    } else if (i == 4) {
      //this year
      // fromDate = dateFormatter.format(DateTime(now.year - 1, now.month, now.day));
      var minus = 0;
      if (now.month <= 3) {
        minus = 1;
      }

      var sDate = DateTime(DateTime.now().year - minus, 4, 1);
      fromDate = dateFormatter.format(sDate);
      toDate = dateFormatter.format(DateTime(sDate.year + 1, sDate.month, sDate.day - 1));
    } else if (i == 5) {
      //custom
    }
  }

  groupFilterList(List<Filter> list) {
    grp1 = '';
    grp2 = '';
    grp3 = '';
    grp4 = '';

    filterList = [];
    groupList = [];
    optionList = [];

    for (int j = 0; j < list.length; j++) {
      switch (list[j].tag) {
        case GROUP1:
        case GROUP2:
        case GROUP3:
        case GROUP4:
          var spList = list[j].spName!.split(',');
          String sName = spList.length > 0 ? spList[0] : '';

          if (list[j].selectedName!.length == 0) {
            list[j].selectedName = sName;
          }
          list[j].dropDownList = spList;

          groupList.add(list[j]);
          break;

        case 'Options':
          var spList = list[j].spName!.split(',');
          // String sName = spList.length > 0 ? spList[0] : '';

          // if (list[j].selectedName!.length == 0) {
          //   list[j].selectedName = sName;
          // }
          list[j].dropDownList = spList;

          optionList.add(list[j]);

          break;

        default:
          filterList.add(list[j]);
      }
    }
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onReportByMenuSuccess(ReportByMenuResponse data) {
    if (data.success!) {
      if (data.value! != null) {
        setState(() {
          List<FilterData> tempList = [];

          list.addAll(data.value!);

          int index = 0;

          if (widget.dashboardFilterData.defaultFilter != null) {
            for (int i = 0; i < list.length; i++) {
              if (list[i].repName == widget.dashboardFilterData.repName) {
                index = i;
                break;
              }
            }
          }

          if (list.length > index) {
            list[index].isSelect = true;
            //filterList = list[0].filter!;

            //default filter list from API
            if (list[index].defaultFilter != null && list[index].defaultFilter!.isNotEmpty) {
              var defaultFilterList = list[index].defaultFilter!;

              for (int i = 0; i < defaultFilterList.length; i++) {
                FilterData f = FilterData();
                f.id = list[index].defaultFilter![i].id;
                f.name = list[index].defaultFilter![i].name;
                f.tag = list[index].defaultFilter![i].tag!;
                tempList.add(f);
              }
            }

            //auto select default filter come from dashboard page
            if (widget.dashboardFilterData.defaultFilter != null &&
                widget.dashboardFilterData.defaultFilter!.isNotEmpty) {
              var defaultFilterList = widget.dashboardFilterData.defaultFilter!;

              List<String> tags = ['Options', 'Group1', 'Group2', 'Group3', 'Group4'];

              for (var filter in defaultFilterList) {
                if (tags.contains(filter.tag)) {
                  var filterListIndex = list[index].filter!.indexWhere((item) => item.tag == filter.tag);
                  if (filterListIndex != -1) {
                    var sName = list[index].filter![filterListIndex].selectedName!;
                    sName = sName.isEmpty ? filter.name! : '$sName,${filter.name}';
                    list[index].filter![filterListIndex].selectedName = sName;
                  }
                } else {
                  FilterData f = FilterData();
                  f.id = filter.id;
                  f.name = filter.name;
                  f.tag = filter.tag!;
                  tempList.add(f);
                }

                // var filterListIndex = list[index].filter!.indexWhere((item) => item.name == filter.tag);
                // var filterListIndex = list[index].filter!.indexWhere((item) => item.tag == 'Options');

                /*var filterListIndex = list[index].filter!.indexWhere((item) => tags.contains(item.tag));
                if (filterListIndex != -1) {
                  var sName = list[index].filter![filterListIndex].selectedName!;
                  sName = sName.isEmpty ? filter.name! : '$sName,${filter.name}';
                  list[index].filter![filterListIndex].selectedName = sName;
                } else {
                  FilterData f = FilterData();
                  f.id = filter.id;
                  f.name = filter.name;
                  f.tag = filter.tag!;
                  tempList.add(f);
                }*/

                /*if (filter.tag == 'Options') {
                  var filterListIndex = list[index].filter!.indexWhere((item) => item.tag == filter.tag);
                  if (filterListIndex != -1) {
                    var sName = list[index].filter![filterListIndex].selectedName!;
                    sName = sName.isEmpty ? filter.name! : '$sName,${filter.name}';
                    list[index].filter![filterListIndex].selectedName = sName;
                  }
                } else {
                  FilterData f = FilterData();
                  f.id = filter.id;
                  f.name = filter.name;
                  f.tag = filter.tag!;
                  tempList.add(f);
                }*/
              }
            }

            groupFilterList(list[index].filter!);

            reportId = list[index].reportId!;
            reportName = list[index].repName!;
            reportMode = list[index].repMode!;

            var idSet = <String>{};
            for (var d in tempList) {
              if (idSet.add(d.name!)) {
                selectedList.add(d);
              }
            }

            fromDate = list[index].fromDate!;
            toDate = list[index].toDate!;
            isVoucher = list[index].isVoucher!;
            if (list[index].ftp!.isNotEmpty) {
              PreferenceData.setFtpUrl(list[index].ftp![0].url!);
            }

            // checkGroupAvailability(filterList);
          }
        });
      }
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
