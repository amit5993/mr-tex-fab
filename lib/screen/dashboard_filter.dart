import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:td/screen/sale_purchase_report.dart';
import 'package:td/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/utils.dart';
import '../model/chart_data.dart';
import '../model/dashboard_filter_response.dart';
import '../model/dashboard_response.dart';
import '../presenter/dashboard_filter_presenter.dart';
import '../utils/images.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class DashboardFilter extends StatefulWidget {
  const DashboardFilter({super.key});

  @override
  State<DashboardFilter> createState() => _DashboardFilterState();
}

class _DashboardFilterState extends State<DashboardFilter> implements DashboardFilterView {
  DashboardData? data;
  List<String> filterSearchList = [];
  List<String> filterList = [];
  List<Company> companyList = [];
  List<DashboardFilterData> list = [];

  var search = '';
  var sortBy = '';
  var mode = '';
  var selectedGroup = '';
  Company? selectedCompany;

  var selectedReportMode = 'Normal Mode';
  var selectedRow = '10';

  DashboardFilterPresenter? _presenter;

  _DashboardFilterState() {
    _presenter = DashboardFilterPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
    mode = data!.mode!;
    filterList = data!.filter!;
    companyList = data!.company!;

    if (filterList.isNotEmpty) {
      selectedGroup = filterList[0];
    }

    setDefaultCompany();

    filterSearchList.add("Name Asc");
    filterSearchList.add("Name Desc");
    filterSearchList.add("Amount Asc");
    filterSearchList.add("Amount Desc");

    sortBy = 'Amount Desc';

    _presenter!.getDashboardFilter(search, sortBy, mode, selectedGroup, selectedCompany!.id!.toString());
  }

  setDefaultCompany() {
    if (companyList.isNotEmpty) {
      // Get saved company ID and name from preferences
      String? savedCompanyId = PreferenceData.getSelectedCompanyId().toString();
      String? savedCompanyName = PreferenceData.getSelectedCompanyName();

      // Try to find the saved company in the company list
      if (savedCompanyId != null && savedCompanyId != "null" && savedCompanyId.isNotEmpty) {
        // Find company in the list that matches the saved ID
        Company? matchedCompany = companyList.firstWhere(
              (company) => company.id.toString() == savedCompanyId,
          orElse: () => companyList[0], // Default to first company if not found
        );

        selectedCompany = matchedCompany;
      } else {
        // If no saved company or invalid data, default to first company
        selectedCompany = companyList[0];
      }
    }
  }

  // List<ChartData> _mapDashboardFilterDataToChartData(List<DashboardFilterData> dataList) {
  //   return dataList.map((filterData) {
  //     return ChartData(
  //       filterData.data ?? "Unknown", // Use a default string if `data` is null.
  //       double.tryParse(filterData.value ?? "0") ?? 0.0, // Parse `value` as double.
  //     );
  //   }).toList();
  // }

  List<ChartData> _mapDashboardFilterDataToChartData(List<DashboardFilterData> dataList) {
    List<DashboardFilterData> filteredChartData;
    if (selectedRow == 'All') {
      filteredChartData = dataList;
    } else {
      final limit = int.tryParse(selectedRow) ?? dataList.length;
      filteredChartData = dataList.take(limit).toList();
    }

    return filteredChartData.map((filterData) {
      return ChartData(
        filterData.data ?? "Unknown", // Use a default string if `data` is null.
        double.tryParse(filterData.value ?? "0") ?? 0.0, // Parse `value` as double.
      );
    }).toList();
  }

  // Dropdown for chart type
  String selectedChartType = 'Line Chart'; // Default chart type
  final List<String> chartTypes = [
    'Line Chart',
    'Area Chart',
    'Spline Chart',
    'Column Chart',
    'Step Line Chart',
    'Bar Chart',
    'Spline Area Chart'
  ];

