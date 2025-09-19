class ExtraCtrlConfigResponse {
  ExtraCtrlConfigData? value;

  ExtraCtrlConfigResponse({this.value});

  ExtraCtrlConfigResponse.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? ExtraCtrlConfigData.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.toJson();
    }
    return data;
  }
}

class ExtraCtrlConfigData {
  String? ctrlNum1;
  String? ctrlNum2;
  String? ctrlStr1;
  String? ctrlStr2;
  String? ctrlLst1;
  String? ctrlLst2;
  String? ctrlpkgType;

  ExtraCtrlConfigData(
      {this.ctrlNum1,
        this.ctrlNum2,
        this.ctrlStr1,
        this.ctrlStr2,
        this.ctrlLst1,
        this.ctrlLst2,
        this.ctrlpkgType,
      });

  ExtraCtrlConfigData.fromJson(Map<String, dynamic> json) {
    ctrlNum1 = json['ctrlNum1'];
    ctrlNum2 = json['ctrlNum2'];
    ctrlStr1 = json['ctrlStr1'];
    ctrlStr2 = json['ctrlStr2'];
    ctrlLst1 = json['ctrlLst1'];
    ctrlLst2 = json['ctrlLst2'];
    ctrlpkgType = json['ctrlpkgType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ctrlNum1'] = ctrlNum1;
    data['ctrlNum2'] = ctrlNum2;
    data['ctrlStr1'] = ctrlStr1;
    data['ctrlStr2'] = ctrlStr2;
    data['ctrlLst1'] = ctrlLst1;
    data['ctrlLst2'] = ctrlLst2;
    data['ctrlpkgType'] = ctrlpkgType;
    return data;
  }
}
