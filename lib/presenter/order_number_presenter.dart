import '../api/rest_ds.dart';
import '../model/common_response.dart';
import '../model/filter_response.dart';
import '../model/issue_entry_response.dart';
import '../model/login_response.dart';
import '../model/order_number_response.dart';
import '../model/user_verification_response.dart';

abstract class OrderNumberView {
  void onGetIssueSuccess(OrderNumberResponse data);

  void onError(int errorCode);
}

class OrderNumberPresenter {
  OrderNumberView view;
  RestDataSource api = RestDataSource();

  OrderNumberPresenter(this.view);

  getOrderNumberList(int serId, int accountId, int page, String search) async {
    try {
      var data = await api.getOrderNumberList(serId,accountId, page, search);
      view.onGetIssueSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
