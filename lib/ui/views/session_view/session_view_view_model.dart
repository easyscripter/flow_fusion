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
