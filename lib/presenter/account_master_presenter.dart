import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/account_master_response.dart';
import '../model/login_response.dart';
import '../model/order_list_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class AccountMasterView {
  void onOrderListSuccess(AccountMasterResponse data);

  void onError(int errorCode);
}

class AccountMasterPresenter {
  AccountMasterView view;
  RestDataSource api = RestDataSource();

  AccountMasterPresenter(this.view);

  getAccountMasterList(int page, String search, Map filter) async {
    try {
      var data = await api.getAccountMasterList(page, search,filter);
      view.onOrderListSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
