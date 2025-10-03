import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:td/model/user_manager_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/common_search_bar.dart';
import '../common/password_detail.dart';
import '../model/common_response.dart';
import '../model/user_filter_data.dart';
import '../presenter/user_manager_presenter.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

  @override
  State<UserManager> createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager> implements UserManagerView {
  UserManagerPresenter? _presenter;
  List<AppUserListModel> userList = [];
  List<UserFilterData> filterList = [];

  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';

  bool isDescending = false;
  int selectedMode = 1;

  late UserFilterData selectedFilter;

  _UserManagerState() {
    _presenter = UserManagerPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    filterList.add(UserFilterData("All", "", true));
    filterList.add(UserFilterData("User Name", "UserName", false));
    filterList.add(UserFilterData("First Name", "FirstName", false));
    filterList.add(UserFilterData("Party Name", "PartyName", false));
    filterList.add(UserFilterData("Last Active", "LastActive", false));

    selectedFilter = filterList[0];

    _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
        print('call api');
      }
    });
  }

  Widget getSearchBarUI() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 48,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: colorBlack.withOpacity(0.1), // Shadow color with transparency
        //     spreadRadius: 1, // How much the shadow spreads
        //     blurRadius: 1, // Softness of the shadow
        //     offset: Offset(0, 1), // Offset in x and y direction
        //   ),
        // ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                style: heading1(colorText),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: InputBorder.none,
                  helperStyle: bodyText2(colorGray),
                  labelStyle: bodyText2(colorGray),
                  // contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                ),
                onEditingComplete: () {},
                onChanged: (string) {
                  setState(() {
                    search = string;
                    page = 0;
                    userList.clear();
                    _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            width: 60,
            height: 60,
            child: Icon(Icons.search, color: colorLightGray),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorBG,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var data = await Get.toNamed('/add_edit_user');
              if (data != null) {
                if (data) {
                  page = 0;
                  search = '';
                  userList = [];
                  _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
                }
              }
            },
            backgroundColor: colorApp,
            child: const Icon(Icons.add, color: colorWhite),
          ),
          body: Column(
            children: [
              // actionBar(context, sUserManage, true),

              CommonSearchBar(
                onSearchChanged: (string) {
                  setState(() {
                    search = string;
                    page = 0;
                    userList.clear();
                    _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
                  });
                },
                labelStyle: bodyText2(colorGray),
                inputStyle: heading1(colorText),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           textInputAction: TextInputAction.search,
              //           style: bodyText2(colorBlack),
              //           decoration: InputDecoration(
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(25.0),
              //               borderSide: const BorderSide(
              //                 color: Colors.grey,
              //               ),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(20.0),
              //               borderSide: const BorderSide(
              //                 color: colorApp,
              //               ),
              //             ),
              //             suffixIcon: const InkWell(
              //               child: Icon(Icons.search),
              //             ),
              //             contentPadding: const EdgeInsets.all(15.0),
              //             hintText: 'Search',
              //           ),
              //           onChanged: (string) {
              //             setState(() {
              //               search = string;
              //               page = 0;
              //               userList.clear();
              //               _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
              //             });
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
                child: Row(
                  children: [
                    // Text(
                    //   'Sorting',
                    //   style: bodyText2(colorBlack),
                    // ),
                    // horizontalView(),
                    Expanded(
                      child: InkWell(
                        onTap: (() {
                          bottomFilterDialog();
                        }),
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorWhite,
                            border: Border.all(color: colorGray, width: 0.1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: colorBlack.withOpacity(0.1), // Shadow color with transparency
                            //     spreadRadius: 1, // How much the shadow spreads
                            //     blurRadius: 1, // Softness of the shadow
                            //     offset: Offset(0, 1), // Offset in x and y direction
                            //   ),
                            // ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedFilter.name,
                                    style: heading1(colorBlack),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    horizontalViewSmall(),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorWhite,
                        border: Border.all(color: colorGray, width: 0.1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: colorBlack.withOpacity(0.1), // Shadow color with transparency
                        //     spreadRadius: 1, // How much the shadow spreads
                        //     blurRadius: 1, // Softness of the shadow
                        //     offset: Offset(0, 1), // Offset in x and y direction
                        //   ),
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (() {
                                setState(() {
                                  if (isDescending) {
                                    isDescending = false;
                                    page = 0;
                                    _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
                                  }
                                });
                              }),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      //color: isDescending ? colorApp : colorGray,
                                      border: Border.all(
                                        width: 1.0,
                                        color: isDescending ? colorGray : colorApp,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(1),
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: isDescending ? Colors.transparent : colorApp,
                                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Asc',
                                    style: bodyText2(colorBlack),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: (() {
                                setState(() {
                                  if (!isDescending) {
                                    isDescending = true;
                                    page = 0;
                                    _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
                                  }
                                });
                              }),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      //color: isDescending ? colorApp : colorGray,
                                      border: Border.all(
                                        width: 1.0,
                                        color: isDescending ? colorApp : colorGray,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(1),
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: isDescending ? colorApp : Colors.transparent,
                                        borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Desc',
                                    style: bodyText2(colorBlack),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: userList == null ? 0 : userList.length,
                    itemBuilder: (BuildContext context, i) {
                      var data = userList[i];
                      return userListCell(data, i);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget userListCell(AppUserListModel data, int i) {
    return Column(
      children: [
        Visibility(visible: i == 0, child: verticalView()),
        // divider(),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //color: colorWhite,
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: colorGray.withOpacity(0.2), // Shadow color with transparency
            //     spreadRadius: 1, // How much the shadow spreads
            //     blurRadius: 4, // Softness of the shadow
            //     offset: Offset(0, 1), // Offset in x and y direction
            //   ),
            // ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.firstName!} ${data.lastName!}',
                            style: heading4(colorBlack),
                          ),
                          //const SizedBox(height: 3),
                          Text(
                            data.lastActive!.isEmpty ? '' : 'Last Seen ${data.lastActive!}',
                            style: bodyText1(colorGray),
                          ),
                        ],
                      ),
                    ),
                    horizontalView(),
                    Container(
                      decoration: BoxDecoration(
                          color: (data.isActive! ? colorGreen : colorRed).withOpacity(0.2),
                          border: Border.all(color: data.isActive! ? colorGreen : colorRed, width: 0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                        child: Text(
                          data.isActive! ? 'ACTIVE' : 'INACTIVE',
                          style: bodyText3(data.isActive! ? colorGreen : colorRed),
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: (() {
                    //     confirmationDialog(context, i, data.userId!, data.clientId!);
                    //   }),
                    //   child: Container(
                    //     height: 30,
                    //     width: 30,
                    //     decoration:
                    //         const BoxDecoration(color: colorRed, borderRadius: BorderRadius.all(Radius.circular(20))),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(6.0),
                    //       child: Image.asset(
                    //         icDelete,
                    //         color: colorWhite,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalViewSmall(),
                  userDetails('Role : ', data.roleName!),
                  userDetails('Email : ', data.emailId!),
                  userDetails('Mobile : ', data.smSmobile!),
                  //userDetails('Password : ', data.password!),
                  PasswordDetail('Password : ', data.password!),
                  userDetails('Party : ', data.partyName!),
                  verticalViewSmall()
                ],
              ),

              divider(),
              verticalView(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: horizontalView()),
                  InkWell(
                    onTap: (() async {
                      var returnData = await Get.toNamed('/add_edit_user', arguments: data) as bool;
                      if (returnData != null) {
                        if (returnData) {
                          page = 0;
                          search = '';
                          _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
                        }
                      }
                    }),
                    child: iconWidget(colorBox1, icEdit),
                  ),
                  Expanded(child: horizontalView()),
                  InkWell(
                    onTap: (() async {
                      //confirmationDialog1(context, i, data.userId!, data.clientId!);
                      customConfirmationDialog(
                          context, 'Confirmation...!', 'Are you sure you want to delete this user?', 'Yes', 'No', () {
                        _presenter!.deleteUser(i, data.clientId!, data.userId!);
                      });
                    }),
                    child: iconWidget(const Color(0xFFF44336), icDelete),
                  ),
                  Expanded(child: horizontalView()),
                  Visibility(
                    visible: data.content!.isNotEmpty,
                    child: InkWell(
                      onTap: (() async {
                        await Clipboard.setData(ClipboardData(text: data.content!));
                        toastMassage('Copied to your clipboard !');
                      }),
                      child: iconWidget(colorBox2, icCopy),
                    ),
                  ),
                  Expanded(child: horizontalView()),
                  Visibility(
                    visible: data.smSmobile!.isNotEmpty && data.content!.isNotEmpty,
                    child: InkWell(
                      onTap: (() async {
                        _makeWhatsapp(data.smSmobile!, data.content!);
                      }),
                      child: iconWidget(const Color(0xFF25D366), icWhatsappBlack),
                    ),
                  ),
                  Expanded(child: horizontalView()),
                  InkWell(
                    onTap: (() async {}),
                    child: iconWidget(colorBox3, icLogout),
                  ),
                  Expanded(child: horizontalView()),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     InkWell(
              //       onTap: (() async {
              //         var returnData = await Get.toNamed('/add_edit_user', arguments: data) as bool;
              //         if (returnData != null) {
              //           if (returnData) {
              //             page = 0;
              //             search = '';
              //             _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
              //           }
              //         }
              //       }),
              //       child: Container(
              //         width: MediaQuery.of(context).size.width / 5,
              //         decoration: const BoxDecoration(
              //             color: colorBox1, borderRadius: BorderRadius.all(Radius.circular(5))),
              //         child: Padding(
              //           padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              //           child: Center(
              //             child: Text(
              //               'Edit',
              //               style: bodyText2(colorWhite),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 5),
              //
              //     InkWell(
              //       onTap: (() async {
              //         confirmationDialog(context, i, data.userId!, data.clientId!);
              //       }),
              //       child: Container(
              //         width: MediaQuery.of(context).size.width / 5,
              //         decoration: const BoxDecoration(
              //             color: colorRed, borderRadius: BorderRadius.all(Radius.circular(5))),
              //         child: Padding(
              //           padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              //           child: Center(
              //             child: Text(
              //               'Delete',
              //               style: bodyText2(colorWhite),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 5),
              //
              //     Visibility(
              //       visible: data.content!.isNotEmpty,
              //       child: InkWell(
              //         onTap: (() async {
              //           await Clipboard.setData(ClipboardData(text: data.content!));
              //           toastMassage('Copied to your clipboard !');
              //         }),
              //         child: Container(
              //           width: MediaQuery.of(context).size.width / 5,
              //           decoration: const BoxDecoration(
              //               color: colorBox2, borderRadius: BorderRadius.all(Radius.circular(5))),
              //           child: Padding(
              //             padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              //             child: Center(
              //               child: Text(
              //                 'Copy',
              //                 style: bodyText2(colorWhite),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 5),
              //     Visibility(
              //       visible: data.smSmobile!.isNotEmpty && data.content!.isNotEmpty,
              //       child: InkWell(
              //         onTap: (() async {
              //           _makeWhatsapp(data.smSmobile!, data.content!);
              //         }),
              //         child: Container(
              //           width: MediaQuery.of(context).size.width / 5,
              //           decoration: const BoxDecoration(
              //               color: colorBox4, borderRadius: BorderRadius.all(Radius.circular(5))),
              //           child: Padding(
              //             padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              //             child: Center(
              //               child: Text(
              //                 'Whatsapp',
              //                 style: bodyText2(colorWhite),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              verticalView(),
            ],
          ),
        ),
        // divider(),
        verticalView()
      ],
    );
  }

  Widget userDetails(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      child: Row(
        children: [
          Text(
            key,
            style: bodyText4(colorGray),
          ),
          Text(
            value,
            style: bodyText4(colorBlack),
          ),
        ],
      ),
    );
  }

  Widget iconWidget(Color color, String icon) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color, //colorBox4,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.2), // Shadow color with transparency
            spreadRadius: 1, // How much the shadow spreads
            blurRadius: 4, // Softness of the shadow
            offset: Offset(0, 1), // Offset in x and y direction
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          icon,
          color: colorWhite,
        ),
      ),
    );
  }

  bottomFilterDialog() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    color: colorApp,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          'Select Filter',
                          style: heading1(colorWhite),
                        ),
                      ),
                    )),
                Expanded(
                  child: ListView.builder(
                      itemCount: filterList == null ? 0 : filterList.length,
                      itemBuilder: (BuildContext context, i) {
                        var data = filterList[i];
                        return InkWell(
                          onTap: (() {
                            setState(() {
                              for (int j = 0; filterList.length > j; j++) {
                                filterList[j].isSelected = false;
                              }

                              data.isSelected = true;
                              selectedFilter = data;
                              _presenter!.getUserManagerList(page, search, selectedFilter.key, isDescending);
                            });
                            Get.back();
                          }),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Visibility(visible: i == 0, child: verticalView()),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    data.name,
                                    style: data.isSelected ? heading1(colorBlue) : bodyText2(colorBlack),
                                  ),
                                ),
                              ),
                              divider()
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _makeWhatsapp(String phone, String text) async {
    String url = '';

    if (Platform.isAndroid) {
      url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull(text)}";
    } else {
      url = "whatsapp://wa.me/$phone/?text=${Uri.encodeFull(text)}";
    }
    await launchUrl(Uri.parse(url));
  }

  // confirmationDialog(BuildContext context, int index, int userId, int clientId) {
  //   showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: colorOffWhite,
  //           title: const Text("Delete!", style: TextStyle(fontSize: 18, color: colorBlack, fontFamily: "Medium")),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text('Are you sure you want to delete this user?', style: blackTitle1()),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text(
  //                 "NO",
  //                 style: heading1(colorApp),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: Text(
  //                 "YES",
  //                 style: heading1(colorApp),
  //               ),
  //               onPressed: () {
  //                 Get.back();
  //                 _presenter!.deleteUser(index, clientId, userId);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }
  //
  // confirmationDialog1(BuildContext context, int index, int userId, int clientId) {
  //   showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         elevation: 0,
  //         backgroundColor: Colors.transparent,
  //         child: Container(
  //           //padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: colorOffWhite,
  //             shape: BoxShape.rectangle,
  //             borderRadius: BorderRadius.circular(16),
  //             boxShadow: const [
  //               BoxShadow(
  //                 color: Colors.black26,
  //                 blurRadius: 10.0,
  //                 offset: Offset(0.0, 10.0),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Custom Header
  //               Container(
  //                 padding: const EdgeInsets.symmetric(vertical: 12),
  //                 decoration: BoxDecoration(
  //                   color: colorApp.withOpacity(0.1),
  //                   borderRadius: const BorderRadius.only(
  //                     topLeft: Radius.circular(8),
  //                     topRight: Radius.circular(8),
  //                   ),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const Icon(
  //                       Icons.warning_rounded,
  //                       color: colorApp,
  //                       size: 24,
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Text(
  //                       "Confirmation...!",
  //                       style: heading3(colorApp),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               // Content
  //               Text(
  //                 'Are you sure you want to delete this user?',
  //                 style: bodyText4(colorBlack),
  //                 textAlign: TextAlign.center,
  //               ),
  //
  //               verticalViewBig(),
  //               verticalViewBig(),
  //
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   // No Button
  //                   InkWell(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(color: colorApp),
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: Text(
  //                         "Cancel",
  //                         style: bodyText2(colorApp),
  //                       ),
  //                     ),
  //                   ),
  //
  //                   horizontalView(),
  //                   InkWell(
  //                     onTap: () {
  //                       Get.back();
  //                       _presenter!.deleteUser(index, clientId, userId);
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //                       decoration: BoxDecoration(
  //                         color: colorApp,
  //                         borderRadius: BorderRadius.circular(8),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: colorApp.withOpacity(0.3),
  //                             blurRadius: 4,
  //                             offset: const Offset(0, 2),
  //                           ),
  //                         ],
  //                       ),
  //                       child: Text(
  //                         "Delete",
  //                         style: bodyText2(colorWhite),
  //                       ),
  //                     ),
  //                   ),
  //                   horizontalView(),
  //                 ],
  //               ),
  //               verticalViewBig(),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  void onError(int errorCode) {}

  @override
  void onUserManagerSuccess(UserManagerResponse data) {
    if (data.success!) {
      if (data.value! != null) {
        if (data.value!.appUserListModel!.isNotEmpty) {
          if (page == 0) {
            userList.clear();
          }

          setState(() {
            userList.addAll(data.value!.appUserListModel!);
          });
        }
      }
    } else {
      page--;
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }

  @override
  void onDeleteUserSuccess(CommonResponse data, int index) {
    if (data.success!) {
      toastMassage('Success');
      setState(() {
        userList.removeAt(index);
      });
    } else {
      toastMassage(data.resultMessage!);
    }
  }
}
