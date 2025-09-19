import 'dart:ffi';

class OrderListResponse {
  List<OrderListData>? value;
  bool? success;
  String? resultMessage;

  OrderListResponse({this.value, this.success, this.resultMessage});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <OrderListData>[];
      json['value'].forEach((v) {
        value!.add(new OrderListData.fromJson(v));
      });
    }
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['resultMessage'] = this.resultMessage;
    return data;
  }
}

class OrderListData {
  int? conum;
  String? companyName;
  int? sordTrnId;
  String? orderNo;
  String? date;
  String? labelSupplier;
  String? supplier;
  int? refId;
  int? vno;
  String? customer;
  int? accountId;
  int? agentId;
  String? agentName;
  int? hasteId;
  String? hasteName;
  String? totalPcs;
  int? tPcs;
  double? tMtr;
  String? bale;
  double? amount;
  int? transport;
  String? transportName;
  int? typeId;
  String? typeName;
  String? rateCategory;
  String? rateCategoryName;
  int? cateId;
  String? catelogName;
  String? station;
  int? lrCase;
  String? status;
  String? remark;
  int? dueDays;
  int? newVno;
  int? newTypeId;
  bool? btnChange;
  bool? btnDelete;
  bool? btnPrint;
  List<OrderItemDetails>? orderItemDetails;

  List<Report>? report;

  OrderListData(
      {this.conum,
      this.companyName,
      this.sordTrnId,
      this.orderNo,
      this.date,
      this.labelSupplier,
      this.supplier,
      this.refId,
      this.vno,
      this.customer,
      this.accountId,
      this.agentId,
      this.agentName,
      this.hasteId,
      this.hasteName,
      this.totalPcs,
      this.tPcs,
      this.tMtr,
      this.bale,
      this.amount,
      this.transport,
      this.transportName,
      this.typeId,
      this.typeName,
      this.rateCategory,
      this.rateCategoryName,
      this.cateId,
      this.catelogName,
      this.station,
      this.lrCase,
      this.status,
      this.remark,
      this.dueDays,
      this.newVno,
      this.newTypeId,
      this.btnChange,
      this.btnDelete,
      this.btnPrint,
      this.orderItemDetails,
      this.report});

