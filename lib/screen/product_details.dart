import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/static_data.dart';
import '../utils/color.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  StaticData? staticData;

  @override
  void initState() {
    super.initState();

    staticData = Get.arguments;

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              actionBar(context, 'Product Details', true),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          // margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          elevation: 1,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Image.asset(
                                  staticData!.icon,
                                  height: 200,
                                  // width: 35,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      staticData!.name,
                                      style: bodyText2(colorBlack),
                                    ),
                                    verticalView(),
                                    Text(
                                      'Rate : ${staticData!.rate}',
                                      style: bodyText1(colorBlack),
                                    ),
                                  ],
                                ),
                              ),

                              // const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        verticalViewBig(),
                        Text(
                          'Inquiry',
                          style: heading2(colorBlack),
                        ),

                        verticalViewBig(),


                        Text(
                          sFullName,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, fullNameController, sFullName, '', false, true),
                        verticalViewBig(),

                        Text(
                          sPhoneNumber,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, phoneNumberController, sPhoneNumber, '', false, true),
                        verticalViewBig(),

                        Text(
                          sEmail,
                          style: blackRegular(),
                        ),
                        verticalView(),
                        textField(context, emailController, sEmail, '', false, true),
                        verticalViewBig(),
                        verticalView(),
                        InkWell(
                            onTap: (() {
                              //onClickSubmit();
                              Get.back();
                            }),
                            child: btnHalf(context, sSubmit)),
                        verticalViewBig(),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
