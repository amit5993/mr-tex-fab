// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:http/src/multipart_request.dart';
import 'package:td/common/utils.dart';
import 'package:td/model/role_response.dart';
import 'package:td/model/save_order_request.dart';
import 'package:td/model/scan_request.dart';

import '../model/account_master_response.dart';
import '../model/app_initial_response.dart';
import '../model/approval_pending_response.dart';
import '../model/common_response.dart';
import '../model/config_app_menu_response.dart';
import '../model/contact_master_response.dart';
import '../model/dashboard_filter_response.dart';
import '../model/dashboard_request.dart';
import '../model/dashboard_response.dart';
import '../model/export_pdf_request.dart';
import '../model/export_pdf_response.dart';
import '../model/extra_ctrl_config_response.dart';
import '../model/filter_response.dart';
import '../model/invoice_response.dart';
import '../model/issue_entry_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/login_response.dart';
import '../model/menu_response.dart';
import '../model/order_list_response.dart';
import '../model/order_number_response.dart';
import '../model/otp_response.dart';
import '../model/party_response.dart';
import '../model/receive_entry_response.dart';
import '../model/receive_item_detail_response.dart';
import '../model/report_by_menu_response.dart';
import '../model/save_issue_request.dart';
import '../model/save_receive_request.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';
import '../model/version_update_response.dart';
import 'constant.dart';
import 'network_util.dart';

class RestDataSource {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<UserVerificationResponse> doUserVerification(String userName, String clientCode, String deviceId) {
    Map requestBody = {
      'username': userName,
      'clientcode': clientCode,
      'deviceId': deviceId,
    };

    return _netUtil.post(Constant.userVerify, body: requestBody).then((dynamic res) {
      return UserVerificationResponse.fromJson(res);
    });
  }

  Future<LoginResponse> doLogin(String userName, String clientCode, String password, String deviceId) {
    Map requestBody = {
      'username': userName,
      'password': password,
      'ClientCode': clientCode,
      'AFCM': "token",
      'ADeviceType': Platform.isAndroid ? 'Android' : '',
      'IFCM': "",
      'IDeviceType': Platform.isIOS ? 'IOS' : '',
      'deviceId': deviceId,
    };

    return _netUtil.post(Constant.login, body: requestBody).then((dynamic res) {
      return LoginResponse.fromJson(res);
    });
  }

  Future<CommonResponse> doLogout() {
    Map requestBody = {
      'DeviceType': Platform.isAndroid ? 'Android' : 'iOS',
    };

    return _netUtil.post(Constant.logout, body: requestBody).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<AppInitialResponse> getAppInitialAPI() {
    Map requestBody = {
      'PkgName': Platform.isAndroid ? Constant.androidPkg : Constant.iOSPkg,
      'DeviceType': Platform.isAndroid ? 'ANDROID' : 'IOS',
    };

    return _netUtil.post(Constant.getAppInitialAPI,body: requestBody).then((dynamic res) {
      return AppInitialResponse.fromJson(res);
    });
  }

  Future<MenuResponse> getAllMenu() {
    return _netUtil.post(Constant.allMenu).then((dynamic res) {
      return MenuResponse.fromJson(res);
    });
  }

  Future<MenuResponse> getDrawerMenu() {
    return _netUtil.post(Constant.allDrawerMenu).then((dynamic res) {
      return MenuResponse.fromJson(res);
    });
  }

  Future<CommonResponse> setDefaultComp(String compId, String compName) {
    Map requestBody = {
      'CompId': compId,
      'CompName': compName
    };

    return _netUtil.post(Constant.setDefaultComp, body: requestBody).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<UserManagerResponse> getUserManagerList(int page, String search, String sortOrder, bool isDescending) {
    Map requestBody = {
      'RoleId': '0',
      'p_searchText': search,
      'p_sortColumn': sortOrder,
      'p_sortOrder': isDescending ? 'desc' : 'asc',
      'p_pageIndex': '10',
      'p_pageSize': page.toString()
    };

    return _netUtil
        // .post(Constant.userManager, body: requestBody)
        .post(Constant.userManager, body: requestBody)
        .then((dynamic res) {
      return UserManagerResponse.fromJson(res);
    });
  }

  Future<OrderListResponse> getOrderList(int page, String search) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '10',
      'p_Search': search,
    };

    return _netUtil.post(Constant.orderList, body: requestBody).then((dynamic res) {
      return OrderListResponse.fromJson(res);
    });
  }

  Future<OtpResponse> callOtpUrl(String url) {
    return _netUtil.get(url: url, isLoadVisible: true).then((dynamic res) {
      return OtpResponse.fromJson(res);
    });
  }

