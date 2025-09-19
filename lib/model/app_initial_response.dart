class AppInitialResponse {
  AppInitialData? value;
  String? notificationCount;
  String? lastUpload;
  String? expDate;
  bool? success;
  String? bannerURLs;
  String? videoURL;
  String? resultMessage;

  AppInitialResponse({this.value, this.notificationCount, this.lastUpload, this.expDate, this.success, this.bannerURLs, this.videoURL, this.resultMessage});

  AppInitialResponse.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? AppInitialData.fromJson(json['value']) : null;
    notificationCount = json['notification_Count'];
    lastUpload = json['lastUpload'];
    expDate = json['expDate'];
    success = json['success'];
    bannerURLs = json['bannerURLs'];
    videoURL = json['videoURL'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (value != null) {
      data['value'] = value!.toJson();
    }
    data['notification_Count'] = notificationCount;
    data['lastUpload'] = lastUpload;
    data['expDate'] = expDate;
    data['success'] = success;
    data['bannerURLs'] = bannerURLs;
    data['videoURL'] = videoURL;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class AppInitialData {
  List<MenuData>? dashboard;
  List<MenuData>? drawerMenu;
  int? companyId;
  String? companyName;
  AppVersion? appVersion;

  AppInitialData({this.dashboard, this.drawerMenu, this.companyId, this.companyName, this.appVersion});

  AppInitialData.fromJson(Map<String, dynamic> json) {
    if (json['dashboard'] != null) {
      dashboard = <MenuData>[];
      json['dashboard'].forEach((v) {
        dashboard!.add(MenuData.fromJson(v));
      });
    }
    if (json['drawerMenu'] != null) {
      drawerMenu = <MenuData>[];
      json['drawerMenu'].forEach((v) {
        drawerMenu!.add(MenuData.fromJson(v));
      });
    }
    companyId = json['companyId'];
    companyName = json['companyName'];
    appVersion = json['appVersion'] != null ? AppVersion.fromJson(json['appVersion']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dashboard != null) {
      data['dashboard'] = dashboard!.map((v) => v.toJson()).toList();
    }
    if (drawerMenu != null) {
      data['drawerMenu'] = drawerMenu!.map((v) => v.toJson()).toList();
    }
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    if (appVersion != null) {
      data['appVersion'] = appVersion!.toJson();
    }
    return data;
  }
}

class MenuData {
  int? menuId;
  String? menuName;
  String? menuDisplayName;
  String? menuTag;
  String? iconUrl;
  int? type;
  int? isExpand;
  List<MenuData>? childMenu;
  int? parentId;
  bool isExpanded = false;

  MenuData({this.menuId, this.menuName, this.menuDisplayName, this.menuTag, this.iconUrl, this.type,this.isExpand, this.childMenu, this.parentId});

  MenuData.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    menuName = json['menuName'];
    menuDisplayName = json['menuDisplayName'];
    menuTag = json['menuTag'];
    iconUrl = json['iconUrl'];
    type = json['type'];
    isExpand = json['isExpand'] ?? 0;
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
    data['menuTag'] = menuTag;
    data['iconUrl'] = iconUrl;
    data['type'] = type;
    data['isExpand'] = isExpand;
    if (childMenu != null) {
      data['childMenu'] = childMenu!.map((v) => v.toJson()).toList();
    }
    data['parentId'] = parentId;
    return data;
  }
}

class AppVersion {
  int? aVersion;
  double? iVersion;
  bool? isHardLoad;
  String? iLink;
  String? aLink;

  AppVersion({this.aVersion, this.iVersion, this.isHardLoad, this.iLink, this.aLink});

  AppVersion.fromJson(Map<String, dynamic> json) {
    aVersion = json['aVersion'];
    iVersion = json['iVersion'] ?? 0.0;
    isHardLoad = json['isHardLoad'];
    iLink = json['iLink'];
    aLink = json['aLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aVersion'] = aVersion;
    data['iVersion'] = iVersion;
    data['isHardLoad'] = isHardLoad;
    data['iLink'] = iLink;
    data['aLink'] = aLink;
    return data;
  }
}
