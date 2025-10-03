import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceData {
  static PreferenceData? _preferenceData;
  static SharedPreferences? _preferences;

  static String deviceId = "device_id";
  static String token = "token";
  static String userName = "user_name";
  static String clientCode = "client_code";
  static String userInfo = "user_info";
  static String userType = "user_type";
  static String isActionBar = "is_action_bar";
  static String ftpUrl = "ftp_url";
  static String videoPath = "video_path";
  static String selectedCompanyId = "selected_company_id";
  static String selectedCompanyName = "selected_company_name";
  static String currentClientId = "current_client_id";
  static String currentClientName = "current_client_name";

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

  static String getDeviceId() {
    if (_preferences == null) return '';
    return _preferences!.getString(deviceId) ?? '';
  }

  static Future? setDeviceId(String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(deviceId, value);
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

  static Future? setSelectedCompanyId(int value)  {
    if (_preferences == null) return null;
    return _preferences!.setInt(selectedCompanyId, value);
  }

  static int getSelectedCompanyId() {
    if (_preferences == null) return 0;
    return _preferences!.getInt(selectedCompanyId) ?? 0;
  }

  static Future? setSelectedCompanyName(String value)  {
    if (_preferences == null) return null;
    return _preferences!.setString(selectedCompanyName, value);
  }

  static String getSelectedCompanyName() {
    if (_preferences == null) return '';
    return _preferences!.getString(selectedCompanyName) ?? '';
  }

  static Future? setCurrentClientId(String value)  {
    if (_preferences == null) return null;
    return _preferences!.setString(currentClientId, value);
  }

  static String getCurrentClientId() {
    if (_preferences == null) return '';
    return _preferences!.getString(currentClientId) ?? '';
  }

  static Future? setCurrentClientName(String value)  {
    if (_preferences == null) return null;
    return _preferences!.setString(currentClientName, value);
  }

  static String getCurrentClientName() {
    if (_preferences == null) return '';
    return _preferences!.getString(currentClientName) ?? '';
  }

  static void clearData() {
    PreferenceData.setToken("");
    PreferenceData.setCurrentClientName("");
    PreferenceData.setCurrentClientId("");
  }
}
