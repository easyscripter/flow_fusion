import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'sessions_view_view_model.g.dart';

@injectable
class SessionsViewViewModel = _SessionsViewViewModelBase
    with _$SessionsViewViewModel;

abstract class _SessionsViewViewModelBase with Store {
  _SessionsViewViewModelBase(this._sessionDao);

  final SessionDao _sessionDao;

  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  List<Session> sessions = [];

  @action
  Future<void> update() async {
    try {
      isLoading = true;
      hasError = false;
      sessions = await _sessionDao.findAllSession();
    } catch (e, s) {
      AppLogger.error('SessionsViewViewModel.update', e, s);
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteSession(Session session) async {
    try {
      await _sessionDao.deleteSession(session);
      await update();
      return true;
    } catch (e, s) {
      AppLogger.error('SessionsViewViewModel.delete', e, s);
      return false;
    }
  }

  @action
  Future<void> init() async {
    await update();
  }
}
