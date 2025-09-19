class VersionUpdateResponse {
  VersionUpdateValue? value;
  bool? success;
  String? resultMessage;

  VersionUpdateResponse({this.value, this.success, this.resultMessage});

  VersionUpdateResponse.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? VersionUpdateValue.fromJson(json['value']) : null;
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.toJson();
    }
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class VersionUpdateValue {
  int? aVersion;
  double? iVersion;
  bool? isHardLoad;

  VersionUpdateValue({this.aVersion, this.iVersion, this.isHardLoad});

  VersionUpdateValue.fromJson(Map<String, dynamic> json) {
    aVersion = json['aVersion'];
    iVersion = json['iVersion'];
    isHardLoad = json['isHardLoad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aVersion'] = aVersion;
    data['iVersion'] = iVersion;
    data['isHardLoad'] = isHardLoad;
    return data;
  }
}
