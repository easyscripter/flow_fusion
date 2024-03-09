import 'package:flow_fusion/gen/assets.gen.dart';
import 'package:flow_fusion/model/datasources/database/dao/person_dao.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/model/entity/database/person.dart';
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

    (() async {
      final prefs = GetIt.I.get<Prefs>();

      prefs.buckets = 1;
      print(prefs.buckets);

      final personDao = GetIt.I.get<PersonDao>();

      await personDao.clear();
      await personDao.insertPerson(Person.optional(name: "Joe"));
      await personDao.insertPerson(Person.optional(name: "Mike"));
      personDao.findAllPeople().then((value) => print(value));
    })();
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
