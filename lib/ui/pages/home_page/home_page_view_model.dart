import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'home_page_view_model.g.dart';

class HomePageViewModel = _HomePageViewModelBase with _$HomePageViewModel;

abstract class _HomePageViewModelBase with Store {
  late SessionDao _sessionDao;

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
  }

  @action
  Future<void> updateSessionName(String name, int sessionId) async {
    await _sessionDao.updateSessionName(name, sessionId);
  }
}
