import 'package:flow_fusion/model/datasources/database/dao/phase_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'sessions_view_view_model.g.dart';

class SessionsViewViewModel = _SessionsViewViewModelBase
    with _$SessionsViewViewModel;

abstract class _SessionsViewViewModelBase with Store {
  late SessionDao _sessionDao;
  late PhaseDao _phaseDao;

  @observable
  bool isLoading = false;

  @observable
  List<Session> sessions = [];


  // Индекс текущего вида (0 - Список сессий, 1 - Создание новой сессии)
  @observable
  int currentViewIndex = 0;

  @observable
  Session? currentSession;

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      sessions = await _sessionDao.findAllSession();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> init() async {
    _sessionDao = GetIt.I.get<SessionDao>();
    _phaseDao = GetIt.I.get<PhaseDao>();
    currentViewIndex = 0;
    currentSession = null;
    await update();
  }

  @action
  Future<void> deleteSession(int id) async {
    await _sessionDao.deleteSessionById(id);
    await _phaseDao.deleteBySessionId(id);
    await update();
  }

  @action
  void setCurrentSession(Session? session) {
    currentSession = session;
  }
}
