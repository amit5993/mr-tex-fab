import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:td/model/contact_master_response.dart';
import 'package:td/utils/images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presenter/contact_master_presenter.dart';
import '../utils/color.dart';
import '../utils/widget.dart';

class ContactMaster extends StatefulWidget {
  const ContactMaster({super.key});

  @override
  State<ContactMaster> createState() => _ContactMasterState();
}

class _ContactMasterState extends State<ContactMaster> implements ContactMasterView {
  ContactMasterPresenter? _presenter;
  List<ContactMasterData> list = [];

  final ScrollController _scrollController = ScrollController();
  var page = 0;
  var search = '';

  _ContactMasterState() {
    _presenter = ContactMasterPresenter(this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _presenter!.getContactMaster(page, search);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        page++;
        _presenter!.getContactMaster(page, search);
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
                      _presenter!.getContactMaster(page, search);
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
                      return Column(
                        children: [
                          Visibility(visible: i == 0, child: verticalView()),
                          divider(),
                          Container(
                            color: colorWhite,
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: HtmlWidget(
                                              data.contactDetail!,
                                            ),
                                          ),
                                          InkWell(
                                              onTap: (() async {
                                                await Clipboard.setData(ClipboardData(text: data.copyContent!));
                                                toastMassage('Copied to your clipboard !');
                                              }),
                                              child: Icon(Icons.copy)),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            'Mobile : ',
                                            style: bodyText2(colorGray),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.mobile!,
                                              style: bodyText2(colorAppLite),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data.mobile!.trim().isNotEmpty,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: (() {
                                                    _makePhoneCall(data.mobile!);
                                                  }),
                                                  child: Image.asset(
                                                    icCall,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                InkWell(
                                                  onTap: (() {
                                                    _makeWhatsapp(data.mobile!);
                                                  }),
                                                  child: Image.asset(
                                                    icWhatsapp,
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            'Email : ',
                                            style: bodyText2(colorGray),
                                          ),
                                          Text(
                                            data.email!,
                                            style: bodyText2(colorBlack),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          divider(),
                          verticalView()
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeWhatsapp(String phone) async {
    String url = '';

    if (Platform.isAndroid) {
      url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull('Hello')}";
    } else {
      url = "whatsapp://wa.me/$phone/?text=${Uri.encodeFull('Hello')}";
    }
    await launchUrl(Uri.parse(url));
  }

  @override
  void onContactMasterSuccess(ContactMasterResponse data) {
    if (data.success!) {
      if (data.value! != null) {
        if (data.value!.isNotEmpty) {
          if(page == 0){
            list.clear();
          }
          setState(() {
            list.addAll(data.value!);
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
  void onError(int errorCode) {
    // TODO: implement onError
  }
}
