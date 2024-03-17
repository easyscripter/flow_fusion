import 'package:floor/floor.dart';
import 'package:flow_fusion/model/datasources/database/app_database.dart';
import 'package:flow_fusion/model/entity/database/person.dart';
import 'package:injectable/injectable.dart';

// As an example
@singleton
@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPeople();

  @Query('SELECT name FROM Person')
  Stream<List<String>> findAllPeopleName();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Person?> findPersonById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPerson(Person person);

  @Query('DELETE FROM Person')
  Future<void> clear();

  @factoryMethod
  static PersonDao create(AppDatabase appDatabase) => appDatabase.personDao;
}
