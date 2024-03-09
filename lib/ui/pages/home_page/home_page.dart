import 'package:flow_fusion/gen/assets.gen.dart';
import 'package:flow_fusion/ui/pages/home_page/home_page_view_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _viewModel = HomePageViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flow Fusion'),
      ),
      body: Center(
        child: Assets.images.bucket.image(),
      ),
    );
  }
}
