import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flow_fusion/model/datasources/database/dao/phase_dao.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'phases_view_view_model.g.dart';

class PhasesViewViewModel = _PhasesViewViewModelBase with _$PhasesViewViewModel;

abstract class _PhasesViewViewModelBase with Store {
  late PhaseDao _phaseDao;

  @observable
  List<Phase> phases = [];

  @action
  Future<void> update(int sessionId) async {
    phases = await _phaseDao.findPhasesBySessionId(sessionId);
  }

  @action
  Future<void> init(int sessionId) async {
    _phaseDao = GetIt.I.get<PhaseDao>();
    await update(sessionId);
  }

  @action
  Future<void> addPhase(Phase phase) async {
    await _phaseDao.insertPhase(phase);
    await update(phase.sessionId);
  }

  @action
  Future<void> updatePhaseName(int phaseId, int sessionId, String name) async {
    await _phaseDao.updatePhaseName(phaseId, sessionId, name);
    await update(sessionId);
  }

  @action
  Future<void> updatePhaseDuration(
      int phaseId, int sessionId, Duration duration) async {
    await _phaseDao.updatePhaseDuration(phaseId, sessionId, duration);
    await update(sessionId);
  }

  @action
  Future<void> updatePhaseType(
      int phaseId, int sessionId, PhaseType type) async {
    await _phaseDao.updatePhaseType(phaseId, sessionId, type);
    await update(sessionId);
  }
}
