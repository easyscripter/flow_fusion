import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'sessions_view_view_model.g.dart';

class SessionsViewViewModel = _SessionsViewViewModelBase
    with _$SessionsViewViewModel;

abstract class _SessionsViewViewModelBase with Store {
  late SessionDao _sessionDao;

  @observable
  bool isLoading = false;

  @observable
  List<Session> sessions = [];

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
    await update();
  }
}
