import 'dart:math';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';
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

  Future<List<Cake>> sort() async {
    List<Cake> idmap = [];

    var finder = Finder(
        //filter: Filter.greaterThan('name', 'yummyness'),
        sortOrders: [SortOrder('yummyness')]);
    var record = await _store.find(_database, finder: finder);

    for (int i = 0; i < record.length; ++i) {
      var map = cloneMap(record[i].value);
      var key = record[i].key;
      Cake sortcake = Cake.fromMap(key, map);
      idmap.add(sortcake);
    }

    return idmap;
  }

  Future search(String firstkey, String secondkey) async {
    return;
  }
}
