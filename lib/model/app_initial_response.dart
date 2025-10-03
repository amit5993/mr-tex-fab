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
  List<dynamic>? extraMenu;
  List<ExtraClient>? extraClient;
  AppVersion? appVersion;

  AppInitialData({
    this.dashboard,
    this.drawerMenu,
    this.companyId,
    this.companyName,
    this.extraMenu,
    this.extraClient,
    this.appVersion
  });

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
    extraMenu = json['extraMenu'];
    if (json['extraClient'] != null) {
      extraClient = <ExtraClient>[];
      json['extraClient'].forEach((v) {
        extraClient!.add(ExtraClient.fromJson(v));
      });
    }
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
    data['extraMenu'] = extraMenu;
    if (extraClient != null) {
      data['extraClient'] = extraClient!.map((v) => v.toJson()).toList();
    }
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

class ExtraClient {
  String? token;
  String? firstName;
  String? clientLogo;
  String? lastUpload;
  int? companyId;
  String? companyName;
  String? fromDate;
  String? uptoDate;
  String? url;
  int? clientId;
  String? clientName;
  String? roleName;

  ExtraClient({
    this.token,
    this.firstName,
    this.clientLogo,
    this.lastUpload,
    this.companyId,
    this.companyName,
    this.fromDate,
    this.uptoDate,
    this.url,
    this.clientId,
    this.clientName,
    this.roleName
  });

  ExtraClient.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    firstName = json['firstName'];
    clientLogo = json['clientLogo'];
    lastUpload = json['lastUpload'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    fromDate = json['fromDate'];
    uptoDate = json['uptoDate'];
    url = json['url'];
    clientId = json['clientId'];
    clientName = json['clientName'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['firstName'] = firstName;
    data['clientLogo'] = clientLogo;
    data['lastUpload'] = lastUpload;
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    data['fromDate'] = fromDate;
    data['uptoDate'] = uptoDate;
    data['url'] = url;
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    data['roleName'] = roleName;
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