import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'session_view_view_model.g.dart';

class SessionViewViewModel = _SessionViewViewModelBase
    with _$SessionViewViewModel;

abstract class _SessionViewViewModelBase with Store {
  @observable
  int currentView = 1;

  @action
  void setCurrentView(int index) {
    currentView = index;
  }

  @action
  Future<void> init() async {
    currentView = 1;
  }
}
