import 'package:get/get.dart';
import 'package:td/screen/add_edit_account_master.dart';
import 'package:td/screen/add_issue_item_list.dart';
import 'package:td/screen/party.dart';
import 'package:td/screen/role.dart';

import '../screen/account_filter.dart';
import '../screen/add_edit_user.dart';
import '../screen/add_issue.dart';
import '../screen/add_issue_item.dart';
import '../screen/add_order.dart';
import '../screen/add_order_item.dart';
import '../screen/add_receive_entry.dart';
import '../screen/add_receive_item.dart';
import '../screen/add_receive_item_list.dart';
import '../screen/all_filter_screen.dart';
import '../screen/approval_pending_list.dart';
import '../screen/dashboard_filter.dart';
import '../screen/filter_screen.dart';
import '../screen/image_viewer.dart';
import '../screen/invoice.dart';
import '../screen/issue_list.dart';
import '../screen/login.dart';
import '../screen/main_screen.dart';
import '../screen/order_number.dart';
import '../screen/pdf_viewer.dart';
import '../screen/phone_auth.dart';
import '../screen/preload.dart';
import '../screen/product.dart';
import '../screen/product_details.dart';
import '../screen/receive_list.dart';
import '../screen/sale_purchase_report.dart';
import '../screen/splash.dart';
import '../screen/video_ads.dart';

class Router {
  static final route = [
    GetPage(name: '/splash', page: () => const Splash()),
    GetPage(name: '/login', page: () => const Login()),
    GetPage(name: '/preload', page: () => const Preload()),
    GetPage(name: '/product', page: () => const Product()),
    GetPage(name: '/product_details', page: () => const ProductDetails()),
    GetPage(name: '/phone_auth', page: () => const PhoneAuth()),
    GetPage(name: '/main_screen', page: () => MainScreen()),
    // GetPage(name: '/sale_purchase_report', page: () => const SalePurchaseReport()),
    GetPage(name: '/filter_screen', page: () => const FilterScreen()),
    GetPage(name: '/all_filter_screen', page: () => const AllFilterScreen()),
    GetPage(name: '/pdf_viewer', page: () => const PDFViewer()),
    GetPage(name: '/image_viewer', page: () => const ImageViewer()),
    GetPage(name: '/add_edit_user', page: () => const AddEditUser()),
    GetPage(name: '/role', page: () => const Role()),
    GetPage(name: '/party', page: () => const Party()),
    GetPage(name: '/invoice', page: () => const Invoice()),
    GetPage(name: '/add_edit_account_master', page: () => const AddEditAccountMaster()),
    GetPage(name: '/add_order', page: () => const AddOrder()),
    GetPage(name: '/add_order_item', page: () => const AddOrderItem()),
    GetPage(name: '/account_filter', page: () => const AccountFilter()),
    GetPage(name: '/dashboard_filter', page: () => const DashboardFilter()),
    GetPage(name: '/issue_list', page: () => const IssueList()),
    GetPage(name: '/add_issue', page: () => const AddIssue()),
    GetPage(name: '/add_issue_item', page: () => const AddIssueItem()),
    GetPage(name: '/add_issue_item_list', page: () => const AddIssueItemList()),
    GetPage(name: '/approval_pending_list', page: () => const ApprovalPendingList()),
    GetPage(name: '/receive_list', page: () => const ReceiveList()),
    GetPage(name: '/add_receive_entry', page: () => const AddReceiveEntry()),
    GetPage(name: '/add_receive_item', page: () => const AddReceiveItem()),
    GetPage(name: '/add_receive_item_list', page: () => const AddReceiveItemList()),
    GetPage(name: '/order_number', page: () => const OrderNumber()),
    GetPage(name: '/video_ads', page: () => const VideoAds()),
  ];
}
