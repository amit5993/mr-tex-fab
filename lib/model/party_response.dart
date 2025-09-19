class PartyResponse {
  Value? value;
  bool? success;
  String? resultMessage;

  PartyResponse({this.value, this.success, this.resultMessage});

  PartyResponse.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    data['success'] = this.success;
    data['resultMessage'] = this.resultMessage;
    return data;
  }
}

class Value {
  List<PartyData>? results;
  int? noOfRecords;
  Pagination? pagination;

  Value({this.results, this.noOfRecords, this.pagination});

  Value.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <PartyData>[];
      json['results'].forEach((v) {
        results!.add(new PartyData.fromJson(v));
      });
    }
    noOfRecords = json['noOfRecords'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['noOfRecords'] = this.noOfRecords;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class PartyData {
  int? id;
  String? text;
  String? line1;
  String? line2;
  String? line3;

  PartyData({this.id, this.text, this.line1, this.line2, this.line3});

  PartyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    line1 = json['line1'];
    line2 = json['line2'];
    line3 = json['line3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['line3'] = this.line3;
    return data;
  }
}

class Pagination {
  bool? more;

  Pagination({this.more});

  Pagination.fromJson(Map<String, dynamic> json) {
    more = json['more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['more'] = this.more;
    return data;
  }
}