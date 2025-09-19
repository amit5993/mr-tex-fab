import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/static_data.dart';
import '../utils/color.dart';
import '../utils/images.dart';
import '../utils/widget.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {

  List<StaticData> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    list.add(StaticData('Grey Kora Silk', '2908', images1));
    list.add(StaticData('Mehendi Green Kora Silk', '6499', images2));
    list.add(StaticData('Beige Kora Silk', '3999', images3));
    list.add(StaticData('Mustard Yellow Dola Silk', '2609', images4));
    list.add(StaticData('Multicolor Ombre Saree', '2099', images5));
    list.add(StaticData('Peach Stone And Bead Embellished', '1999', images6));
    list.add(StaticData('Multicolor Organza Saree', '2309', images7));
    list.add(StaticData('Gold Net Saree', '5499', images8));
    list.add(StaticData('Peach Sheer Saree', '2499', images9));
    list.add(StaticData('Beige Mirror Work Saree', '2100', images10));
    list.add(StaticData('Black Stone Embellished Saree ', '2299', images11));
    list.add(StaticData('Multicolor Shaded Saree', '2499', images12));



  }



  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colorLightGrayBG,
          body: Column(
            children: [
              actionBar(context, 'Product List', true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, childAspectRatio: 3 / 2.5, crossAxisSpacing: 5, mainAxisSpacing: 5),
                      itemCount: list.length,
                      itemBuilder: (BuildContext ctx, index) {
                        var data = list[index];
                        return InkWell(
                          onTap: (() {

                            Get.toNamed('/product_details', arguments: data);

                          }),
                          child: Card(
                            // margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            elevation: 1,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    data.icon,
                                    // height: 35,
                                    // width: 35,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data.name,
                                          style: bodyText2(colorBlack),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // Text(
                                      //   'Want this?',
                                      //   style: bodyText3(colorBlue),
                                      // ),
                                    ],
                                  ),
                                ),
                                // const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
