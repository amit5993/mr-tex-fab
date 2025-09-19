import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/utils/string.dart';

import '../model/role_response.dart';
import '../presenter/role_presenter.dart';
import '../utils/color.dart';
import '../utils/widget.dart';

class Role extends StatefulWidget {
  const Role({super.key});

  @override
  State<Role> createState() => _RoleState();
}

class _RoleState extends State<Role> implements RoleView {

  RolePresenter? _presenter;

  List<RoleData> list =[];
  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';

  _RoleState(){
    _presenter = RolePresenter(this);
  }

  @override
  void initState() {
    super.initState();

    _presenter!.getRole('PrcGetAllRoles', page, search);

  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              actionBar(context, sRole, true),

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
                      _presenter!.getRole('PrcGetAllRoles', page, search);
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
                                  border: Border.all(
                                      color: colorLightGray,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15, 15, 15, 15),
                                child: Text(
                                  data.name!.toString(),
                                  style: heading2(colorBlack),
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
    // TODO: implement onError
  }

  @override
  void onRoleSuccess(RoleResponse data) {
    if (data.success!) {
      if(page == 0){
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
