import 'package:flow_fusion/enums/timer_type.dart';

class SessionTemplateTimer {
  final TimerType type;
  final int minutes;

  const SessionTemplateTimer({required this.type, required this.minutes});

  String titleFor(String lang) {
    final bool isRu = lang == 'ru';
    if (type == TimerType.work) {
      return isRu ? 'Работа' : 'Focus';
    }
    return isRu ? 'Отдых' : 'Break';
  }
}

class SessionTemplate {
  final String title;
  final String descriptionEn;
  final String descriptionRu;
  final String icon;
  final List<SessionTemplateTimer> timers;

  const SessionTemplate({
    required this.title,
    required this.descriptionEn,
    required this.descriptionRu,
    required this.icon,
    required this.timers,
  });

  String descriptionFor(String lang) =>
      lang == 'ru' ? descriptionRu : descriptionEn;
}

const List<SessionTemplate> kSessionTemplates = <SessionTemplate>[
  SessionTemplate(
    title: 'Study',
    descriptionEn: 'Better session flow for study',
    descriptionRu: 'Отлично подходит для учебы',
    icon: 'book',
    timers: <SessionTemplateTimer>[
      SessionTemplateTimer(type: TimerType.work, minutes: 30),
      SessionTemplateTimer(type: TimerType.chill, minutes: 5),
      SessionTemplateTimer(type: TimerType.work, minutes: 30),
      SessionTemplateTimer(type: TimerType.chill, minutes: 5),
      SessionTemplateTimer(type: TimerType.work, minutes: 30),
    ],
  ),
  SessionTemplate(
    title: 'Deep Work',
    descriptionEn: 'Good session Flow when you need hard working',
    descriptionRu: 'Отлично подходит , когда надо сосредоточиться на работе',
    icon: 'target',
    timers: <SessionTemplateTimer>[
      SessionTemplateTimer(type: TimerType.work, minutes: 50),
      SessionTemplateTimer(type: TimerType.chill, minutes: 10),
      SessionTemplateTimer(type: TimerType.work, minutes: 50),
      SessionTemplateTimer(type: TimerType.chill, minutes: 10),
    ],
  ),
  SessionTemplate(
    title: 'Sprint',
    descriptionEn:
        'Good session flow when you need make something faster and will be focused',
    descriptionRu:
        'Отлично подходит, когда надо сфокусироваться и что то быстро сделать',
    icon: 'bolt',
    timers: <SessionTemplateTimer>[
      SessionTemplateTimer(type: TimerType.work, minutes: 15),
      SessionTemplateTimer(type: TimerType.chill, minutes: 3),
      SessionTemplateTimer(type: TimerType.work, minutes: 15),
      SessionTemplateTimer(type: TimerType.chill, minutes: 3),
      SessionTemplateTimer(type: TimerType.work, minutes: 15),
      SessionTemplateTimer(type: TimerType.chill, minutes: 3),
    ],
  ),
];
