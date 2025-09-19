import 'dart:io';

import 'package:image_picker/image_picker.dart';

class OrderItemDetail {
  double? Amt = 0;
  int? bale = 0;
  String? color = '';
  double? Mtr = 0;
  int? Pcs = 0;
  int? QualId = 0;
  String? QualName = '';
  double? Rate = 0.0;
  String? Rmk;
  int? sets = 0;
  String? Unit = '';
  String? ImageList = '';
  XFile? ImageFile;
  int? CateId = 0;
  double? Cut = 0.0;
  String? PkgType = '';
  String? ctrlNum1 = '';
  String? ctrlNum2 = '';
  String? ctrlStr1 = '';
  String? ctrlStr2 = '';
  String? ctrlLstId1 = '';
  String? ctrlLstVal1 = '';
  String? ctrlLstId2 = '';
  String? ctrlLstVal2 = '';
  // String? ctrlpkgType = '';

  OrderItemDetail({
    this.Amt,
    this.bale,
    this.color,
    this.Mtr,
    this.Pcs,
    this.QualId,
    this.QualName,
    this.Rate,
    this.Rmk,
    this.sets,
    this.Unit,
    this.ImageList,
    this.CateId,
    this.Cut,
    this.PkgType,
    this.ctrlNum1,
    this.ctrlNum2,
    this.ctrlStr1,
    this.ctrlStr2,
    this.ctrlLstId1,
    this.ctrlLstVal1,
    this.ctrlLstId2,
    this.ctrlLstVal2,
    // this.ctrlpkgType,
    // this.ImageFile
  });

  OrderItemDetail.fromJson(Map<String, dynamic> json) {
    Amt = json['Amt'];
    bale = json['bale'];
    color = json['color'];
    Mtr = json['Mtr'];
    Pcs = json['Pcs'];
    QualId = json['QualId'];
    QualName = json['QualName'];
    Rate = json['Rate'];
    Rmk = json['Rmk'];
    sets = json['sets'];
    Unit = json['Unit'];
    ImageList = json['ImageList'];
    CateId = json['CateId'];
    Cut = json['Cut'];
    PkgType = json['PkgType'];
    ctrlNum1 = json['ctrlNum1'] ?? '';
    ctrlNum2 = json['ctrlNum2'] ?? '';
    ctrlStr1 = json['ctrlStr1'] ?? '';
    ctrlStr2 = json['ctrlStr2'] ?? '';
    ctrlLstId1 = json['ctrlLstId1'] ?? '';
    ctrlLstVal1 = json['ctrlLstVal1'] ?? '';
    ctrlLstId2 = json['ctrlLstId2'] ?? '';
    ctrlLstVal2 = json['ctrlLstVal2'] ?? '';
    // ctrlpkgType = json['ctrlpkgType'] ?? '';
    // ImageFile = json['ImageFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Amt'] = Amt;
    data['bale'] = bale;
    data['color'] = color;
    data['Mtr'] = Mtr;
    data['Pcs'] = Pcs;
    data['QualId'] = QualId;
    data['QualName'] = QualName;
    data['Rate'] = Rate;
    data['Rmk'] = Rmk;
    data['sets'] = sets;
    data['Unit'] = Unit;
    data['ImageList'] = ImageList;
    data['CateId'] = CateId;
    data['Cut'] = Cut;
    data['PkgType'] = PkgType;
    data['ctrlNum1'] = ctrlNum1;
    data['ctrlNum2'] = ctrlNum2;
    data['ctrlStr1'] = ctrlStr1;
    data['ctrlStr2'] = ctrlStr2;
    data['ctrlLstId1'] = ctrlLstId1;
    data['ctrlLstVal1'] = ctrlLstVal1;
    data['ctrlLstId2'] = ctrlLstId2;
    data['ctrlLstVal2'] = ctrlLstVal2;
    // data['ctrlpkgType'] = ctrlpkgType;
    // data['ImageFile'] = ImageFile;
    return data;
  }
}
