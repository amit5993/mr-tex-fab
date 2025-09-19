import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/issue_entry_response.dart';
import '../model/issue_item_detail_response.dart';
import '../model/login_response.dart';
import '../model/receive_item_detail_response.dart';
import '../model/user_verification_response.dart';

abstract class AddReceiveItemListView {
  void onReceiveItemDetailSuccess(ReceiveItemDetailResponse data);

  void onError(int errorCode);
}

class AddReceiveItemListPresenter {
  AddReceiveItemListView view;
  RestDataSource api = RestDataSource();

  AddReceiveItemListPresenter(this.view);

  getReceiveItemDetail(int page, String search, int accountId, String qrCode, int serId) async {
    try {
      var data = await api.getReceiveItemDetail(page, search, accountId, qrCode, serId);
      view.onReceiveItemDetailSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }
}
