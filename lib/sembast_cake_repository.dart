import 'dart:math';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembastsample/cake.dart';
import 'package:sembastsample/cake_repository.dart';

class SembastCakeRepository extends CakeRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store("cake_store1");

  @override
  Future<int> insertCake(Cake cake) async {
    return await _store.add(_database, cake.toMap());
  }

  @override
  Future updateCake(Cake cake) async {
    await _store.record(cake.id).update(_database, cake.toMap());
  }

  @override
  Future deleteCake(int cakeId) async {
    await _store.record(cakeId).delete(_database);
  }

  @override
  Future<List<Cake>> getAllCakes() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => Cake.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }

  // Initialize the encryption codec with a user password
  //var codec = getEncryptSembastCodec(password: '[your_user_password]');

  // Open the database with the codec
  //Database db = await factory.openDatabase(dbPath, codec: codec);

// ...your database is ready to use
  //SortOrder(String field, [bool ascending = true, bool nullLast = false])
  //Sort order on given field; by default ascending is true, nullLast is false.
  //factory
  //与えられたフィールドでのORT順序。デフォルトでは昇順は真、ヌルラストは偽です。
  //["apple", "orange", "chocolate"
  Future<List<RecordSnapshot<dynamic, dynamic>>> sort() async {
// Look for any animal "greater than" (alphabetically) 'cat'
// ordered by name

    // Finder object can also sort data.
    //final finder = Finder(sortOrders: [
    //  SortOrder(''),
    //]);

    var finder = Finder(
        //filter: Filter.greaterThan('name', 'yummyness'),
        sortOrders: [SortOrder('yummyness')]);
    var record = await _store.find(_database, finder: finder);

    print(finder);
    print(record);
    return record;
  }
}