  Future<CommonResponse> deleteOrder(int id, int serId, String mode) {
    Map requestBody = {
      'id': id.toString(),
      'SerId': serId.toString(),
      'EntryMode': mode,
    };

    return _netUtil.post(Constant.deleteOrder, body: requestBody).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<AccountMasterResponse> getAccountMasterList(int page, String search, Map filter) {
    Map requestBody = {'p_PageNumber': page.toString(), 'p_RowsPerPage': '20', 'p_Search': search, 'Filter': jsonEncode(filter)};

    return _netUtil.post(Constant.accountMaster, body: requestBody).then((dynamic res) {
      return AccountMasterResponse.fromJson(res);
    });
  }

  Future<ContactMasterResponse> getContactMaster(int page, String search) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '10',
      'p_Search': search,
    };

    return _netUtil.post(Constant.contactMaster, body: requestBody).then((dynamic res) {
      return ContactMasterResponse.fromJson(res);
    });
  }

  Future<ReportByMenuResponse> getReportByMenu(String menuName) {
    Map requestBody = {'MenuName': menuName, 'RepMode': menuName == Constant.menuInvoiceVoucher ? 'Dynamic' : 'Normal'};

    return _netUtil.post(Constant.reportByMenu, body: requestBody).then((dynamic res) {
      return ReportByMenuResponse.fromJson(res);
    });
  }

  Future<ExportPDFResponse> getExportPDFFile(int rId, var request) {
    Map requestBody;

    if (rId == -1) {
      var scanRequest = ScanRequest.fromJson(json.decode(request));
      requestBody = {'ReportId': scanRequest.reportId, 'data': jsonEncode(scanRequest.data)};
    } else {
      requestBody = {'ReportId': rId.toString(), 'data': request};
    }

    return _netUtil.post(Constant.exportPDFFile, body: requestBody).then((dynamic res) {
      return ExportPDFResponse.fromJson(res);
    });
  }

  Future<FilterResponse> getReportFilter(String spName, int page, String search) {
    Map requestBody = {'p_PageNumber': page.toString(), 'p_RowsPerPage': '20', 'p_Search': search, 'p_SpName': spName, 'Field': '', 'Value': ''};

    return _netUtil.post(Constant.reportFilter, body: requestBody, loading: true).then((dynamic res) {
      return FilterResponse.fromJson(res);
    });
  }

  Future<RoleResponse> getRole(String spName, int page, String search) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '20',
      'p_Search': search,
      'p_SpName': spName,
    };

    return _netUtil.post(Constant.getAllAdminList, body: requestBody, loading: false).then((dynamic res) {
      return RoleResponse.fromJson(res);
    });
  }

  Future<PartyResponse> getParty(String role, int page, String search) {
    Map requestBody = {
      'RoleName': role,
      'p_PageNumber': page.toString(),
      'p_Search': search,
    };

    return _netUtil.post(Constant.getParty, body: requestBody, loading: false).then((dynamic res) {
      return PartyResponse.fromJson(res);
    });
  }

  Future<CommonResponse> updateUser(
    int clientId,
    String userName,
    String password,
    String fName,
    String lName,
    String email,
    String mobile,
    int roleId,
    int partyId,
    String partyName,
    int companyId,
    String companyName,
    bool isActive,
    bool isOTP,
    String entryMode,
    bool isDeviceLock,
  ) {
    Map requestBody = {
      'ClientId': clientId.toString(),
      'AppUserName': userName,
      'Password': password,
      'FirstName': fName,
      'LastName': lName,
      'AppUserEmailId': email,
      'SMSmobile': mobile,
      'RoleId': roleId.toString(),
      'PartyId': partyId.toString(),
      'PartyName': partyName,
      'CompanyId': companyId.toString(),
      'CompanyName': companyName,
      'IsActive': isActive.toString(),
      'IsOTP': isOTP.toString(),
      'EntryMode': entryMode,
      'IsDeviceLock': isDeviceLock.toString(),
    };

    return _netUtil.post(Constant.updateUser, body: requestBody, loading: true).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<CommonResponse> doClearLogins(String userName, String clientCode) {
    Map requestBody = {
      'username': userName,
      'clientcode': clientCode,
      'AFCM': "token",
      'IFCM': "",
    };

    return _netUtil.post('', body: requestBody).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }


  Future<CommonResponse> deleteUser(int clientId, int userId) {
    Map requestBody = {
      'UserId': userId.toString(),
      'ClientId': clientId.toString(),
    };

    return _netUtil.post(Constant.deleteUser, body: requestBody, loading: true).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<CommonResponse> changePassword(String oldPass, String newPass, String userName, String clientCode) {
    Map requestBody = {
      'CurrentPassword': oldPass,
      'NewPassword': newPass,
      'UserName': userName,
      'ClientCode': clientCode,
    };

    return _netUtil.post(Constant.changePassword, body: requestBody, loading: true).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<InvoiceResponse> getDynamicReport(int reportId, int page, String search, ExportPDFRequest request) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '10',
      'p_Search': search,
      'ReportId': reportId.toString(),
      'data': jsonEncode(request)
    };

    return _netUtil.post(Constant.getDynamicReport, body: requestBody, loading: true).then((dynamic res) {
      return InvoiceResponse.fromJson(res);
    });
  }

  Future<ExtraCtrlConfigResponse> getExtraCtrlConfig() {
    Map requestBody = {'p_Module': 'Order Entry'};

    return _netUtil.post(Constant.extraCtrlConfig, body: requestBody, loading: true).then((dynamic res) {
      return ExtraCtrlConfigResponse.fromJson(res);
    });
  }

  Future<CommonResponse> saveOrder(SaveOrderRequest request) {
    Map requestBody = {'data': jsonEncode(request)};

    return _netUtil.post(Constant.saveOrder, body: requestBody, loading: true).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<CommonResponse> saveOrderFile(String url, MultipartRequest request) {
    return _netUtil.postRequestWithFormDataNew(url, request).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<CommonResponse> updateAccountMaster(
    String name,
    int type,
    String gST,
    String add1,
    String add2,
    String city,
    String state,
    String pinCode,
    String mobile,
    String phone,
    String email,
    String mobileSMS,
    int transport,
    int station,
    int agentId,
    int group,
    int actionBy,
    int id,
    int schdId,
    String custType,
    String registrationType,
    String district,
    String market,
    String contactPerson,
    String bankName,
    String acountNumber,
    String iFSCCode,
    String branchName,
    String tANNo,
    String pANNo,
    String dhara,
    String mudat,
    String interestRate,
    String crDays,
    String dhara1,
    String dhara2,
    String dhara3,
    String refName,
    String remark,
    String reftxt1,
    String reftxt2,
    String reftxt3,
    String entryMode,
  ) {
    Map requestBody = {
      'Name': name,
      'Type': type.toString(),
      'GST': gST,
      'Add1': add1,
      'Add2': add2,
      'City': city,
      'State': state,
      'PinCode': pinCode,
      'Mobile': mobile,
      'Phone': phone,
      'Email': email,
      'MobileSMS': mobileSMS,
      'Transport': transport.toString(),
      'Station': station.toString(),
      'AgentId': agentId.toString(),
      'Group': group.toString(),
      'ActionBy': actionBy.toString(),
      'Id': id.toString(),
      'SchdId': schdId.toString(),
      'CustType': custType.toString(),
      'RegistrationType': registrationType,
      'District': district,
      'Market': market,
      'ContactPerson': contactPerson,
      'BankName': bankName,
      'AcountNumber': acountNumber,
      'IFSCCode': iFSCCode,
      'BranchName': branchName,
      'TANNo': tANNo,
      'PANNo': pANNo,
      'Dhara': dhara,
      'Mudat': mudat,
      'InterestRate': interestRate,
      'CrDays': crDays,
      'Dhara1': dhara1,
      'Dhara2': dhara2,
      'Dhara3': dhara3,
      'RefName': refName,
      'Remark': remark,
      'Reftxt1': reftxt1,
      'Reftxt2': reftxt2,
      'Reftxt3': reftxt3,
      'EntryMode': entryMode,
    };

    return _netUtil.post(Constant.addAccountMaster, body: requestBody, loading: false).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<DashboardResponse> getDashboard(DashboardRequest request) {
    Map requestBody = {
      'data': jsonEncode(request),
    };

    return _netUtil.post(Constant.dashboard, body: requestBody, loading: true).then((dynamic res) {
      return DashboardResponse.fromJson(res);
    });
  }

  Future<DashboardFilterResponse> getDashboardFilter(String search, String sortBy, String mode, String reportGrp, String conum) {
    Map requestBody = {
      'Mode': mode,
      'ReportGrp': reportGrp,
      'Conum': conum,
      'p_searchText': search,
      'p_sortBy': sortBy,
    };

    return _netUtil.post(Constant.dashboardFilter, body: requestBody, loading: true).then((dynamic res) {
      return DashboardFilterResponse.fromJson(res);
    });
  }

  Future<IssueEntryResponse> getIssueList(int typeId, int page, String search) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '20',
      'p_Search': search,
      'TypeId': typeId.toString(),
    };

    return _netUtil.post(Constant.issueEntryList, body: requestBody, loading: true).then((dynamic res) {
      return IssueEntryResponse.fromJson(res);
    });
  }

  Future<IssueItemDetailResponse> getIssueItemDetail(int page, String search, int mode, String qrCode, int serId, int ordType, int ordTrnId) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '20',
      'p_Search': search,
      'Mode': mode == 1 ? 'Normal' : 'Linked',
      'SerId': serId.toString(),
      'QRCode': qrCode,
      'OrdType': ordType.toString(),
      'OrdTrnId': ordTrnId.toString(),
    };

    return _netUtil.post(Constant.issueItemDetail, body: requestBody, loading: true).then((dynamic res) {
      return IssueItemDetailResponse.fromJson(res);
    });
  }

  Future<CommonResponse> deleteIssue(int id, int serId, String mode) {
    Map requestBody = {
      'id': id.toString(),
      'SerId': serId.toString(),
      'EntryMode': mode,
    };

    return _netUtil.post(Constant.deleteIssue, body: requestBody).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<CommonResponse> saveIssue(SaveIssueRequest request) {
    Map requestBody = {'data': jsonEncode(request.toJson())};

    return _netUtil.post(Constant.saveIssue, body: requestBody, loading: true).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<ApprovalPendingResponse> getApprovalPendingList(int typeId, int page, String search) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '20',
      'p_Search': search,
      'TypeId': typeId.toString(),
    };

    return _netUtil.post(Constant.approvalPending, body: requestBody, loading: true).then((dynamic res) {
      return ApprovalPendingResponse.fromJson(res);
    });
  }

  Future<CommonResponse> setApprovalCancel(int typeId, int trnId, int srNo, bool isApprove, String remark) {
    Map requestBody = {
      'TypeId': typeId.toString(),
      'TrnId': trnId.toString(),
      'Srno': srNo.toString(),
      'IsApprove': isApprove.toString(),
      'Remark': remark,
    };

    return _netUtil.post(Constant.approvalUpdate, body: requestBody, loading: true).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<ReceiveListResponse> getReceiveList(int typeId, int page, String search) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '20',
      'p_Search': search,
      'TypeId': typeId.toString(),
    };

    return _netUtil.post(Constant.receiveEntryList, body: requestBody, loading: true).then((dynamic res) {
      return ReceiveListResponse.fromJson(res);
    });
  }

  Future<CommonResponse> deleteReceive(int id, int serId, String mode) {
    Map requestBody = {
      'id': id.toString(),
      'SerId': serId.toString(),
      'EntryMode': mode,
    };

    return _netUtil.post(Constant.deleteReceive, body: requestBody).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<ReceiveItemDetailResponse> getReceiveItemDetail(int page, String search, int accountId, String qrCode, int serId) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '20',
      'p_Search': search,
      'AccountId': accountId.toString(),
      'SerId': serId.toString(),
      'QRCode': qrCode
    };

    return _netUtil.post(Constant.receiveItemDetail, body: requestBody, loading: true).then((dynamic res) {
      return ReceiveItemDetailResponse.fromJson(res);
    });
  }

  Future<CommonResponse> saveReceive(SaveReceiveRequest request) {
    Map requestBody = {'data': jsonEncode(request.toJson())};

    return _netUtil.post(Constant.saveReceive, body: requestBody, loading: true).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<ConfigAppMenuResponse> getAppConfig(int roleId, int module) {
    Map requestBody = {
      'p_RoleId': roleId.toString(),
      'p_Module': module == 1 ? 'Report' : 'Menu',
    };

    return _netUtil.post(Constant.getAppConfigData, body: requestBody, loading: true).then((dynamic res) {
      return ConfigAppMenuResponse.fromJson(res);
    });
  }

  Future<CommonResponse> setAppConfig(int roleId, int id, int value, String module) {
    Map requestBody = {
      'p_RoleId': roleId.toString(),
      'p_id': id.toString(),
      'p_Value': value.toString(),
      'p_Module': module,
    };

    return _netUtil.post(Constant.setAppConfigData, body: requestBody, loading: false).then((dynamic res) {
      return CommonResponse.fromJson(res);
    });
  }

  Future<OrderNumberResponse> getOrderNumberList(int serId, int accountId, int page, String search) {
    Map requestBody = {
      'p_PageNumber': page.toString(),
      'p_RowsPerPage': '20',
      'p_Search': search,
      'p_SpName': 'App_OrderItemList',
      'SerId': serId.toString(),
      'AccountId': accountId.toString(),
    };

    return _netUtil.post(Constant.getOrderNumber, body: requestBody, loading: true).then((dynamic res) {
      return OrderNumberResponse.fromJson(res);
    });
  }

  Future<VersionUpdateResponse> checkVersionUpdate() {
    Map requestBody = {
      'PkgName': Platform.isAndroid ? Constant.androidPkg : Constant.iOSPkg,
      'DeviceType': Platform.isAndroid ? 'ANDROID' : 'IOS',
    };

    return _netUtil.post(Constant.versionUpdate, body: requestBody, loading: true).then((dynamic res) {
      return VersionUpdateResponse.fromJson(res);
    });
  }
}
