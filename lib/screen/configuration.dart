import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:td/model/common_response.dart';
import 'package:td/model/filter_response.dart';

import '../model/config_app_menu_response.dart';
import '../model/role_response.dart';
import '../presenter/configuration_presenter.dart';
import '../presenter/filter_presenter.dart';
import '../presenter/role_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> implements ConfigurationView {
  List<ConfigAppMenu> list = [];

  TextEditingController roleController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';
  var spName = '';

  var roleId = 0;
  int selectedsModule = 1;

  ConfigurationPresenter? _presenter;

  _ConfigurationState() {
    _presenter = ConfigurationPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sRole,
                    style: blackRegular(),
                  ),
                  verticalView(),
                  InkWell(
                      onTap: (() async {
                        RoleData rData = await Get.toNamed('/role') as RoleData;
                        if (rData != null) {
                          _presenter!.getAppConfig(rData.id!, selectedsModule);

                          setState(() {
                            roleController.text = rData.name!;
                            roleId = rData.id!;
                          });
                        }
                      }),
                      child: textField(context, roleController, sRole, '', false, false)),
                  verticalViewBig(),
                  Text(
                    sModule,
                    style: blackRegular(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                          visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                          title: Text(
                            'Report',
                            style: blackTitle(),
                          ),
                          leading: Radio(
                            value: 1,
                            groupValue: selectedsModule,
                            activeColor: colorApp,
                            // Change the active radio button color here
                            fillColor: MaterialStateProperty.all(colorApp),
                            // Change the fill color when selected
                            splashRadius: 25,
                            // Change the splash radius when clicked
                            onChanged: (value) {
                              if (roleId != 0) {
                                _presenter!.getAppConfig(roleId, value!);
                              }
                              setState(() {
                                selectedsModule = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                          visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                          title: Text(
                            'Menu',
                            style: blackTitle(),
                          ),
                          leading: Radio(
                            value: 2,
                            groupValue: selectedsModule,
                            activeColor: colorApp,
                            // Change the active radio button color here
                            fillColor: MaterialStateProperty.all(colorApp),
                            // Change the fill color when selected
                            splashRadius: 25,
                            // Change the splash radius when clicked
                            onChanged: (value) {
                              if (roleId != 0) {
                                _presenter!.getAppConfig(roleId, value!);
                              }
                              setState(() {
                                selectedsModule = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalView(),
                  Visibility(
                    visible: list.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list == null ? 0 : list.length,
                            itemBuilder: (BuildContext context, i) {
                              var data = list[i];
                              return InkWell(
                                onTap: (() {}),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalView(),
                                    Text(
                                      data.title!.toString(),
                                      style: blackTitle(),
                                    ),
                                    verticalView(),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: colorWhite,
                                          border: Border.all(color: colorLightGray, width: 0.2),
                                          borderRadius: const BorderRadius.all(Radius.circular(8))),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: data.dataList == null ? 0 : data.dataList!.length,
                                          itemBuilder: (BuildContext context, j) {
                                            var dList = data.dataList![j];
                                            return InkWell(
                                              onTap: (() {}),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //Visibility(visible: j == 0, child: verticalView()),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            dList.name!.toString(),
                                                            style: bodyText1(colorBlack),
                                                          ),
                                                        ),
                                                        Switch(
                                                          // This bool value toggles the switch.
                                                          value: dList.value == 1,
                                                          activeColor: colorApp,
                                                          //thumbColor: const MaterialStatePropertyAll<Color>(colorApp),
                                                          onChanged: (bool value) {
                                                            // This is called when the user toggles the switch.
                                                            value ? dList.value = 1 : dList.value = 0;
                                                            _presenter!.setAppConfig(roleId, dList.id!, dList.value!, dList.module!);

                                                            setState(() {});
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  j == (data.dataList!.length -1 ) ? SizedBox() :divider() ,
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    // divider(),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
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
  void onGetConfigurationDataSuccess(ConfigAppMenuResponse data) {
    if (data.success!) {
      list.clear();
      setState(() {
        list.addAll(data.value!);
      });
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  void onSetConfigurationDataSuccess(CommonResponse data) {
    if (data.success!) {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
