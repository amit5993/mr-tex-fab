import 'dart:ui';

class DashboardResponse {
  List<DashboardData>? value;
  bool? success;
  String? resultMessage;

  DashboardResponse({this.value, this.success, this.resultMessage});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <DashboardData>[];
      json['value'].forEach((v) {
        value!.add(new DashboardData.fromJson(v));
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

class DashboardData {
  String? mode;
  String? amount;
  List<String>? filter;
  List<Company>? company;
  Color uiColor = const Color(0xffFFFFFF);

  DashboardData({this.mode, this.amount, this.filter, this.company});

  DashboardData.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    amount = json['amount'];
    filter = json['filter'].cast<String>();
    if (json['company'] != null) {
      company = <Company>[];
      json['company'].forEach((v) {
        company!.add(new Company.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mode'] = this.mode;
    data['amount'] = this.amount;
    data['filter'] = this.filter;
    if (this.company != null) {
      data['company'] = this.company!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Company {
  String? id;
  String? name;

  Company({this.id, this.name});

  Company.fromJson(Map<String, dynamic> json) {
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