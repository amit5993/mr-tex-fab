class DashboardFilterResponse {
  List<DashboardFilterData>? value;
  bool? success;
  String? resultMessage;

  DashboardFilterResponse({this.value, this.success, this.resultMessage});

  DashboardFilterResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <DashboardFilterData>[];
      json['value'].forEach((v) {
        value!.add(new DashboardFilterData.fromJson(v));
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

class DashboardFilterData {
  String? data;
  String? value;
  String? line1;
  String? line2;
  String? content;
  String? phone;
  String? menuName;
  String? repName;
  List<DefaultFilter>? defaultFilter;
  String? keyValue;
  String? value1;

  DashboardFilterData({
    this.data,
    this.value,
    this.line1,
    this.line2,
    this.content,
    this.phone,
    this.menuName,
    this.repName,
    this.defaultFilter,
    this.keyValue,
    this.value1,
  });

  DashboardFilterData.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    value = json['value'];
    line1 = json['line1'] ?? '';
    line2 = json['line2'] ?? '';
    content = json['content'] ?? '';
    phone = json['phone'] ?? '';
    menuName = json['menuName'] ?? '';
    repName = json['repName'] ?? '';
    if (json['defaultFilter'] != null) {
      defaultFilter = <DefaultFilter>[];
      json['defaultFilter'].forEach((v) {
        defaultFilter!.add(DefaultFilter.fromJson(v));
      });
    }
    keyValue = json['keyValue'] ?? '';
    value1 = json['value1'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['value'] = value;
    data['line1'] = line1;
    data['line2'] = line2;
    data['content'] = content;
    data['phone'] = phone;
    data['menuName'] = menuName;
    data['repName'] = repName;
    if (this.defaultFilter != null) {
      data['defaultFilter'] =
          this.defaultFilter!.map((v) => v.toJson()).toList();
    }
    data['keyValue'] = keyValue;
    data['value1'] = value1;
    return data;
  }

}

class DefaultFilter {
  int? id;
  String? name;
  String? tag;

  DefaultFilter({this.id, this.name, this.tag});

  DefaultFilter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tag'] = tag;
    return data;
  }
}