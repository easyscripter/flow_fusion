import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'session_view_view_model.g.dart';

class SessionViewViewModel = _SessionViewViewModelBase
    with _$SessionViewViewModel;

abstract class _SessionViewViewModelBase with Store {
  late SessionDao _sessionDao;
  @observable
  int currentView = 1;
  @observable
  Session currentSession = Session(name: 'Default Session');

  Future<void> _setupDataBase() async {
    _sessionDao = GetIt.I.get<SessionDao>();
  }

  _SessionViewViewModelBase() {
    _setupDataBase();
  }

  @action
  void setCurrentView(int index) {
    currentView = index;
  }

  @action
  Future<void> init() async {
    currentView = 1;
    final sessionDao = GetIt.I.get<SessionDao>();
    final sessions = await sessionDao.findAllSession();
    // TODO: change to check default session from settings
    if (sessions.isEmpty) {
      sessionDao.insertSession(currentSession);
    } else {
      currentSession = sessions.first;
    }
  }

  @action
  Future<void> updateSessionName(String name) async {
    await _sessionDao.updateSessionName(name, currentSession.id!);
  }
}
