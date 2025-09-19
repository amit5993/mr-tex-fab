import 'package:td/model/menu_response.dart';

import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/login_response.dart';
import '../model/order_list_response.dart';
import '../model/user_manager_response.dart';
import '../model/user_verification_response.dart';

abstract class OrderListView {
  void onOrderListSuccess(OrderListResponse data);
  void onOrderDeleteSuccess(CommonResponse data);

  void onError(int errorCode);
}

class OrderListPresenter {
  OrderListView view;
  RestDataSource api = RestDataSource();

  OrderListPresenter(this.view);

  getOrderList(int page, String search) async {
    try {
      var data = await api.getOrderList(page, search);
      view.onOrderListSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

  deleteOrder(int id,int serId, String mode) async {
    try {
      var data = await api.deleteOrder( id, serId,  mode);
      view.onOrderDeleteSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
