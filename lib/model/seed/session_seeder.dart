import 'package:flow_fusion/model/datasources/database/dao/session_dao.dart';
import 'package:flow_fusion/model/datasources/database/dao/session_timer_dao.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/model/entity/database/session_timer.dart';
import 'package:flow_fusion/model/seed/session_templates.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SessionSeeder {
  final Prefs _prefs;
  final SessionDao _sessionDao;
  final SessionTimerDao _timerDao;

  SessionSeeder(this._prefs, this._sessionDao, this._timerDao);

  Future<void> seedIfNeeded() async {
    try {
      final List<Session> existing = await _sessionDao.findAllSession();
      if (existing.isNotEmpty) {
        _prefs.templatesSeeded = true;
        return;
      }

      final String lang = _prefs.language ?? 'en';

      for (final SessionTemplate template in kSessionTemplates) {
        final Session session = Session.create(
          title: template.title,
          description: template.descriptionFor(lang),
          icon: template.icon,
        );
        final int sessionId = await _sessionDao.insertSession(session);

        final List<SessionTimer> timers = <SessionTimer>[
          for (int i = 0; i < template.timers.length; i++)
            SessionTimer.create(
              sessionId: sessionId,
              position: i,
              title: template.timers[i].titleFor(lang),
              type: template.timers[i].type,
              plannedDuration: Duration(minutes: template.timers[i].minutes),
            ),
        ];
        await _timerDao.insertTimers(timers);
      }

      _prefs.templatesSeeded = true;
    } catch (e, s) {
      AppLogger.error('SessionSeeder.seedIfNeeded', e, s);
    }
  }
}
