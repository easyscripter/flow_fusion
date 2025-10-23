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
    final Brightness _brightness = Theme.of(context).brightness;
    bool isDark = _brightness == Brightness.dark;
    return Scaffold(
      body: Observer(
        builder: (context) {
          if (_viewModel.sessions.isEmpty) {
            return _buildEmptyState();
          }
          
          return _buildSessionsGrid(isDark);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'У вас пока нет сессий',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте первую сессию для начала работы',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createNewSession,
            icon: const Icon(Icons.add),
            label: const Text('Создать сессию'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsGrid(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Определяем количество колонок в зависимости от ширины
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
            itemCount: _viewModel.sessions.length + 1, // +1 для кнопки создания
            itemBuilder: (context, index) {
              if (index == _viewModel.sessions.length) {
                // Кнопка создания новой сессии
                return _buildCreateSessionCard(isDark);
              }
              
              final session = _viewModel.sessions[index];
              return _buildSessionCard(session);
            },
          );
        },
      ),
    );
  }

  Widget _buildCreateSessionCard(bool isDark) {
    return QuickActionCard(
      icon: Icons.add_circle_outline,
      title: 'Создать сессию',
      color: isDark ? Colors.white : Colors.black,
      onTap: _createNewSession,
    );
  }

  Widget _buildSessionCard(Session session) {
    return QuickActionCard(
      title: session.name,
      onTap: () => _openSession(session),
    );
  }

  void _createNewSession() {
    // TODO: Реализовать создание новой сессии
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Создание новой сессии')),
    );
  }

  void _openSession(Session session) {
    // TODO: Реализовать навигацию к сессии
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Открытие сессии: ${session.name}')),
    );
  }
}