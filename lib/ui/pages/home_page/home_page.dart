import 'package:flow_fusion/gen/assets.gen.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final prefs = GetIt.instance.get<Prefs>();
    prefs.buckets = 1;
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
