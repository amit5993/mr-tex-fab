// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../common/common_log.dart';
import '../common/utils.dart';
import '../utils/preference.dart';
import '../utils/string.dart';
import '../utils/widget.dart';

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  var timeOut = const Duration(seconds: 30);

  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> get({String? url, Uri? uri, bool? isLoadVisible}) async {
    var isNetwork = await Utils.checkInternetConnection();

    if (!isNetwork) {
      toastMassage(checkInternetPermission);
      return;
    }

    if (isLoadVisible!) {
      EasyLoading.instance.userInteractions = true;
      EasyLoading.instance.dismissOnTap = true;
      EasyLoading.show(status: 'loading...');
    }

    Map<String, String> headers = {
      "Authorization": "Bearer ${PreferenceData.getToken()}",
      "Accept": "application/json",
      //"Content-Type": "application/json",
    };

    if (url != null) {
      uri = Uri.parse(url);
    }

    //print("REQUEST URL : " + url);
    CommonLog.printLog("REQUEST URL : $uri");

    CommonLog.printLog("Header : $headers");

    return http.get(uri!, headers: headers).then((http.Response response) {
      CommonLog.printLog("RESPONSE CODE : ${response.statusCode}");
      CommonLog.printLog("RESPONSE : ${response.body}");

      final String res = response.body;
      final int statusCode = response.statusCode;
      EasyLoading.dismiss();

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception(statusCode);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getQueryParameters(
      String url, Map<String, dynamic> queryParam) async {
    Map<String, String> headers = {
      "Authorization": "Bearer ${PreferenceData.getToken()}",
    };
    var uri = Uri.parse(url);
    uri = uri.replace(query: 'user=x');
    CommonLog.printLog("Header : $headers");

    return http.get(uri, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception(statusCode);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,
      {Map? headers, body, encoding, bool? loading}) async {
    loading ??= true;

    var isNetwork = await Utils.checkInternetConnection();

    if (!isNetwork) {
      toastMassage(checkInternetPermission);
      return;
    }

    if (loading) {
      EasyLoading.instance.userInteractions = true;
      EasyLoading.instance.dismissOnTap = true;
      EasyLoading.show(status: 'loading...');
    }

    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      "Authorization": "Bearer ${PreferenceData.getToken()}",
    };

    CommonLog.printLog("Header : $headers");
    CommonLog.printLog("REQUEST URL : $url");
    CommonLog.printLog("REQUEST : ${jsonEncode(body)}");

    return await http
        .post(Uri.parse(url), body: body, headers: headers, encoding: encoding)
        .timeout(timeOut)
        .then((http.Response response) {
      CommonLog.printLog("RESPONSE CODE : ${response.statusCode}");
      CommonLog.printLog("RESPONSE : ${response.body}");

      final String res = response.body;
      final int statusCode = response.statusCode;

      if (loading!) {
        EasyLoading.dismiss();
      }
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception(statusCode);
      }

      if (res.isEmpty) {
        throw Exception(statusCode);
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> put(String url, {Map? headers, body, encoding}) async {
    var isNetwork = await Utils.checkInternetConnection();

    if (!isNetwork) {
      toastMassage(checkInternetPermission);
      return;
    }

    Map<String, String> headers = {
      "Authorization": "Bearer ${PreferenceData.getToken()}",
      "Content-Type": "application/json"
    };

    CommonLog.printLog("Header : $headers");
    //CommonLog.printLog(jsonEncode(body));

    CommonLog.printLog("REQUEST URL : $url");
    CommonLog.printLog("REQUEST : ${jsonEncode(body)}");

    return await http
        .put(Uri.parse(url),
            body: jsonEncode(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      CommonLog.printLog("RESPONSE CODE : ${response.statusCode}");
      CommonLog.printLog("RESPONSE : ${response.body}");

      final String res = response.body;
      final int statusCode = response.statusCode;
      //hideLoader();

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw Exception(statusCode);
      }

      if (res.isEmpty) {
        throw Exception(statusCode);
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> putImage(String url, Map<String, File> _files) async {
    Map<String, String> headers = {
      "Authorization": "Bearer ${PreferenceData.getToken()}",
      "Content-Type": "multipart/form-data"
    };

    CommonLog.printLog("Header : $headers");

    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll(headers);

    for (var entry in _files.entries) {
      //print(entry.key);
      //print(entry.value);

      if (entry.value != null) {
        request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path));
      }
    }

    var response = await request.send();

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception(statusCode);
    }
    /*if (statusCode < 200 || statusCode > 400 || json == null) {
      CheckResponseCode.getResponseCode(statusCode, context);
      hideLoader();
      throw  Exception("Error while fetching data");
    }*/

    final respStr = await response.stream.bytesToString();

    CommonLog.printLog(respStr);

    return _decoder.convert(respStr);
  }

  // Future<dynamic> postRequestWithFormDataNew(
  //     String url,  MultipartRequest request, {Map? headers, body, encoding, bool? loading}) async {
  //
  //   loading ??= true;
  //
  //   var isNetwork = await Utils.checkInternetConnection();
  //
  //   if (!isNetwork) {
  //     toastMassage(checkInternetPermission);
  //     return;
  //   }
  //
  //   if (loading) {
  //     EasyLoading.instance.userInteractions = true;
  //     EasyLoading.instance.dismissOnTap = true;
  //     EasyLoading.show(status: 'loading...');
  //   }
  //
  //
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer ${PreferenceData.getToken()}",
  //     // "Content-Type": "multipart/form-data"
  //   };
  //
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //   if(body != null) {
  //     body.forEach((key, value) {
  //       request.fields[key] = value;
  //     });
  //   }
  //
  //   CommonLog.printLog("Header : $headers");
  //   CommonLog.printLog("REQUEST URL : $url");
  //   CommonLog.printLog("REQUEST BODY : ${request.fields}");
  //
  //   request.headers.addAll(headers); //i
  //   // var res = await request.send();
  //   // final respStr = await res.stream.bytesToString();
  //
  //   final res = await http.post(
  //     Uri.parse(url),
  //     body: null,
  //     headers: headers,
  //   );
  //
  //   // CommonLog.printLog("RESPONSE CODE : ${res.statusCode}");
  //   // CommonLog.printLog("RESPONSE : $respStr");
  //
  //   if (loading) {
  //     EasyLoading.dismiss();
  //   }
  //
  //   int statusCode = res.statusCode;
  //   if (statusCode < 200 || statusCode > 400) {
  //     throw Exception(statusCode);
  //   }
  //   // return _decoder.convert(respStr);
  //   return _decoder.convert(res.body);
  // }




  Future<dynamic> postRequestWithFormDataNew(String url, MultipartRequest request) async {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: 'Loading...');

    Map<String, String> headers = {
      "Authorization": "Bearer ${PreferenceData.getToken()}",
      "Content-Type": "application/json;charset=utf-8"
      // "Content-Type": "multipart/form-data"
    };

    CommonLog.printLog("Header : $headers");
    CommonLog.printLog("REQUEST URL : $url");
    CommonLog.printLog("REQUEST BODY : ${request.fields}");

    // request.headers.addAll(headers);
    var res = await request.send();
    final respStr = await res.stream.bytesToString();

    CommonLog.printLog("Upload $respStr");
    EasyLoading.dismiss();

    int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception(statusCode);
    }
    return _decoder.convert(respStr);
  }

  // Future<dynamic> postRequestWithFormDataNew(
  //     String url, MultipartRequest request) async {
  //   EasyLoading.instance.userInteractions = false;
  //   EasyLoading.show(status: 'loading...');
  //
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer ${PreferenceData.getToken()}",
  //     "Content-Type": "application/json;charset=utf-8"
  //     // "Content-Type": "multipart/form-data"
  //   };
  //
  //   CommonLog.printLog("Header : $headers");
  //   CommonLog.printLog("REQUEST URL : $url");
  //   CommonLog.printLog("REQUEST BODY : ${request.fields}");
  //
  //   // request.headers.addAll(headers);
  //   var res = await request.send();
  //   final respStr = await res.stream.bytesToString();
  //
  //   CommonLog.printLog("Upload $respStr");
  //   EasyLoading.dismiss();
  //
  //   int statusCode = res.statusCode;
  //   if (statusCode < 200 || statusCode > 400) {
  //     throw Exception(statusCode);
  //   }
  //   return _decoder.convert(respStr);
  // }
}
