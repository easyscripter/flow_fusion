import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/model/datasources/database/dao/phase_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'session_view_view_model.g.dart';

class SessionViewViewModel = _SessionViewViewModelBase
    with _$SessionViewViewModel;

abstract class _SessionViewViewModelBase with Store {
  late SessionDao _sessionDao;
  late PhaseDao _phaseDao;

  @observable
  bool isLoading = false;

  @observable
  Session? currentSession;

  @observable
  ObservableList<Phase> phases = ObservableList<Phase>();

  @action
  Future<void> init(Session? session) async {
    _sessionDao = GetIt.I.get<SessionDao>();
    _phaseDao = GetIt.I.get<PhaseDao>();

    isLoading = true;

    try {
      if (session != null && session.id != null) {
        currentSession = session;
        await _loadPhases(session.id!);
      }
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _loadPhases(int sessionId) async {
    final loadedPhases = await _phaseDao.findPhasesBySessionId(sessionId);
    phases.clear();
    phases.addAll(loadedPhases);
  }

  @action
  void updateSession(Session session) {
    if (currentSession != null) {
      currentSession = session;
      _sessionDao.updateSessionName(currentSession?.name ?? '', currentSession?.id! ?? 0);
    }
  }

  @action
  void addPhase(String name, Duration duration, PhaseType type) {
    final newPhase = Phase(name: name, duration: duration, type: type, sessionId: currentSession!.id!);
    phases.add(newPhase);
  }
  
  @action
  void updatePhase(int index, String name, Duration duration, PhaseType type) {
    if (index >= 0 && index < phases.length) {
      final phase = phases[index];
      final updatedPhase = Phase(
        id: phase.id,
        name: name,
        duration: duration,
        type: type,
        sessionId: phase.sessionId
      );
      phases[index] = updatedPhase;
    }
  }
  
  @action
  void deletePhase(int index) {
    if (index >= 0 && index < phases.length) {
      phases.removeAt(index);
    }
  }
}
