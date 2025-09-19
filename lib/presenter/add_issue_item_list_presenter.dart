import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/issue_entry_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';

abstract class AddIssueItemListView {
  void onIssueItemDetailSuccess(IssueItemDetailResponse data);

  void onError(int errorCode);
}

class AddIssueItemListPresenter {
  AddIssueItemListView view;
  RestDataSource api = RestDataSource();

  AddIssueItemListPresenter(this.view);

  getIssueItemDetail(int page, String search, int mode, String qrCode, int serId, int ordType, int ordTrnId) async {
    try {
      var data = await api.getIssueItemDetail(page, search, mode, qrCode, serId, ordType, ordTrnId);
      view.onIssueItemDetailSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
