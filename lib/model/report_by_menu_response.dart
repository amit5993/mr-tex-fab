class ReportByMenuResponse {
  List<ReportMenuData>? value;
  bool? success;
  String? resultMessage;

  ReportByMenuResponse({this.value, this.success, this.resultMessage});

  ReportByMenuResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <ReportMenuData>[];
      json['value'].forEach((v) {
        value!.add(ReportMenuData.fromJson(v));
      });
    }
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class ReportMenuData {
  int? reportId;
  String? repName;
  String? repMode;
  List<Filter>? filter;
  String? fromDate;
  String? toDate;
  bool? isVoucher;
  List<DefaultFilter>? defaultFilter = [];
  bool isSelect = false;
  List<FTPData>? ftp = [];

  ReportMenuData(
      {this.reportId,
      this.repName,
      this.repMode,
      this.filter,
      this.fromDate,
      this.toDate,
      this.isVoucher,
      this.defaultFilter,
      this.ftp});

  ReportMenuData.fromJson(Map<String, dynamic> json) {
    reportId = json['reportId'];
    repName = json['repName'];
    repMode = json['repMode'];
    if (json['filter'] != null) {
      filter = <Filter>[];
      json['filter'].forEach((v) {
        filter!.add(Filter.fromJson(v));
      });
    }
    fromDate = json['fromDate'] ?? '';
    toDate = json['toDate'] ?? '';
    isVoucher = json['isVoucher'] ?? false;
    if (json['defaultFilter'] != null) {
      defaultFilter = <DefaultFilter>[];
      json['defaultFilter'].forEach((v) {
        defaultFilter!.add(DefaultFilter.fromJson(v));
      });
    }
    if (json['ftp'] != null) {
      ftp = <FTPData>[];
      json['ftp'].forEach((v) {
        ftp!.add(new FTPData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reportId'] = reportId;
    data['repName'] = repName;
    data['repMode'] = repMode;
    if (filter != null) {
      data['filter'] = filter!.map((v) => v.toJson()).toList();
    }
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['isVoucher'] = isVoucher;
    if (defaultFilter != null) {
      data['defaultFilter'] = defaultFilter!.map((v) => v.toJson()).toList();
    }
    if (ftp != null) {
      data['ftp'] = ftp!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FTPData {
  String? url;
  String? name;
  String? pwd;

  FTPData({this.url, this.name, this.pwd});

  FTPData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
    pwd = json['pwd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['name'] = name;
    data['pwd'] = pwd;
    return data;
  }
}

class Filter {
  String? name;
  String? spName;
  String? tag;
  String? selectedName = '';
  List<String>? dropDownList = [];

  Filter({this.name, this.spName, this.tag});

  Filter.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    spName = json['spName'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['spName'] = spName;
    data['tag'] = tag;
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
