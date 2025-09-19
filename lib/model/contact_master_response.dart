class ContactMasterResponse {
  List<ContactMasterData>? value;
  bool? success;
  String? resultMessage;

  ContactMasterResponse({this.value, this.success, this.resultMessage});

  ContactMasterResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <ContactMasterData>[];
      json['value'].forEach((v) {
        value!.add(new ContactMasterData.fromJson(v));
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

class ContactMasterData {
  String? name;
  String? contactDetail;
  String? copyContent = '';
  String? mobile = '';
  String? phone= '';
  String? email= '';

  ContactMasterData({this.name, this.contactDetail, this.mobile, this.phone, this.email});

  ContactMasterData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactDetail = json['contactDetail'];
    copyContent = json['copyContent'] ?? '';
    mobile = json['mobile'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['contactDetail'] = contactDetail;
    data['copyContent'] = copyContent;
    data['mobile'] = mobile;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}