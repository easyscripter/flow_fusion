import 'package:flow_fusion/ui/views/sessions_view/sessions_view_view_model.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/widgets/quick_action_card.dart';
import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SessionsView extends StatefulWidget {
  const SessionsView({super.key});

  @override
  State<SessionsView> createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {
  final _viewModel = SessionsViewViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;
    return Scaffold(
      body: Observer(
        builder: (context) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = AppSizes.defaultCrossAxisCount;
                      if (constraints.maxWidth > 800) {
                        crossAxisCount = 3;
                      }
                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 4;
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: AppSizes.gridSpacing,
                          mainAxisSpacing: AppSizes.gridSpacing,
                          childAspectRatio: AppSizes.childAspectRatio,
                        ),
                        itemCount: _viewModel.sessions.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _viewModel.sessions.length) {
                            return QuickActionCard(
                              icon: Icon(
                                Icons.add_circle,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              title: 'Создать сессию',
                              onTap: () =>
                                  _createNewSession(), // Переход к сессиям
                            );
                          }

                          final session = _viewModel.sessions[index];
                          return QuickActionCard(
                            title: session.name,
                            onTap: () => _openSession(session),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _createNewSession() {
    // TODO: Реализовать создание новой сессии
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Создание новой сессии')));
  }

  void _openSession(Session session) {
    // TODO: Реализовать навигацию к сессии
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Открытие сессии: ${session.name}')));
  }
}
