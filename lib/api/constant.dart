class Constant {
  //stage database
  // static const String baseURL = 'http://ttms.turboinfotech.com/api/'; //Live
  static const String baseURL = 'http://tdmsapi.technodesksoftware.com/api/'; //Live

  static String pdfUrl = 'http://103.116.176.78:8080/';

  static String androidPkg = 'com.mrtex.fab';
  static String iOSPkg = 'com.mrtex.fab';
  static String iOSId = '1556868598';

  static String adhat = 'MRTexAdhat';
  static String agency = 'MRTexAgency';

  static const String userVerify = '${baseURL}appusers/GetUserVerificationBy';
  static const String login = '${baseURL}appusers/authenticateuser';
  static const String logout = '${baseURL}appusers/userlogout';
  static const String getAppInitialAPI = '${baseURL}appmenu/getAppInitialAPI';
  static const String allMenu = '${baseURL}appmenu/getallappmenubyroleid';
  static const String allDrawerMenu = '${baseURL}appmenu/GetMenuDrawerList';
  static const String setDefaultComp = '${baseURL}appmenu/UpdDefaultComp';
  static const String userManager = '${baseURL}appusers/GetAllAdminUserList';
  static const String orderList = '${baseURL}product/OrderListApi';
  static const String accountMaster = '${baseURL}appparty/AccountListing';
  static const String contactMaster = '${baseURL}appusers/getcontact';
  static const String reportByMenu = '${baseURL}appreport/getreportbymenu';
  static const String reportFilter = '${baseURL}appreport/getreportfilter';
  static const String exportPDFFile = '${baseURL}appreport/GetExportPDFfile';
  static const String getAllAdminList = '${baseURL}appreport/GetAllAdminList';
  static const String getParty = '${baseURL}appusers/getrolewiseparty';
  static const String updateUser = '${baseURL}appusers/insertapiuser';
  static const String deleteUser = '${baseURL}appusers/deleteuserbyid';
  static const String changePassword = '${baseURL}appusers/resetPassword';
  static const String getDynamicReport = '${baseURL}appreport/GetDynamicReportData';
  static const String saveOrder = '${baseURL}product/SaveOrderEntry';
  static const String extraCtrlConfig = '${baseURL}product/ExtraCtrlConfig';
  // static const String saveOrder = '${baseURL}product/SaveOrderAgency';
  static const String addAccountMaster = '${baseURL}appparty/insertparty';
  static const String dashboard = '${baseURL}appdashboard/GetDashboardData';
  static const String dashboardFilter = '${baseURL}appdashboard/GetDashboardFilterData';
  static const String deleteOrder = '${baseURL}product/DeleteEntry';
  static const String issueEntryList = '${baseURL}product/IssueEntryListApi';
  static const String issueItemDetail = '${baseURL}product/IssueItemDetail';
  static const String deleteIssue = '${baseURL}product/DeleteEntry';
  static const String saveIssue = '${baseURL}product/SaveIssueEntry';
  static const String approvalPending = '${baseURL}product/ApprovalPendingList';
  static const String approvalUpdate = '${baseURL}product/ApprovalUpdate';
  static const String receiveEntryList = '${baseURL}product/ReceiveEntryListApi';
  static const String deleteReceive = '${baseURL}product/DeleteEntry';
  static const String receiveItemDetail = '${baseURL}product/ReceiveItemDetail';
  static const String saveReceive = '${baseURL}product/SaveReceiveEntry';
  static const String getAppConfigData = '${baseURL}appreport/GetAppConfigData';
  static const String setAppConfigData = '${baseURL}appreport/SetAppConfigData';
  static const String getOrderNumber = '${baseURL}product/PrcBaseItemDetail';
  static const String versionUpdate = '${baseURL}appCommon/CheckAppVersion';

  static String menuSaleReport = 'Sale/Purchase Report';
  static String menuOrderReport = 'Order Report';
  static String menuOutstanding = 'Outstanding';
  static String menuLedger = 'Ledger';
  static String menuInvoiceVoucher = 'Invoice/Voucher Print';

}
