import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:mobx/mobx.dart';

part 'sessions_view_view_model.g.dart';

class SessionsViewViewModel = _SessionsViewViewModelBase
    with _$SessionsViewViewModel;

abstract class _SessionsViewViewModelBase with Store {
  _SessionsViewViewModelBase(this._sessionDao);

  final SessionDao _sessionDao;

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
  Future<void> deleteSession(Session session) async {
    await _sessionDao.deleteSession(session);
    await update();
  }

  @action
  Future<void> init() async {
    await update();
  }
}