  OrderListData.fromJson(Map<String, dynamic> json) {
    conum = json['conum'];
    companyName = json['companyName']?? '';
    sordTrnId = json['sordTrnId'];
    orderNo = json['orderNo'] ?? '';
    date = json['date'] ?? '';
    labelSupplier = json['labelSupplier'] ?? 'Supplier';
    supplier = json['supplier'] ?? '';
    refId = json['refId'];
    vno = json['vno'] ?? 0;
    customer = json['customer'] ?? '';
    accountId = json['accountId'];
    agentId = json['agentId'];
    agentName = json['agentName'] ?? '';
    hasteId = json['hasteId'];
    hasteName = json['hasteName'] ?? '';
    totalPcs = json['totalPcs'] ?? '';
    tPcs = json['tPcs'] ?? 0;
    tMtr = json['tMtr'] ?? 0.0;
    bale = json['bale'] ?? '';
    amount = json['amount'] ?? 0.0;
    transport = json['transport'];
    transportName = json['transportName'] ?? '';
    typeId = json['typeId'] ?? 0;
    typeName = json['typeName'] ?? '';
    rateCategory = json['rateCategory'] ?? '';
    rateCategoryName = json['rateCategoryName'] ?? '';
    cateId = json['cateId'];
    catelogName = json['catelogName'] ?? '';
    station = json['station'] ?? '';
    lrCase = json['lrCase'];
    status = json['status'] ?? '';
    remark = json['remark'] ?? '';
    dueDays = json['dueDays'] ?? 0;
    newVno = json['newVno'] ?? 0;
    newTypeId = json['newTypeId'] ?? 0;
    btnChange = json['btnChange'] ?? false;
    btnDelete = json['btnDelete'] ?? false;
    btnPrint = json['btnPrint'] ?? false;
    if (json['orderItemDetails'] != null) {
      orderItemDetails = <OrderItemDetails>[];
      json['orderItemDetails'].forEach((v) {
        orderItemDetails!.add(OrderItemDetails.fromJson(v));
      });
    }
    if (json['report'] != null) {
      report = <Report>[];
      json['report'].forEach((v) {
        report!.add(new Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conum'] = conum;
    data['companyName'] = companyName;
    data['sordTrnId'] = sordTrnId;
    data['orderNo'] = orderNo;
    data['date'] = date;
    data['labelSupplier'] = labelSupplier;
    data['supplier'] = supplier;
    data['refId'] = refId;
    data['vno'] = vno;
    data['customer'] = customer;
    data['accountId'] = accountId;
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['hasteId'] = hasteId;
    data['hasteName'] = hasteName;
    data['totalPcs'] = totalPcs;
    data['tPcs'] = tPcs;
    data['tMtr'] = tMtr;
    data['bale'] = bale;
    data['amount'] = amount;
    data['transport'] = transport;
    data['transportName'] = transportName;
    data['typeId'] = typeId;
    data['typeName'] = typeName;
    data['rateCategory'] = rateCategory;
    data['rateCategoryName'] = rateCategoryName;
    data['cateId'] = cateId;
    data['catelogName'] = catelogName;
    data['station'] = station;
    data['lrCase'] = lrCase;
    data['status'] = status;
    data['remark'] = remark;
    data['dueDays'] = dueDays;
    data['newVno'] = newVno;
    data['newTypeId'] = newTypeId;
    data['btnChange'] = btnChange;
    data['btnDelete'] = btnDelete;
    data['btnPrint'] = btnPrint;
    if (orderItemDetails != null) {
      data['orderItemDetails'] = orderItemDetails!.map((v) => v.toJson()).toList();
    }
    if (report != null) {
      data['report'] = report!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItemDetails {
  int? sOrdTrnId;
  int? srno;
  int? baseId;
  int? qualId;
  String? qualName;
  String? unit;
  int? pcs;
  double? mtr;
  double? rate;
  double? amt;
  double? netAmt;
  String? status;
  String? itemName;
  int? sets;
  int? bale;
  String? color;
  String? rmk;
  String? imageList;
  int? cateId;
  String? catelogName;
  double? cut;
  String? pkgType;
  String? ctrlNum1;
  String? ctrlNum2;
  String? ctrlStr1;
  String? ctrlStr2;
  String? ctrlLstId1;
  String? ctrlLstVal1;
  String? ctrlLstId2;
  String? ctrlLstVal2;

  OrderItemDetails({
    this.sOrdTrnId,
    this.srno,
    this.baseId,
    this.qualId,
    this.qualName,
    this.unit,
    this.pcs,
    this.mtr,
    this.rate,
    this.amt,
    this.netAmt,
    this.status,
    this.itemName,
    this.sets,
    this.bale,
    this.color,
    this.rmk,
    this.imageList,
    this.cateId,
    this.catelogName,
    this.cut,
    this.pkgType,
    this.ctrlNum1,
    this.ctrlNum2,
    this.ctrlStr1,
    this.ctrlStr2,
    this.ctrlLstId1,
    this.ctrlLstVal1,
    this.ctrlLstId2,
    this.ctrlLstVal2,
  });

  OrderItemDetails.fromJson(Map<String, dynamic> json) {
    sOrdTrnId = json['sOrdTrnId'];
    srno = json['srno'];
    baseId = json['baseId'];
    qualId = json['qualId'];
    qualName = json['qualName'] ?? '';
    unit = json['unit'] ?? '';
    pcs = json['pcs'].toInt() ?? 0;
    mtr = json['mtr'].toDouble() ?? 0.0;
    rate = json['rate'].toDouble() ?? 0.0;
    amt = json['amt'].toDouble() ?? 0.0;
    netAmt = json['netAmt'].toDouble() ?? 0.0;
    status = json['status'] ?? '';
    itemName = json['itemName'] ?? '';
    sets = json['sets'];
    bale = json['bale'];
    color = json['color'] ?? '';
    rmk = json['rmk'] ?? '';
    imageList = json['imageList'] ?? '';
    cateId = json['cateId'];
    catelogName = json['catelogName'] ?? '';
    cut = json['cut'] ?? 0.0;
    pkgType = json['pkgType'] ?? '';
    ctrlNum1 = json['ctrlNum1'] ?? '';
    ctrlNum2 = json['ctrlNum2'] ?? '';
    ctrlStr1 = json['ctrlStr1'] ?? '';
    ctrlStr2 = json['ctrlStr2'] ?? '';
    ctrlLstId1 = json['ctrlLstId1'] ?? '';
    ctrlLstVal1 = json['ctrlLstVal1'] ?? '';
    ctrlLstId2 = json['ctrlLstId2'] ?? '';
    ctrlLstVal2 = json['ctrlLstVal2'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sOrdTrnId'] = sOrdTrnId;
    data['srno'] = srno;
    data['baseId'] = baseId;
    data['qualId'] = qualId;
    data['qualName'] = qualName;
    data['unit'] = unit;
    data['pcs'] = pcs;
    data['mtr'] = mtr;
    data['rate'] = rate;
    data['amt'] = amt;
    data['netAmt'] = netAmt;
    data['status'] = status;
    data['itemName'] = itemName;
    data['sets'] = sets;
    data['bale'] = bale;
    data['color'] = color;
    data['rmk'] = rmk;
    data['imageList'] = imageList;
    data['cateId'] = cateId;
    data['catelogName'] = catelogName;
    data['cut'] = cut;
    data['pkgType'] = pkgType;
    data['ctrlNum1'] = ctrlNum1;
    data['ctrlNum2'] = ctrlNum2;
    data['ctrlStr1'] = ctrlStr1;
    data['ctrlStr2'] = ctrlStr2;
    data['ctrlLstId1'] = ctrlLstId1;
    data['ctrlLstVal1'] = ctrlLstVal1;
    data['ctrlLstId2'] = ctrlLstId2;
    data['ctrlLstVal2'] = ctrlLstVal2;
    return data;
  }
}

class Report {
  int? id;
  String? name;

  Report({this.id, this.name});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
