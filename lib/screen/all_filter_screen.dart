import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:td/model/filter_response.dart';

import '../model/report_by_menu_response.dart';
import '../presenter/filter_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class AllFilterScreen extends StatefulWidget {
  const AllFilterScreen({super.key});

  @override
  State<AllFilterScreen> createState() => _AllFilterScreenState();
}

class _AllFilterScreenState extends State<AllFilterScreen> implements FilterView {
  FilterPresenter? _presenter;
  List<FilterData> list = [];
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  var page = 0;
  var search = '';
  var name = '';
  var spName = '';
  var isAddButton = false;

  _AllFilterScreenState() {
    _presenter = FilterPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var a = Get.arguments as List;

    name = a[0];
    spName = a[1];
    if(a.length > 2){
      isAddButton = a[2];
    }


    _presenter!.reportByFilter(spName, page, search);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.reportByFilter(spName, page, search);

        print('call api');
        // if (!isLoading) {
        //   isLoading = !isLoading;
        // }
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
              // actionBar(context, filterData!.name!, true),

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
                            name,
                            style: heading2(colorWhite),
                          ),
                        ),
                      ),
                      //comment 16/07 no need
                      // InkWell(
                      //   onTap: (() {
                      //     // List<FilterData> selectedList = [];
                      //     // for (int i = 0; i < list.length; i++) {
                      //     //   if (list[i].isSelect) {
                      //     //     selectedList.add(list[i]);
                      //     //   }
                      //     // }
                      //     // Get.back(result: selectedList);
                      //   }),
                      //   child: Text(
                      //     'DONE',
                      //     style: heading1(colorWhite),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      //Visibility(visible: isBack, child: const SizedBox(width: 25))
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                    setState(() {
                      search = string;
                      page = 0;
                      list.clear();
                      _presenter!.reportByFilter(spName, page, search);
                    });
                  },
                ),
              ),

              list.isNotEmpty ? listWidget() : addButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget listWidget(){
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: list == null ? 0 : list.length,
          itemBuilder: (BuildContext context, i) {
            var data = list[i];
            print(data.name);
            return InkWell(
              onTap: (() {

                Get.back(result: data);

                // setState(() {
                //   data.isSelect = !data.isSelect;
                // });
              }),
              child: Column(
                children: [
                  //Visibility(visible: i == 0, child: verticalView()),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    // color: colorWhite,
                    decoration: BoxDecoration(
                        color: colorWhite,
                        border: Border.all(color: data.isSelect ? colorApp : colorLightGray, width: 0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.name!.toString(),
                                      style: heading2(colorBlack),
                                    ),
                                  ),
                                  Visibility(
                                    visible: data.isSelect,
                                    child: Image.asset(
                                      icTure,
                                      color: colorApp,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Visibility(
                                visible: data.line1!.isNotEmpty || data.line2!.isNotEmpty || data.line3!.isNotEmpty ,
                                child: Text(
                                  '${data.line1!}, ${data.line2!}, ${data.line3!}',
                                  style: bodyText2(colorBlack),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalView()
                ],
              ),
            );
          }),
    );
  }

  Widget addButton(){
    return  Visibility(
      visible: searchController.text.isNotEmpty && isAddButton,
      child: InkWell(
        onTap: (() {

          var f = FilterData();
          f.id = -1;
          f.name = searchController.text.toString().trim();
          Get.back(result: f);

        }),
        child: Container(
          // height: 50,
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: colorApp.withOpacity(0.2),
              border: Border.all(color: colorApp),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_box, color: colorApp),
                const SizedBox(width: 5),
                Text(
                  'ADD ITEM',
                  style: heading2(colorApp),
                ),
              ],
            ),
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
  void onGetFilterSuccess(FilterResponse data) {
    if (data.success!) {
      if (page == 0) {
        list.clear();
      }

      var newList = data.value!;

      // for (int i = 0; i < selectedList.length; i++) {
      //   for (int j = 0; j < newList.length; j++) {
      //     if (selectedList[i].id == newList[j].id) {
      //       newList[j].isSelect = true;
      //       // selectedList.removeAt(i);
      //       break;
      //     }
      //   }
      // }

      setState(() {
        list.addAll(newList);
      });
    } else {
      page--;
      if (data.resultMessage! != null) {
        // toastMassage(data.resultMessage!);
      }
    }
  }
}
