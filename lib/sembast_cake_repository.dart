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
  Future sort() async {
    var map = <dynamic, dynamic>{};
    var idmap = List<Map<String, dynamic>>{};
    var key = 0;

    var finder = Finder(
        //filter: Filter.greaterThan('name', 'yummyness'),
        sortOrders: [SortOrder('name')]);
    var record1 = await _store.find(_database, finder: finder);

    int count = record1.length;
    for (int i = 0; i < count; i++) {
      //print(i);
      map = cloneMap(record1[i].value);
      key = record1[i].key;
      idmap[i] = {'id': key, ...map};
      
      
      print(map);
      print(idmap);
    }
    //Map<String, dynamic> headerValue = HashMap<String, dynamic>.from(record1);
    //print('runtime: $map');
    //print(record);

    var cake = record1.toString();
    //List c = List<dynamic>.from(cake.split(' '));
    var cake1 = record1[0].value;

    //print(cake);
    var id = record1[0].key;
    //print(id);

    print(record1);
    //return b;
  }
}
