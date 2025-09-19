import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/filter_response.dart';
import '../model/filter_title_data.dart';
import '../presenter/filter_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class AccountFilter extends StatefulWidget {
  const AccountFilter({super.key});

  @override
  State<AccountFilter> createState() => _AccountFilterState();
}

class _AccountFilterState extends State<AccountFilter> implements FilterView {
  FilterPresenter? _presenter;

  List<FilterTitleData> filterDataList = [];
  List<FilterData> list = [];
  List<FilterData> selectedList = [];
  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  var spName = '';

  _AccountFilterState() {
    _presenter = FilterPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // name = Get.arguments[0];
    // spName = Get.arguments[1];

    filterDataList.add(FilterTitleData('State', 'PrcGetState', [], true));
    filterDataList.add(FilterTitleData('City', 'PrcGetCity', [], false));
    filterDataList.add(FilterTitleData('Category', 'PrcGetAllCategory', [], false));
    filterDataList.add(FilterTitleData('CustType', 'PrcGetCustType', [], false));
    filterDataList.add(FilterTitleData('Market', 'PrcGetMarket', [], false));

    spName = 'PrcGetState';

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

  void onClickApply(){

    Map<String, List<String>> request = HashMap();


    for (int i = 0; i < filterDataList.length; i++) {
      // if (filterDataList[i].isSelect) {
      if (spName == filterDataList[i].type) {
        for (int j = 0; j < list.length; j++) {
          if (list[j].isSelect) {
            filterDataList[i].filterList.add(list[j].name!);
          }
        }
      }
      filterDataList[i].isSelect = false;
      filterDataList[i].filterList =  filterDataList[i].filterList.toSet().toList();
    }




    for (int i = 0; i < filterDataList.length; i++) {

      request[filterDataList[i].title] = filterDataList[i].filterList;
    }

    print(jsonEncode(request));

    Get.back(result: request);

  }

  void onClickCancel(){
    Get.back();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorWhite,
          body: Column(
            children: [
              actionBar(context, 'Filter', true),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: colorLightGrayBG,
                        child: ListView.builder(
                            itemCount: filterDataList == null ? 0 : filterDataList.length,
                            itemBuilder: (BuildContext context, i) {
                              var data = filterDataList[i];
                              return InkWell(
                                onTap: (() {
                                  for (int i = 0; i < filterDataList.length; i++) {
                                    // if (filterDataList[i].isSelect) {
                                    if (spName == filterDataList[i].type) {
                                      for (int j = 0; j < list.length; j++) {
                                        if (list[j].isSelect) {
                                          filterDataList[i].filterList.add(list[j].name!);
                                        }
                                      }
                                    }
                                    filterDataList[i].isSelect = false;
                                    filterDataList[i].filterList =  filterDataList[i].filterList.toSet().toList();
                                  }


                                  search = '';
                                  page = 0;
                                  spName = data.type;

                                  _presenter!.reportByFilter(spName, page, search); //search

                                  setState(() {
                                    data.isSelect = true;
                                  });
                                }),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Visibility(visible: i == 0, child: verticalView()),
                                    const SizedBox(height: 1),
                                    Container(
                                      width: double.infinity,
                                      color: data.isSelect ? colorApp : colorLightGray,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                        child: Text(
                                          data.title == 'CustType' ? 'Cust. Type' : data.title,
                                          style: bodyText1(data.isSelect ? colorWhite : colorBlack),
                                        ),
                                      ),
                                    ),
                                    //verticalView()
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
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

                                    for (int i = 0; i < filterDataList.length; i++) {
                                      if (filterDataList[i].isSelect) {
                                        spName = filterDataList[i].type;
                                        _presenter!.reportByFilter(spName, page, search);
                                        break;
                                      }
                                    }
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
                                        // for (int i = 0; i < list.length; i++) {
                                        //   list[i].isSelect = false;
                                        // }
                                        //
                                        // _presenter!.reportByFilter(data.type,  page, search);
                                        //




                                        setState(() {
                                          data.isSelect = !data.isSelect;

                                          for (int i = 0; i < filterDataList.length; i++) {
                                            // if (filterDataList[i].isSelect) {
                                            if (spName == filterDataList[i].type) {

                                              if(data.isSelect) {
                                                filterDataList[i].filterList.add(data.name!);
                                              }else{
                                                filterDataList[i].filterList.remove(data.name!);
                                              }
                                              break;
                                            }
                                            // filterDataList[i].isSelect = false;
                                            // filterDataList[i].filterList =  filterDataList[i].filterList.toSet().toList();
                                          }


                                        });
                                      }),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //Visibility(visible: i == 0, child: verticalView()),
                                          const SizedBox(height: 1),
                                          Container(
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data.name!.toString(),
                                                      style: bodyText2(colorBlack),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: data.isSelect,
                                                    child: Image.asset(
                                                      icTure,
                                                      color: colorApp,
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          divider()
                                          //verticalView()
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onClickApply();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 6.0, backgroundColor: colorApp, textStyle: const TextStyle(color: colorWhite)),
                                    child: const Text('Apply', style: TextStyle(color: colorWhite)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onClickCancel();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 6.0, backgroundColor: colorApp, textStyle: const TextStyle(color: colorWhite)),
                                    child: const Text('Close', style: TextStyle(color: colorWhite)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            )
                          ],
                        ))
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
  void onGetFilterSuccess(FilterResponse data) {
    print(data);
    if (data.success!) {
      if (page == 0) {
        list.clear();
      }

      var newList = data.value!;
      var fList = [];
      for (int i = 0; i < filterDataList.length; i++) {
        if (spName == filterDataList[i].type) {
          fList = filterDataList[i].filterList;
          break;
        }
      }

      for (int i = 0; i < fList.length; i++) {
        for (int j = 0; j < newList.length; j++) {
          if(newList[j].name == fList[i]){
            newList[j].isSelect = true;
            break;
          }
        }
      }



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
