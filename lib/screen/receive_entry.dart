
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/model/filter_response.dart';

import '../presenter/filter_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class ReceiveEntry extends StatefulWidget {
  const ReceiveEntry({super.key});

  @override
  State<ReceiveEntry> createState() => _ReceiveEntryState();
}

class _ReceiveEntryState extends State<ReceiveEntry> implements FilterView {

  FilterPresenter? _presenter;

  List<FilterData> list = [];

  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  var spName = '';


  _ReceiveEntryState() {
    _presenter = FilterPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    spName = 'PrcGetReceiveType';

    _presenter!.reportByFilter(spName, page, search);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.reportByFilter(spName, page, search);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: ListView.builder(
              controller: _scrollController,
              itemCount: list == null ? 0 : list.length,
              itemBuilder: (BuildContext context, i) {
                var data = list[i];
                return InkWell(
                  onTap: (() {

                    Get.toNamed('/receive_list', arguments: data);

                  }),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Visibility(visible: i == 0, child: verticalView()),
                      const SizedBox(height: 1),
                      Container(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                            child: Text(
                              data.name!.toString(),
                              style: heading2(colorBlack),
                            ),
                          ),
                        ),
                      ),
                      //divider()
                      //verticalView()
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onGetFilterSuccess(FilterResponse data) {
    print(data);
    if (data.success!) {
      if (page == 0) {
        list.clear();
      }

      list.addAll(data.value!);

      setState(() {
        if(list.length == 1){
          Get.toNamed('/receive_list', arguments: list[0]);
        }
      });
    } else {
      page--;
      if (data.resultMessage! != null) {
        // toastMassage(data.resultMessage!);
      }
    }
  }
}