  Widget _buildChart() {
    switch (selectedChartType) {
      case 'Area Chart':
        return SfCartesianChart(
          // primaryXAxis: CategoryAxis(),
          primaryXAxis: const CategoryAxis(
            labelRotation: 90,
            maximumLabels: 10,
            labelPlacement: LabelPlacement.betweenTicks,
            interval: 1,
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            AreaSeries<ChartData, String>(
              dataSource: _mapDashboardFilterDataToChartData(list),
              xValueMapper: (ChartData data, _) => data.data.length > 10 ? '${data.data.substring(0, 10)}…' : data.data,
              yValueMapper: (ChartData data, _) => data.sales,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
      case 'Spline Chart':
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelRotation: 90, // 👈 makes labels vertical
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            SplineSeries<ChartData, String>(
              dataSource: _mapDashboardFilterDataToChartData(list),
              xValueMapper: (ChartData data, _) => data.data.length > 10 ? '${data.data.substring(0, 10)}…' : data.data,
              yValueMapper: (ChartData data, _) => data.sales,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
      case 'Column Chart':
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelRotation: 90, // 👈 makes labels vertical
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            ColumnSeries<ChartData, String>(
              dataSource: _mapDashboardFilterDataToChartData(list),
              xValueMapper: (ChartData data, _) => data.data.length > 10 ? '${data.data.substring(0, 10)}…' : data.data,
              yValueMapper: (ChartData data, _) => data.sales,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
      case 'Step Line Chart':
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelRotation: 90, // 👈 makes labels vertical
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            StepLineSeries<ChartData, String>(
              dataSource: _mapDashboardFilterDataToChartData(list),
              xValueMapper: (ChartData data, _) => data.data.length > 10 ? '${data.data.substring(0, 10)}…' : data.data,
              yValueMapper: (ChartData data, _) => data.sales,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
      case 'Bar Chart':
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelRotation: 90, // 👈 makes labels vertical
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            BarSeries<ChartData, String>(
              dataSource: _mapDashboardFilterDataToChartData(list),
              xValueMapper: (ChartData data, _) => data.data.length > 10 ? '${data.data.substring(0, 10)}…' : data.data,
              yValueMapper: (ChartData data, _) => data.sales,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
      case 'Spline Area Chart':
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelRotation: 90, // 👈 makes labels vertical
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            SplineAreaSeries<ChartData, String>(
              dataSource: _mapDashboardFilterDataToChartData(list),
              xValueMapper: (ChartData data, _) => data.data.length > 10 ? '${data.data.substring(0, 10)}…' : data.data,
              yValueMapper: (ChartData data, _) => data.sales,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
      default: // Line chart
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelRotation: 90, // 👈 makes labels vertical
          ),
          series: <CartesianSeries<dynamic, dynamic>>[
            LineSeries<ChartData, String>(
              dataSource: _mapDashboardFilterDataToChartData(list),
              xValueMapper: (ChartData data, _) => data.data.length > 10 ? '${data.data.substring(0, 10)}…' : data.data,
              yValueMapper: (ChartData data, _) => data.sales,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
    }
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
                decoration: const BoxDecoration(
                    color: colorApp,
                    // border: Border.all(color: colorGray),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
                child: Column(
                  children: [
                    actionBar(context, data!.mode!, true),
                    InkWell(
                      onTap: (() async {
                        bottomCompanyDialog();
                      }),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: BoxDecoration(
                            // color: colorOffWhite,
                            border: Border.all(color: colorWhite, width: 0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedCompany!.name!,
                                  style: bodyText2(colorWhite),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 20,
                                color: colorWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$sGroup By',
                              style: bodyText3(colorOffWhite),
                            ),
                          ),
                          horizontalView(),
                          Expanded(
                            child: Text(
                              'Sort By',
                              style: bodyText3(colorOffWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (() async {
                              bottomFilterDialog();
                            }),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                              decoration: BoxDecoration(
                                  // color: colorOffWhite,
                                  border: Border.all(color: colorWhite, width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedGroup,
                                        style: bodyText2(colorWhite),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 20,
                                      color: colorWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (() async {
                              bottomSortByFilterDialog();
                            }),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                              decoration: BoxDecoration(
                                  // color: colorOffWhite,
                                  border: Border.all(color: colorWhite, width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        sortBy,
                                        style: bodyText2(colorWhite),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 20,
                                      color: colorWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalView(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Report Mode',
                              style: bodyText3(colorOffWhite),
                            ),
                          ),
                          horizontalView(),
                          Visibility(
                            visible: selectedReportMode == 'Chart Mode',
                            child: Expanded(
                              child: Text(
                                'Chart Type',
                                style: bodyText3(colorOffWhite),
                              ),
                            ),
                          ),
                          horizontalView(),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text(
                              'Row',
                              style: bodyText3(colorOffWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (() async {
                              bottomReportModeSelectionDialog();
                            }),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                              decoration: BoxDecoration(
                                  // color: colorOffWhite,
                                  border: Border.all(color: colorWhite, width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedReportMode,
                                        style: bodyText2(colorWhite),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 20,
                                      color: colorWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: selectedReportMode == 'Chart Mode',
                          child: Expanded(
                            child: InkWell(
                              onTap: (() async {
                                showChartTypeBottomSheet();
                              }),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                decoration: BoxDecoration(
                                    // color: colorOffWhite,
                                    border: Border.all(color: colorWhite, width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedChartType,
                                          style: bodyText2(colorWhite),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down_outlined,
                                        size: 20,
                                        color: colorWhite,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: InkWell(
                            onTap: (() async {
                              bottomRowDialog();
                            }),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                  // color: colorOffWhite,
                                  border: Border.all(color: colorWhite, width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedRow,
                                        style: bodyText2(colorWhite),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 20,
                                      color: colorWhite,
                                    ),
                                  ],
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
              selectedReportMode == 'Chart Mode'
                  ? Expanded(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            selectedChartType,
                            style: heading2(colorText),
                          ),
                          verticalViewBig(),
                          _buildChart(),
                        ],
                      ),
                    ))
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                style: bodyText2(colorBlack),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
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
                                  contentPadding: const EdgeInsets.all(10.0),
                                  hintText: 'Search',
                                ),
                                onChanged: (string) {
                                  setState(() {
                                    search = string;
                                    // page = 0;
                                    list.clear();
                                    _presenter!.getDashboardFilter(
                                        search, sortBy, mode, selectedGroup, selectedCompany!.id!.toString());
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: list == null ? 0 : list.length,
                                  itemBuilder: (BuildContext context, i) {
                                    var data = list[i];
                                    return Column(
                                      children: [
                                        Card(
                                          //margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          color: colorWhite,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data.data!,
                                                        style: heading2(colorText),
                                                      ),
                                                    ),
                                                    Text(
                                                      Utils.formatAmount(data.value!),
                                                      style: heading2(colorApp),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                    visible:
                                                        data.line1!.trim().isNotEmpty && data.line2!.trim().isNotEmpty,
                                                    child: verticalView()),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Visibility(
                                                        visible: data.line1!.trim().isNotEmpty &&
                                                            data.line2!.trim().isNotEmpty,
                                                        child: Text(
                                                          '${data.line1!}, ${data.line2!}',
                                                          style: bodyText2(colorText),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Visibility(
                                                          visible: data.phone!.trim().isNotEmpty,
                                                          child: InkWell(
                                                            onTap: (() {
                                                              _makePhoneCall(data.phone!);
                                                            }),
                                                            child: Image.asset(
                                                              icCall,
                                                              height: 25,
                                                              width: 25,
                                                              color: colorBox1,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Visibility(
                                                          visible: data.menuName!.trim().isNotEmpty,
                                                          child: InkWell(
                                                            onTap: (() {
                                                              // _makePhoneCall(data.phone!);
                                                              // toastMassage(data.menuName!+ ' '+ data.repName!+ ' ' + data.keyValue!);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => SalePurchaseReport(
                                                                        key: Key(data.menuName!),
                                                                        type: data.menuName!,
                                                                        dashboardFilterData: data)),
                                                              );
                                                            }),
                                                            child: Image.asset(
                                                              icInfo,
                                                              height: 28,
                                                              width: 28,
                                                              color: colorBox2,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Visibility(
                                                          visible: data.phone!.trim().isNotEmpty,
                                                          child: InkWell(
                                                            onTap: (() {
                                                              _makeWhatsapp(data.phone!, data.content!);
                                                            }),
                                                            child: Image.asset(
                                                              icWhatsapp,
                                                              height: 25,
                                                              width: 25,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // divider(),
                                        // verticalView()
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Future<void> _makeWhatsapp(String phone, String msg) async {
    String url = '';

    if (Platform.isAndroid) {
      url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull(msg)}";
    } else {
      url = "whatsapp://wa.me/$phone/?text=${Uri.encodeFull(msg)}";
    }
    await launchUrl(Uri.parse(url));
  }

  bottomSortByFilterDialog() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      color: colorApp,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select Sort Filter',
                                style: heading1(colorWhite),
                              ),
                            ),
                            InkWell(
                              onTap: (() {
                                Get.back();
                              }),
                              child: Text(
                                'Close',
                                style: heading1(colorWhite),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: filterSearchList == null ? 0 : filterSearchList.length,
                        itemBuilder: (BuildContext context, i) {
                          var data = filterSearchList[i];
                          return InkWell(
                            onTap: (() {
                              setState(() {
                                sortBy = data;
                                _presenter!.getDashboardFilter(
                                    search, sortBy, mode, selectedGroup, selectedCompany!.id!.toString());
                              });
                              Get.back();
                            }),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Visibility(visible: i == 0, child: verticalView()),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    data,
                                    style: bodyText2(colorBlack),
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
            ),
          );
        });
  }

  bottomFilterDialog() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      color: colorApp,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            'Select Group',
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
                                selectedGroup = data;

                                _presenter!.getDashboardFilter(
                                    search, sortBy, mode, selectedGroup, selectedCompany!.id!.toString());
                              });
                              Get.back();
                            }),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Visibility(visible: i == 0, child: verticalView()),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      data.toString(),
                                      style: bodyText2(colorBlack),
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
            ),
          );
        });
  }

  bottomCompanyDialog() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      color: colorApp,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            'Select Company',
                            style: heading1(colorWhite),
                          ),
                        ),
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: companyList == null ? 0 : companyList.length,
                        itemBuilder: (BuildContext context, i) {
                          var data = companyList[i];
                          return InkWell(
                            onTap: (() {
                              setState(() {
                                selectedCompany = data;
                                _presenter!.getDashboardFilter(
                                    search, sortBy, mode, selectedGroup, selectedCompany!.id!.toString());
                              });
                              Get.back();
                            }),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Visibility(visible: i == 0, child: verticalView()),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      data.name!,
                                      style: bodyText2(colorBlack),
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
            ),
          );
        });
  }

  void bottomReportModeSelectionDialog() {
    final List<String> modeOptions = ['Normal Mode', 'Chart Mode'];

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                color: colorApp,
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    'Select Report Mode',
                    style: heading1(colorWhite),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: modeOptions.length,
                  separatorBuilder: (context, index) => divider(),
                  itemBuilder: (context, index) {
                    final option = modeOptions[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedReportMode = option;
                        });
                        Navigator.pop(context); // Close bottom sheet
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Text(
                            option,
                            style: bodyText2(colorBlack),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void bottomRowDialog() {
    final List<String> rowOptions = ['3','5', '10', 'All'];

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                color: colorApp,
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    'Select Row',
                    style: heading1(colorWhite),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: rowOptions.length,
                  separatorBuilder: (context, index) => divider(),
                  itemBuilder: (context, index) {
                    final option = rowOptions[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedRow = option;
                        });
                        Navigator.pop(context); // Close bottom sheet
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Text(
                            option,
                            style: bodyText2(colorBlack),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showChartTypeBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: colorApp,
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    'Select Chart Type',
                    style: heading1(colorWhite),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: chartTypes.length,
                  separatorBuilder: (_, __) => divider(),
                  itemBuilder: (context, index) {
                    final chartType = chartTypes[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedChartType = chartType;
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Text(
                            chartType,
                            style: bodyText2(colorBlack),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onError(int errorCode) {
    // TODO: implement onError
  }

  @override
  void onSuccess(DashboardFilterResponse data) {
    if (data.success!) {
      if (data.value! != null) {
        if (data.value!.isNotEmpty) {
          setState(() {
            list = [];
            list.addAll(data.value!);
          });
        }
      }
    } else {
      if (data.resultMessage! != null) {
        toastMassage(data.resultMessage!);
      }
    }
  }
}
