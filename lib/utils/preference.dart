import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceData {
  static PreferenceData? _preferenceData;
  static SharedPreferences? _preferences;

  static String token = "token";
  static String userName = "user_name";
  static String clientCode = "client_code";
  static String userInfo = "user_info";
  static String userType = "user_type";
  static String isActionBar = "is_action_bar";
  static String ftpUrl = "ftp_url";
  static String videoPath = "video_path";

  static Future getInstance() async {
    if (_preferenceData == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = PreferenceData._();
      await secureStorage._init();
      _preferenceData = secureStorage;
    }
    return _preferenceData;
  }

  PreferenceData._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getToken() {
    if (_preferences == null) return '';
    return _preferences!.getString(token) ?? '';
  }

  static Future? setToken(String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(token, value);
  }

  static String getUserName() {
    if (_preferences == null) return '';
    return _preferences!.getString(userName) ?? '';
  }

  static Future? setUserName(String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(userName, value);
  }

  static String getClientCode() {
    if (_preferences == null) return '';
    return _preferences!.getString(clientCode) ?? '';
  }

  static Future? setClientCode(String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(clientCode, value);
  }

  static String getUserInfo() {
    if (_preferences == null) return '';
    return _preferences!.getString(userInfo) ?? '';
  }

  static Future? setUserInfo(String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(userInfo, value);
  }

  static String getFtpUrl() {
    if (_preferences == null) return '';
    return _preferences!.getString(ftpUrl) ?? '';
  }

  static Future? setFtpUrl(String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(ftpUrl, value);
  }

  static String getAdsVideoPath() {
    if (_preferences == null) return '';
    return _preferences!.getString(videoPath) ?? '';
  }

  static Future? setAdsVideoPath(String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(videoPath, value);
  }

  static void clearData() {
    PreferenceData.setToken("");
  }
}
