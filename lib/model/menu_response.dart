class MenuResponse {
  List<MenuData>? value;
  String? notificationCount;
  String? lastUpload;
  String? expDate;
  bool? success;
  String? resultMessage;

  MenuResponse(
      {this.value,
        this.notificationCount,
        this.lastUpload,
        this.expDate,
        this.success,
        this.resultMessage});

  MenuResponse.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <MenuData>[];
      json['value'].forEach((v) {
        value!.add(MenuData.fromJson(v));
      });
    }
    notificationCount = json['notification_Count'];
    lastUpload = json['lastUpload'];
    expDate = json['expDate'];
    success = json['success'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.map((v) => v.toJson()).toList();
    }
    data['notification_Count'] = notificationCount;
    data['lastUpload'] = lastUpload;
    data['expDate'] = expDate;
    data['success'] = success;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class MenuData {
  int? menuId;
  String? menuName;
  String? menuDisplayName;
  String? iconUrl;
  int? type;
  List<MenuData>? childMenu;
  int? parentId;
  bool isExpanded = false;

  MenuData(
      {this.menuId,
        this.menuName,
        this.menuDisplayName,
        this.iconUrl,
        this.type,
        this.childMenu,
        this.parentId});

  MenuData.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    menuName = json['menuName'];
    menuDisplayName = json['menuDisplayName'];
    iconUrl = json['iconUrl'];
    type = json['type'];
    if (json['childMenu'] != null) {
      childMenu = <MenuData>[];
      json['childMenu'].forEach((v) {
        childMenu!.add(MenuData.fromJson(v));
      });
    }
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuId'] = menuId;
    data['menuName'] = menuName;
    data['menuDisplayName'] = menuDisplayName;
    data['iconUrl'] = iconUrl;
    data['type'] = type;
    if (childMenu != null) {
      data['childMenu'] = childMenu!.map((v) => v.toJson()).toList();
    }
    data['parentId'] = parentId;
    return data;
  }
}

// class ChildMenu {
//   int? menuId;
//   String? menuName;
//   String? menuDisplayName;
//   String? iconUrl;
//   int? type;
//   int? parentId;
//
//   ChildMenu(
//       {this.menuId,
//         this.menuName,
//         this.menuDisplayName,
//         this.iconUrl,
//         this.type,
//         this.parentId});
//
//   ChildMenu.fromJson(Map<String, dynamic> json) {
//     menuId = json['menuId'];
//     menuName = json['menuName'];
//     menuDisplayName = json['menuDisplayName'];
//     iconUrl = json['iconUrl'];
//     type = json['type'];
//     parentId = json['parentId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['menuId'] = menuId;
//     data['menuName'] = menuName;
//     data['menuDisplayName'] = menuDisplayName;
//     data['iconUrl'] = iconUrl;
//     data['type'] = type;
//     data['parentId'] = parentId;
//     return data;
//   }
// }