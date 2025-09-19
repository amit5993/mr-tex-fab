class ConfigAppMenuResponse {
  List<ConfigAppMenu>? value;
  bool? success;
  String? resultMessage;

  ConfigAppMenuResponse({this.value, this.success, this.resultMessage});

  ConfigAppMenuResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <ConfigAppMenu>[];
      json['value'].forEach((v) {
        value!.add(new ConfigAppMenu.fromJson(v));
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

class ConfigAppMenu {
  String? title;
  List<DataList>? dataList;

  ConfigAppMenu({this.title, this.dataList});

  ConfigAppMenu.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['data_list'] != null) {
      dataList = <DataList>[];
      json['data_list'].forEach((v) {
        dataList!.add(new DataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.dataList != null) {
      data['data_list'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  int? id;
  String? name;
  int? value;
  String? module;

  DataList({this.id, this.name, this.value, this.module});

  DataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    module = json['module'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['module'] = this.module;
    return data;
  }
}

