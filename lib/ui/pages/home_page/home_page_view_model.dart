import 'package:flow_fusion/model/datasources/database/dao/person_dao.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/model/entity/database/person.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'home_page_view_model.g.dart';

class HomePageViewModel = _HomePageViewModelBase with _$HomePageViewModel;

abstract class _HomePageViewModelBase with Store {
  @observable
  int selectedIndex = 0;

  @action
  void selectTab(int index) {
    this.selectedIndex = index;
  }

  @action
  Future<void> init() async {
    final prefs = GetIt.I.get<Prefs>();

    prefs.buckets = 1;
    print(prefs.buckets);

    final personDao = GetIt.I.get<PersonDao>();

    await personDao.clear();
    await personDao.insertPerson(Person.optional(name: "Ann"));
    await personDao.insertPerson(Person.optional(name: "Bob"));
    personDao.findAllPeople().then((value) => print(value));
  }
}
