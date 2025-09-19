import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/check_response_code.dart';
import '../model/issue_entry_response.dart';
import '../model/order_number_response.dart';
import '../presenter/order_number_presenter.dart';
import '../utils/color.dart';
import '../utils/widget.dart';

class OrderNumber extends StatefulWidget {
  const OrderNumber({super.key});

  @override
  State<OrderNumber> createState() => _OrderNumberState();
}

class _OrderNumberState extends State<OrderNumber> implements OrderNumberView  {
  final ScrollController _scrollController = ScrollController();

  List<OrderNumberData> list = [];
  OrderNumberPresenter? _presenter;

  var page = 0;
  var search = '';

  var serId = 0;
  var accountId = 0;

  _OrderNumberState(){
    _presenter = OrderNumberPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    serId = Get.arguments[0];
    accountId = Get.arguments[1];

    _presenter!.getOrderNumberList(serId,accountId, page, '');

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getOrderNumberList(serId,accountId,page , search);
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
              actionBar(context, 'Order Number', true),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                      _presenter!.getOrderNumberList(serId,accountId, page, search);
                    });
                  },
                ),
              ),
              verticalView(),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Visibility(visible: i == 0, child: verticalView()),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              // color: colorWhite,
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(
                                      color: colorLightGray,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15, 15, 15, 15),
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
  void onGetIssueSuccess(OrderNumberResponse data) {
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

}
