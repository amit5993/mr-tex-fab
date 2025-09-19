import '../api/rest_ds.dart';
import '../model/filter_response.dart';
import '../model/login_response.dart';
import '../model/user_verification_response.dart';

abstract class FilterView {
  void onGetFilterSuccess(FilterResponse data);

  void onError(int errorCode);
}

class FilterPresenter {
  FilterView view;
  RestDataSource api = RestDataSource();

  FilterPresenter(this.view);

  reportByFilter(String spName, int page, String search) async {
    try {
      var data = await api.getReportFilter(spName, page, search);
      view.onGetFilterSuccess(data);
    } on Exception catch (error) {
      view.onError(int.parse(error.toString().replaceAll("Exception: ", "")));
    }
  }

}
