import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'home_page_view_model.g.dart';

class HomePageViewModel = _HomePageViewModelBase with _$HomePageViewModel;

abstract class _HomePageViewModelBase with Store {
  
  @observable
  PackageInfo? _packageInfo;

  // Индекс выбранного пункта меню (0 - Главная, 1 - Сессии, 2 - Настройки)
  @observable
  int selectedIndex = 0;

  @action
  void selectTab(int index) {
    selectedIndex = index;
  }

  @action
  Future<void> init() async {
    _packageInfo = GetIt.I.get<PackageInfo>();
  }

  @computed
  String get packageVersion => _packageInfo?.version ?? '';
}
