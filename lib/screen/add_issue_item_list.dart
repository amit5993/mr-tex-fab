import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:td/model/issue_entry_response.dart';

import '../common/check_response_code.dart';
import '../model/filter_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/order_number_response.dart';
import '../presenter/add_issue_item_list_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class AddIssueItemList extends StatefulWidget {
  const AddIssueItemList({super.key});

  @override
  State<AddIssueItemList> createState() => _AddIssueItemListState();
}

class _AddIssueItemListState extends State<AddIssueItemList> implements AddIssueItemListView {
  AddIssueItemListPresenter? _presenter;

  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  var ordType = 0;
  var ordTrnId = 0;

  var page = 0;
  var search = '';
  List<IssueItemDetailData> list = [];
  var selectMode = 1;
  var qrCode = '';
  FilterData? filterData;
  OrderNumberData? orderNumberData;

  _AddIssueItemListState() {
    _presenter = AddIssueItemListPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    selectMode = Get.arguments[0];
    filterData = Get.arguments[1];
    orderNumberData = Get.arguments[2];
    if (orderNumberData != null) {
      ordType = orderNumberData!.serId!;
      ordTrnId = orderNumberData!.trnId!;
    }

    _presenter!.getIssueItemDetail(page, search, selectMode, qrCode, filterData!.id!, ordType, ordTrnId);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getIssueItemDetail(page, search, selectMode, qrCode, filterData!.id!, ordType, ordTrnId);

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
              actionBar(context, 'Add Issue', true),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 5, 10),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        controller: searchController,
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
                          hintText: 'Search ',
                        ),
                        onChanged: (string) {
                          callSearchAPI(string);
                        },
                      ),
                    ),
                  ),
                  // horizontalView(),
                  InkWell(
                    onTap: (() {
                      openScanner();
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                          color: colorApp.withOpacity(0.2),
                          border: Border.all(color: colorApp),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          )),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          icScan,
                          height: 27,
                          width: 27,
                          color: colorApp,
                        ),
                      ),
                    ),
                  ),
                  horizontalView(),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = list[i];
                      return InkWell(
                        onTap: (() {
                          Get.back(result: data);
                        }),
                        child: Column(
                          children: [
                            //Visibility(visible: i == 0, child: verticalView()),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              // color: colorWhite,
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(color: data.isSelect ? colorApp : colorLightGray, width: 0.5),
                                  borderRadius: const BorderRadius.all(Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.qualName!.toString(),
                                      style: heading2(colorBlack),
                                    ),
                                    Text(
                                      data.content!.toString(),
                                      style: bodyText2(colorBlack),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            verticalView()
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  callSearchAPI(String s){
    setState(() {
      search = s;
      page = 0;
      list.clear();
    });
    _presenter!.getIssueItemDetail(page, search, selectMode, qrCode, filterData!.id!, ordType, ordTrnId);
  }

  openScanner() async {
    String barcodeScanRes = '';
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if (barcodeScanRes != '-1') {

        searchController.text = barcodeScanRes;
        callSearchAPI(barcodeScanRes);
    }

    print('Scan result is : $barcodeScanRes');
  }

  @override
  void onError(int errorCode) {
    CheckResponseCode.getResponseCode(errorCode, context);
  }

  @override
  void onIssueItemDetailSuccess(IssueItemDetailResponse data) {
    print(data);
    if (data.success!) {
      if (page == 0) {
        list.clear();
      }

      setState(() {
        list.addAll(data.value!);
      });
    } else {
      page--;
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
