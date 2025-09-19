import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/login_response.dart';
import '../model/order_list_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class AccountFilterView {
  void onOrderListSuccess(OrderListResponse data);

  void onError(int errorCode);
}

class AccountFilterPresenter {
  AccountFilterView view;
  RestDataSource api = RestDataSource();

  AccountFilterPresenter(this.view);

  getOrderList(int page, String search) async {
    try {
      var data = await api.getOrderList(page, search);
      view.onOrderListSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
