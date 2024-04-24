import 'package:flow_fusion/model/datasources/database/dao/phase_dao.dart';
import 'package:flow_fusion/model/entity/database/phase.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'phases_view_view_model.g.dart';

class PhasesViewViewModel = _PhasesViewViewModelBase with _$PhasesViewViewModel;

abstract class _PhasesViewViewModelBase with Store {
  late PhaseDao _phaseDao;

  Future<void> _setupDataBase() async {
    _phaseDao = GetIt.I.get<PhaseDao>();
  }

  @action
  Future<void> init() async {
    await _setupDataBase();
  }

  @action
  Future<List<Phase>> getPhasesBySessionId(int sessionId) async {
    return await _phaseDao.findPhasesBySessionId(sessionId);
  }
}
