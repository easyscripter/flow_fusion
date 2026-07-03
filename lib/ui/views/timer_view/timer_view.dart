import 'package:flow_fusion/controllers/active_timer_controller.dart';
import 'package:flow_fusion/ui/views/timer_view/widgets/timer_body.dart';
import 'package:flow_fusion/ui/widgets/timer_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final _controller = GetIt.I.get<ActiveTimerController>();
  final _routeScrollController = ScrollController();

  late final ReactionDisposer _viewReactionDisposer;
  late final ReactionDisposer _scrollReactionDisposer;
  int _lastAutoScrolledIndex = -1;

  @override
  void initState() {
    super.initState();
    _viewReactionDisposer = reaction<int>(
      (_) => Object.hash(
        _controller.state.hasActiveSession,
        _controller.state.currentIndex,
        _controller.state.isPaused,
        _controller.state.remaining.inSeconds,
        _controller.state.timers.length,
      ),
      (_) {
        if (!mounted) return;
        setState(() {});
      },
    );
    _scrollReactionDisposer = reaction<int>((_) => _controller.currentIndex, (
      index,
    ) {
      if (!mounted) return;
      if (index != _lastAutoScrolledIndex) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCurrentStation();
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentStation(animated: false);
    });
  }

  @override
  void dispose() {
    _viewReactionDisposer();
    _scrollReactionDisposer();
    _routeScrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentStation({bool animated = true}) {
    if (!_routeScrollController.hasClients || !_controller.hasActiveSession) {
      return;
    }

    final index = _controller.currentIndex;
    if (index < 0) return;

    _lastAutoScrolledIndex = index;
    const itemWidth = 136.0;
    const gap = 8.0;
    final viewport = _routeScrollController.position.viewportDimension;
    final target =
        (index * (itemWidth + gap)) - (viewport / 2) + (itemWidth / 2);
    final offset = target.clamp(
      0.0,
      _routeScrollController.position.maxScrollExtent,
    );

    if (!animated) {
      _routeScrollController.jumpTo(offset);
      return;
    }

    _routeScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: !state.hasActiveSession
          ? const TimerEmptyState()
          : TimerBody(
              state: state,
              controller: _controller,
              routeScrollController: _routeScrollController,
            ),
    );
  }
}
