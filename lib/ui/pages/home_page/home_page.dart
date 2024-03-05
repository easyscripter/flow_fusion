import 'package:flow_fusion/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
