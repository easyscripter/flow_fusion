import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'home_page_view_model.g.dart';

class HomePageViewModel = _HomePageViewModelBase with _$HomePageViewModel;

abstract class _HomePageViewModelBase with Store {
  late SessionDao _sessionDao;
  
  @observable
  PackageInfo? _packageInfo;

  // Индекс выбранного пункта меню (0 - Главная, 1 - Сессии, 2 - Настройки)
  @observable
  int selectedIndex = 0;

  @observable
  Session currentSession = Session(id: 1, name: "Default Session");

  @action
  void selectTab(int index) {
    selectedIndex = index;
  }

  @action
  Future<void> init() async {
    _sessionDao = GetIt.I.get<SessionDao>();
    final sessions = await _sessionDao.findAllSession();
    if (sessions.isEmpty) {
      _sessionDao.insertSession(currentSession);
      return;
    }
    currentSession = sessions.first;
    _packageInfo = GetIt.I.get<PackageInfo>();
  }

  @action
  Future<void> updateSessionName(String name, int sessionId) async {
    await _sessionDao.updateSessionName(name, sessionId);
  }

  @computed
  String get packageVersion => _packageInfo?.version ?? '';
}
