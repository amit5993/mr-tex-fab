import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/party_response.dart';
import '../model/role_response.dart';
import '../presenter/party_presenter.dart';
import '../utils/color.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class Party extends StatefulWidget {
  const Party({super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> implements PartyView {
  PartyPresenter? _presenter;

  List<PartyData> list = [];
  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  var role = '';

  _PartyState() {
    _presenter = PartyPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    role = Get.arguments;

    _presenter!.getParty(role, page, search);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        page++;
        _presenter!.getParty(role, page, search);
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
              actionBar(context, sParty, true),
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
                      _presenter!.getParty(role, page, search);
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Visibility(visible: i == 0, child: verticalView()),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              // color: colorWhite,
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(color: colorLightGray, width: 0.5),
                                  borderRadius: const BorderRadius.all(Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.text!.toString(),
                                      style: heading2(colorBlack),
                                    ),
                                    Text(
                                      data.line1! + data.line2! + data.line3!,
                                      style: bodyText2(colorGray),
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
  void onError(int errorCode) {}

  @override
  void onPartySuccess(PartyResponse data) {
    if (data.success!) {

      if(page == 0){
        list.clear();
      }

      setState(() {
        list.addAll(data.value!.results!);
      });
    } else {
      page--;
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
