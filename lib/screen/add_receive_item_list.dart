import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/model/issue_entry_response.dart';

import '../common/check_response_code.dart';
import '../model/filter_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/receive_item_detail_response.dart';
import '../presenter/add_issue_item_list_presenter.dart';
import '../presenter/add_receive_item_list_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class AddReceiveItemList extends StatefulWidget {
  const AddReceiveItemList({super.key});

  @override
  State<AddReceiveItemList> createState() => _AddReceiveItemListState();
}

class _AddReceiveItemListState extends State<AddReceiveItemList> implements AddReceiveItemListView {

  AddReceiveItemListPresenter? _presenter;

  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  var page = 0;
  var search = '';
  List<ReceiveItemDetails> list = [];
  var jobberId = 0;
  var qrCode = '';
  FilterData? filterData;

  _AddReceiveItemListState(){
    _presenter = AddReceiveItemListPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    jobberId = Get.arguments[0];
    filterData = Get.arguments[1];

    _presenter!.getReceiveItemDetail(page, search, jobberId, qrCode, filterData!.id!);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getReceiveItemDetail(page, search, jobberId, qrCode,filterData!.id!);

        print('call api');
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Important: always cancel timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              actionBar(context, 'Add Receive Entry', true),
              Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: TextField(
                  textInputAction: TextInputAction.search,
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
                  // onChanged: (string) {
                  //   setState(() {
                  //     search = string;
                  //     page = 0;
                  //     list.clear();
                  //     _presenter!.getReceiveItemDetail(page, search, jobberId, qrCode, filterData!.id!);
                  //   });
                  // },


                  onChanged: (string) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();

                    _debounce = Timer(const Duration(milliseconds: 1000), () {
                      setState(() {
                        search = string;
                        page = 0;
                        list.clear();
                        _presenter!.getReceiveItemDetail(page, search, jobberId, qrCode, filterData!.id!);
                      });
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

  @override
  void onError(int errorCode) {
    CheckResponseCode.getResponseCode(errorCode, context);
  }

  @override
  void onReceiveItemDetailSuccess(ReceiveItemDetailResponse data) {
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
