import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:td/api/constant.dart';
import 'package:td/common/utils.dart';
import 'package:td/model/app_initial_response.dart';
import 'package:td/model/common_response.dart';
import 'package:td/model/filter_response.dart';

// import 'package:td/model/menu_response.dart';
import 'package:td/presenter/main_presenter.dart';
import 'package:td/screen/account_master.dart';
import 'package:td/screen/change_password.dart';
import 'package:td/screen/dashboard.dart';
import 'package:td/screen/receive_entry.dart';
import 'package:td/screen/sale_purchase_report.dart';
import 'package:td/screen/share_app.dart';
import 'package:td/screen/user_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

import '../common/check_response_code.dart';
import '../model/dashboard_filter_response.dart';
import '../model/login_response.dart';
import '../model/version_update_response.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';
import '../voice_to_text_screen.dart';
import 'approval.dart';
import 'configuration.dart';
import 'contact_master.dart';
import 'issue_entry.dart';
import 'order_list.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> implements MainView {
  List<MenuData> drawerList = [];
  List<MenuData> dashboardList = [];
  List<String> bannerList = [];
  MenuData? selectMenuData;
  String _selectedDrawerIndex = '';

  LoginResponse? userData;
  MainPresenter? _presenter;
  var sTitle = '';
  var lastUpdate = '';

  List<FilterData> companyList = [];
  FilterData? selectedCompany;

  _MainScreenState() {
    _presenter = MainPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    userData = LoginResponse.fromJson(jsonDecode(PreferenceData.getUserInfo()));

    selectedCompany = FilterData();
    _presenter!.getAppInitialAPI();
    // _presenter!.getCompany();
    // _presenter!.getAllMenu();
    // _presenter!.getDrawerMenu();
    // _presenter!.checkVersionUpdate();

    try {
      selectedCompany!.id = userData!.value!.companyId;
      selectedCompany!.name = userData!.value!.companyName;
    } catch (e) {
      print(e);
    }

    // scheduleIconSwitchIfNeeded();
    permission();
  }

  // Future<void> scheduleIconSwitchIfNeeded() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final count = prefs.getInt('launchCount') ?? 0;
  //
  //   // Toggle on each launch
  //   final switchToAlias2 = (count % 2 == 1); // 1st → false, 2nd → true, etc.
  //
  //   const platform = MethodChannel('icon_switcher');
  //   await platform.invokeMethod('scheduleSwitch', {
  //     "enable": switchToAlias2
  //         ? "com.mrtex.fab.MainActivityAlias2"
  //         : "com.mrtex.fab.MainActivityAlias1",
  //     "disable": switchToAlias2
  //         ? "com.mrtex.fab.MainActivityAlias1"
  //         : "com.mrtex.fab.MainActivityAlias2",
  //   });
  //
  //   prefs.setInt('launchCount', count + 1);
  // }

  permission() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    print('Permission - ${statuses[Permission.storage]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        elevation: 0,
        title: Text(
          sTitle,
          style: heading2(colorWhite),
        ),
        actions: <Widget>[
          Visibility(
            visible: _selectedDrawerIndex != '',
            child: IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () {
                if (_selectedDrawerIndex != '') {
                  setState(() {
                    _selectedDrawerIndex = '';
                    sTitle = sApplicationName;
                  });
                }
              },
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   tooltip: 'Logout Icon',
          //   onPressed: () {
          //     logoutDialog(context, 'Are you sure you want to logout?');
          //   },
          // ),
        ],
        iconTheme: const IconThemeData(color: colorWhite),
        backgroundColor: colorApp,
      ),
      drawer: _drawer(),
      body: WillPopScope(
          child: _selectedDrawerIndex == '' ? dashboard() : _getDrawerItemWidget(_selectedDrawerIndex),
          onWillPop: onWillPop),
    );
  }

  int userRole = 0;

  Drawer _drawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  // Important: Remove any padding from the ListView.
                  //padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: DrawerHeader(
                        decoration: const BoxDecoration(
                          color: colorApp,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalViewBig(),
                            Row(
                              children: [
                                userData!.value!.clientLogo!.isNotEmpty
                                    ? FadeInImage.assetNetwork(
                                        placeholder: appIcon,
                                        image: userData!.value!.clientLogo!,
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 70,
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return const SizedBox();
                                        },
                                      )
                                    : Image.asset(appIcon, height: 70, width: 70),
                                horizontalView(),
                                horizontalView(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData!.value!.firstName!,
                                      // 'Rakesh Kale',
                                      style: heading2(colorWhite),
                                    ),
                                    Text(
                                      userData!.value!.roleName!,
                                      // 'Rakesh Kale',
                                      style: bodyText1(colorOffWhite),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            verticalView(),
                            Visibility(
                              visible: lastUpdate.isNotEmpty,
                              child: Text(
                                'Last Sync: $lastUpdate',
                                style: bodyText1(colorWhite),
                              ),
                            ),
                            verticalView(),

                            InkWell(
                              onTap: (() {
                                _presenter!.getCompany();
                              }),
                              child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(selectedCompany!.name! ?? 'Select an company',
                                              style: bodyText2(colorBlack))),
                                      const Icon(
                                        Icons.arrow_drop_down_outlined,
                                        size: 20,
                                        color: colorBlack,
                                      ),
                                    ],
                                  )),
                            ),

                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                            //   decoration: BoxDecoration(
                            //     color: colorWhite,
                            //     borderRadius: BorderRadius.circular(50.0),
                            //   ),
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton<FilterData>(
                            //       hint: Text("Select an company", style: bodyText2(colorGray)),
                            //       value: selectedCompany,
                            //       style: heading1(colorBlack),
                            //       icon: const Icon(
                            //         Icons.arrow_drop_down,
                            //         color: colorBlack,
                            //       ),
                            //       isExpanded: true,
                            //       dropdownColor: colorWhite,
                            //       onChanged: (FilterData? newValue) {
                            //         _presenter!.setCompany(newValue!.id!.toString(), newValue.name!);
                            //         setState(() {
                            //           selectedCompany = newValue;
                            //         });
                            //       },
                            //       items: companyList.map((item) {
                            //         return DropdownMenuItem<FilterData>(
                            //           value: item,
                            //           child: Text(item.name!, style: bodyText2(colorBlack)), // Custom UI for each item
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: drawerList == null ? 0 : drawerList.length,
                        itemBuilder: (BuildContext context, i) {
                          var data = drawerList[i];
                          return InkWell(
                            onTap: (() {
                              _onTapMenu(data);
                            }),
                            child: drawerListCell(data, i),
                          );
                        })
                  ],
                ),
              ),
            ),
            divider(),
            InkWell(
              onTap: (() {
                logoutDialog(context, 'Are you sure you want to logout?');
              }),
              child: Container(
                //color: colorLightGrayBG,
                width: 180,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: colorRed.withOpacity(0.1),
                    border: Border.all(color: colorRed, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icLogout,
                        height: 18,
                        width: 18,
                        color: colorRed,
                      ),
                      horizontalView(),
                      Text(
                        'Logout',
                        style: bodyText2(colorRed),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            verticalViewSmall()
          ],
        ),
      ),
    );
  }

  Widget drawerListCell(MenuData menu, int index) {
    if (menu.childMenu!.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, index == 0 ? 0 : 15, 10, 15),
        child: Row(
          children: [
            Image.network(
              menu.iconUrl!,
              height: 25,
              width: 25,
              color: colorApp,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: colorWhite,
                  height: 25,
                  width: 25,
                );
              },
            ),
            const SizedBox(
              width: 13,
            ),
            Text(
              menu.menuDisplayName!,
              style: heading1(colorBlack),
            ),
          ],
        ),
      );
    }

    return ExpansionTile(
      initiallyExpanded: menu.isExpand == 1,
      tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: const VisualDensity(vertical: -3),
      childrenPadding: const EdgeInsets.only(left: 8.0),
      leading: Image.network(
        menu.iconUrl!,
        height: 25,
        width: 25,
        color: colorApp,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: colorWhite,
            height: 25,
            width: 25,
          );
        },
      ),
      title: Text(
        menu.menuDisplayName!,
        style: heading1(colorBlack),
      ),
      children: (menu.childMenu)!.map((child) {
        return ListTile(
          // contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: -4),
          leading: Image.network(
            child.iconUrl!,
            height: 20,
            width: 20,
            color: colorApp,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: colorWhite,
                height: 20,
                width: 20,
              );
            },
          ),
          onTap: (() {
            _onTapMenu(child);
          }),
          title: Text(
            child.menuDisplayName!,
            style: bodyText2(colorText),
          ),
        );
      }).toList(),
    );
  }

  companyListDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          backgroundColor: Colors.white,
          child: Container(
            // padding: const EdgeInsets.all(20.0),
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: colorApp,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        'Please select company',
                        style: heading2(colorWhite),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: companyList?.length ?? 0,
                    itemBuilder: (BuildContext context, i) {
                      var data = companyList[i];
                      return InkWell(
                        key: ValueKey(data.id),
                        onTap: () {
                          _presenter?.setCompany(data.id.toString(), data.name!);
                          if (mounted) {
                            setState(() {
                              selectedCompany = data;
                            });
                          }
                          Get.back();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(7, 15, 7, 15),
                              child: Text(
                                data.name!,
                                style: bodyText2(colorBlack),
                              ),
                            ),
                            divider()
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // showDialog<void>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return WillPopScope(
    //       onWillPop: () async => false,
    //       child: AlertDialog(
    //         backgroundColor: colorWhite,
    //         title: const Text(
    //           "Please select company",
    //           style: TextStyle(
    //             fontSize: 20.0,
    //             color: colorBlack,
    //             decoration: TextDecoration.none,
    //             fontFamily: "Medium",
    //           ),
    //         ),
    //         content: ListView.builder(
    //           // shrinkWrap: true,
    //           // physics: const NeverScrollableScrollPhysics(),
    //           itemCount: companyList?.length ?? 0,
    //           itemBuilder: (BuildContext context, i) {
    //             var data = companyList[i];
    //             return InkWell(
    //               key: ValueKey(data.id),
    //               onTap: () {
    //                 _presenter?.setCompany(data.id.toString(), data.name!);
    //                 if (mounted) {
    //                   setState(() {
    //                     selectedCompany = data;
    //                   });
    //                 }
    //                 Get.back();
    //               },
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.fromLTRB(7, 15, 7, 15),
    //                     child: Text(
    //                       data.name!,
    //                       style: bodyText2(colorBlack),
    //                     ),
    //                   ),
    //                   divider()
    //                 ],
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  Widget dashboard() {
    return Container(
      color: colorBG,
      child: Column(
        children: [
          bannerList.isNotEmpty ? topBanner() : topWidget(),
          // topWidget(),
          verticalViewSmall(),
          dashboardGridWidget(),
        ],
      ),
    );

    // return Container(
    //     constraints: BoxConstraints.loose(Size.fromHeight(60.0)),
    //     decoration: BoxDecoration(color: Colors.black),
    //     child: Stack(
    //         clipBehavior: Clip.none,
    //         alignment: Alignment.topCenter,
    //         children: [
    //           Positioned(
    //               top: -10.0,
    //               left: 15.0,
    //               right: 15.0,
    //               child: Text(
    //                 "OUTSIDE CONTAINER",
    //                 style: TextStyle(color: Colors.red, fontSize: 24.0),
    //               ))
    //         ]));
  }

  Widget topBanner() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: colorWhite,
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            offset: Offset(1, 1), // Horizontal and vertical offset
            blurRadius: 4, // Spread of the shadow
            spreadRadius: 1, // How much the shadow spreads
          ),
        ],
      ),
      child: ClipRRect(
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(5),
        //   topRight: Radius.circular(5),
        // ),
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            initialPage: 0,
            autoPlay: true,
            onPageChanged: (index, reason) {},
          ),
          items: bannerList.map((item) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.30,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: item,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => blurredPlaceholder(item),
                    // placeholder: (context, url) => Image.network(
                    //   item,
                    //   fit: BoxFit.cover,
                    // ),
                    errorWidget: (context, url, error) => blurredPlaceholder(item),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget topWidget() {
    return Container(
      // margin: const EdgeInsets.all(2),
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: colorApp,
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            offset: Offset(1, 1), // Horizontal and vertical offset
            blurRadius: 4, // Spread of the shadow
            spreadRadius: 1, // How much the shadow spreads
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          userData!.value!.clientLogo!.isNotEmpty
              ? ClipOval(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: FadeInImage.assetNetwork(
                        placeholder: appIcon,
                        image: userData!.value!.clientLogo!,
                        fit: BoxFit.fill,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            appIcon,
                          );
                        },
                      ),
                    ),
                  ),
                )
              : ClipOval(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      appIcon,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          Text(
            userData!.value!.firstName!,
            // 'Rakesh Kale',
            style: heading2(colorWhite),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: lastUpdate.isNotEmpty,
            child: Text(
              'Last Sync: $lastUpdate',
              style: bodyText2(colorWhite),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget dashboardGridWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
              childAspectRatio: 1,
            ),
            itemCount: dashboardList.length,
            itemBuilder: (BuildContext ctx, index) {
              var data = dashboardList[index];
              return InkWell(
                onTap: (() {
                  _onTapMenu(data);
                }),
                child: Container(
                  decoration:
                      const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 30,
                        child: Image.network(
                          data.iconUrl!,
                          color: colorApp,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: colorWhite,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(data.menuDisplayName!,
                          textAlign: TextAlign.center, maxLines: 2, style: bodyText2(colorText)),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 1),
                      //   child: AutoSizeText(
                      //     data.menuDisplayName!,
                      //     style: bodyText2(colorText),
                      //     maxLines: 1,
                      //     // Ensure the text stays on one line
                      //     minFontSize: 8,
                      //     // Minimum font size
                      //     maxFontSize: 14,
                      //     // Maximum font size
                      //     overflow: TextOverflow.ellipsis, // Handle overflow
                      //   ),
                      // ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget dashboardListWidget() {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dashboardList.length,
          itemBuilder: (BuildContext ctx, index) {
            var data = dashboardList[index];
            return InkWell(
              onTap: (() {
                _onTapMenu(data);
              }),
              child: Container(
                decoration: const BoxDecoration(color: colorWhite, borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(visible: index == 0, child: verticalView()),
                    Row(
                      children: [
                        horizontalView(),
                        Container(
                          height: 15,
                          width: 15,
                          child: Image.network(
                            data.iconUrl!,
                            color: colorApp,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: colorWhite,
                              );
                            },
                          ),
                        ),
                        horizontalView(),
                        Expanded(
                          child: Text(
                            data.menuDisplayName!,
                            style: bodyText2(colorText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                        ),
                        horizontalView(),
                        const Icon(
                          Icons.chevron_right,
                          color: colorText,
                          size: 18,
                        ),
                        horizontalView(),
                      ],
                    ),
                    verticalView(),
                    Visibility(visible: index != (dashboardList.length - 1), child: divider()),
                    Visibility(visible: index != (dashboardList.length - 1), child: verticalView()),
                  ],
                ),
              ),
            );
          }),
    );
  }

  // Widget dashboard() {
  //   return Stack(
  //     children: [
  //       Container(
  //         height: MediaQuery.of(context).size.height * 0.30,
  //         width: MediaQuery.of(context).size.width,
  //         decoration: BoxDecoration(
  //             color: colorApp,
  //             border: Border.all(color: colorApp),
  //             borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             userData!.value!.clientLogo!.isNotEmpty
  //                 ? ClipOval(
  //               child: Container(
  //                 height: 100,
  //                 width: 100,
  //                 child: ClipRRect(
  //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
  //                   child: FadeInImage.assetNetwork(
  //                     placeholder: appIcon,
  //                     image: userData!.value!.clientLogo!,
  //                     fit: BoxFit.fill,
  //                     imageErrorBuilder: (context, error, stackTrace) {
  //                       return Image.asset(
  //                         appIcon,
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             )
  //                 : ClipOval(
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Image.asset(
  //                   appIcon,
  //                   height: 100,
  //                   width: 100,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Text(
  //               userData!.value!.firstName!,
  //               // 'Rakesh Kale',
  //               style: heading2(colorWhite),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Visibility(
  //               visible: lastUpdate.isNotEmpty,
  //               child: Text(
  //                 'Last Sync: $lastUpdate',
  //                 style: bodyText2(colorWhite),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         // color: colorLightGrayBG,
  //         margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
  //         child: Padding(
  //           padding: const EdgeInsets.all(10),
  //           child: GridView.builder(
  //               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //                   maxCrossAxisExtent: 200, childAspectRatio: 3 / 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
  //               itemCount: dashboardList.length,
  //               itemBuilder: (BuildContext ctx, index) {
  //                 var data = dashboardList[index];
  //                 return InkWell(
  //                   onTap: (() {
  //                     _onTapMenu(data);
  //                   }),
  //                   child: Container(
  //                     // alignment: Alignment.center,
  //                     // decoration: BoxDecoration(
  //                     //     color: colorApp.withOpacity(0.1),
  //                     //     border: Border.all(color: colorApp),
  //                     //     borderRadius: BorderRadius.circular(10)),
  //                     child: Card(
  //                       // margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
  //                       elevation: 2,
  //                       shape: const RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.all(Radius.circular(10)),
  //                       ),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             height: 50,
  //                             width: 50,
  //                             child: Image.network(
  //                               data.iconUrl!,
  //                               color: colorApp,
  //                               errorBuilder: (context, error, stackTrace) {
  //                                 return Container(
  //                                   color: colorWhite,
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                           const SizedBox(height: 10),
  //                           Text(
  //                             data.menuDisplayName!,
  //                             style: heading1(colorBlack),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }),
  //         ),
  //       ),
  //     ],
  //   );
  //
  //   // return Container(
  //   //     constraints: BoxConstraints.loose(Size.fromHeight(60.0)),
  //   //     decoration: BoxDecoration(color: Colors.black),
  //   //     child: Stack(
  //   //         clipBehavior: Clip.none,
  //   //         alignment: Alignment.topCenter,
  //   //         children: [
  //   //           Positioned(
  //   //               top: -10.0,
  //   //               left: 15.0,
  //   //               right: 15.0,
  //   //               child: Text(
  //   //                 "OUTSIDE CONTAINER",
  //   //                 style: TextStyle(color: Colors.red, fontSize: 24.0),
  //   //               ))
  //   //         ]));
  // }

  _onTapMenu(MenuData data) {
    if (data.menuId != 56) {
      sTitle = data.menuDisplayName!;
    } else {
      sTitle = sApplicationName;
    }
    _onSelectItem(data);
  }

  _onSelectItem(MenuData data) {
    setState(() {
      _selectedDrawerIndex = data.menuTag!;
      selectMenuData = data;
    });
    Get.back();
  }

  _getDrawerItemWidget(String pos) {
    switch (pos) {
      case 'Dashboard':
        //todo remove after testing
        // return const VoiceToTextScreen();
        return const Dashboard();
      case 'User Manager':
        return const UserManager();
      case 'Order Entry':
        return const OrderList();
      case 'Contact Master':
        return const ContactMaster();
      case 'Change Password':
        return const ChangePassword();
      case 'Account Master':
        return const AccountMaster();
      case 'Issue Entry':
        return const IssueEntry();
      case 'Approval':
        return const Approval();
      case 'Receive Entry':
        return const ReceiveEntry();
      case 'Configuration':
        return const Configuration();
      case 'Share App':
        return const ShareApp();
      case 'Scan':
        openScanner();
        return dashboard();

      default:
        return SalePurchaseReport(
            key: Key(selectMenuData!.menuName!),
            type: selectMenuData!.menuName!,
            dashboardFilterData: DashboardFilterData());
    }
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
      Get.toNamed('/pdf_viewer', arguments: [barcodeScanRes]);
    }

    print('Scan result is : $barcodeScanRes');
  }

  appUpdateDialog(bool isHardUpdate) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          backgroundColor: Colors.white,
          child: Container(
            // padding: const EdgeInsets.all(20.0),
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: colorApp,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        'App Update Available!',
                        style: heading2(colorWhite),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'We have added new features and fix some bugs to make your experience seamless.',
                        style: bodyText2(colorText),
                      ),
                      verticalViewBig(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: !isHardUpdate,
                            child: InkWell(
                              onTap: (() {
                                Get.back();
                              }),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3.5,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          colorGradient1,
                                          colorGradient2,
                                          //colorWhite,
                                        ]),
                                    //color: colorApp,
                                    border: Border.all(color: colorApp),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50),
                                    )),
                                child: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Center(
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(fontSize: 16, fontFamily: "Medium", color: colorWhite),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          horizontalView(),
                          InkWell(
                            onTap: (() async {
                              if (Platform.isAndroid || Platform.isIOS) {
                                final appId = Platform.isAndroid ? Constant.androidPkg : Constant.iOSId;
                                final url = Uri.parse(
                                  Platform.isAndroid
                                      ? "market://details?id=$appId"
                                      : "https://apps.apple.com/app/id$appId",
                                );

                                await launchUrl(url, mode: LaunchMode.externalApplication);

                                exit(0);
                              }

                              Get.back();
                            }),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        colorGradient1,
                                        colorGradient2,
                                        //colorWhite,
                                      ]),
                                  //color: colorApp,
                                  border: Border.all(color: colorApp),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  )),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(fontSize: 16, fontFamily: "Medium", color: colorWhite),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      verticalView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // onClickMenu(MenuData data) {
  //   if (data.menuId == 15) {
  //     const UserManager();
  //   } else if (data.menuId == 18) {
  //     const OrderList();
  //   }
  // }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    if (_selectedDrawerIndex != '') {
      setState(() {
        _selectedDrawerIndex = '';
        sTitle = sApplicationName;
      });
      return Future.value(false);
    } else {
      /*DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        toastMassage('Tap again to exit');
        return Future.value(false);
      }
      return Future.value(true);*/

      exitDialog(context);

      return Future.value(false);
    }
  }

  logoutDialog(BuildContext context, String message) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colorOffWhite,
            title: const Text("Logout", style: TextStyle(fontSize: 18, color: colorBlack, fontFamily: "Medium")),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message, style: blackTitle1()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "NO",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "YES",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  Get.back();
                  _presenter!.doLogout();
                },
              )
            ],
          );
        });
  }

  exitDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colorOffWhite,
            title: const Text("Exit App!", style: TextStyle(fontSize: 18, color: colorBlack, fontFamily: "Medium")),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to exit?', style: blackTitle1()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "NO",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "YES",
                  style: heading1(colorApp),
                ),
                onPressed: () {
                  exit(0);
                },
              )
            ],
          );
        });
  }

  checkVersionUpdate(AppVersion value) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print('appName - $appName');
    print('packageName - $packageName');
    print('version - $version');
    print('buildNumber - $buildNumber');

    if (Platform.isAndroid) {
      int bNumber = int.parse(buildNumber);
      if (bNumber < value.aVersion!) {
        appUpdateDialog(value.isHardLoad!);
      }
    } else {
      double bNumber = double.parse(version);
      if (bNumber < value.iVersion!) {
        appUpdateDialog(value.isHardLoad!);
      }
    }
  }

  Future<String?> downloadAdsVideo(String url) async {
    // var localVideoPath = PreferenceData.getAdsVideoPath();
    //
    // if (localVideoPath != null && File(localVideoPath).existsSync()) {
    //   // Video already downloaded, return the local path
    //   return localVideoPath;
    // }

    // Download the video
    String fileName = getFileNameFromUrl(url);

    final directory = await getApplicationDocumentsDirectory();
    final downloadPath = "${directory.path}/$fileName";

    final dio = Dio();
    await dio.download(url, downloadPath);

    // Save the downloaded path to SharedPreferences
    // PreferenceData.setAdsVideoPath(downloadPath);
    PreferenceData.setAdsVideoPath(fileName);

    print("url - $url");
    print("downloadPath - $downloadPath");

    return downloadPath;
  }

  String getFileNameFromUrl(String url) {
    return Uri.parse(url).pathSegments.last;
  }

  void checkAndNavigate(String videoUrl) {
    var localVideoPath = PreferenceData.getAdsVideoPath();

    if (localVideoPath.isNotEmpty) {
      // Extract filenames
      String remoteFilename = Uri.parse(videoUrl).pathSegments.last;
      String localFilename = path.basename(localVideoPath);

      if (remoteFilename == localFilename) {
        // Same video, navigate to video ads screen
        Get.toNamed('/video_ads', arguments: [localVideoPath, videoUrl]);
      } else {
        // Different video, download the new video
        downloadAdsVideo(videoUrl);
      }
    } else {
      // Local video path is empty, download the video
      downloadAdsVideo(videoUrl);
    }
  }

  @override
  void onError(int errorCode) {
    CheckResponseCode.getResponseCode(errorCode, context);
  }

  // @override
  // void onMenuListSuccess(MenuResponse data) {
  //   if (data.success!) {
  //     dashboardList = [];
  //     dashboardList.addAll(data.value!);
  //
  //     sTitle = sApplicationName;
  //     lastUpdate = data.lastUpload!;
  //
  //     setState(() {});
  //   } else {
  //     if (data.resultMessage! != null) {
  //       toastMassage(data.resultMessage!);
  //     }
  //   }
  // }

  // @override
  // void onDrawerMenuListSuccess(MenuResponse data) {
  //   if (data.success!) {
  //     drawerList = [];
  //     drawerList.addAll(data.value!);
  //
  //     sTitle = sApplicationName;
  //     lastUpdate = data.lastUpload!;
  //
  //     setState(() {});
  //   } else {
  //     if (data.resultMessage! != null) {
  //       toastMassage(data.resultMessage!);
  //     }
  //   }
  // }

  // @override
  // void onVersionUpdateSuccess(VersionUpdateResponse data) {
  //   if (data.success!) {
  //     // checkVersionUpdate(data!.value!);
  //   } else {
  //     if (data.resultMessage! != null) {
  //       toastMassage(data.resultMessage!);
  //     }
  //   }
  // }

  @override
  void onCompanyListSuccess(FilterResponse data) {
    if (data.success!) {
      companyList = data.value!;
      companyListDialog(context);
    } else {
      if (data.resultMessage! != null) {
        // toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  void onUpdateCompanySuccess(CommonResponse data, String compId, String compName) {
    if (data != null) {
      toastMassage(data.resultMessage!);
      setState(() {
        selectedCompany!.name = compName;
        selectedCompany!.id = int.parse(compId.isEmpty ? "0" : compId);
      });
    }
  }

  @override
  void getAppInitialAPI(AppInitialResponse data) {
    if (data.success!) {
      try {
        drawerList = [];
        drawerList.addAll(data.value!.drawerMenu!);

        dashboardList = [];
        dashboardList.addAll(data.value!.dashboard!);

        if (data.bannerURLs != null && data.bannerURLs!.isNotEmpty) {
          bannerList = [];
          bannerList.addAll(data.bannerURLs!.split(';'));
        }

        if (data.videoURL!.isNotEmpty) {
          checkAndNavigate(data.videoURL!);
        }

        sTitle = sApplicationName;
        lastUpdate = data.lastUpload!;

        selectedCompany!.id = userData!.value!.companyId;
        selectedCompany!.name = userData!.value!.companyName;

        checkVersionUpdate(data.value!.appVersion!);
      } catch (e) {
        print(e);
      }
      setState(() {});
    }
  }

  @override
  void onLogoutSuccess(CommonResponse data) {
    PreferenceData.clearData();
    Get.offAllNamed('/login');
  }
}
