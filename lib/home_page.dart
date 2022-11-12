import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembastsample/cake.dart';
import 'package:sembastsample/cake_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CakeRepository _cakeRepository = GetIt.I.get();
  List<Cake> _cakes = [];

  @override
  void initState() {
    super.initState();
    _loadCakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorite Cakes"),
      ),
      body: ListView.builder(
        itemCount: _cakes.length,
        itemBuilder: (context, index) {
          final cake = _cakes[index];
          return ListTile(
            title: Text(cake.name),
            subtitle: Text("Yummyness: ${cake.yummyness}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteCake(cake),
            ),
            leading: IconButton(
              icon: const Icon(Icons.thumb_up),
              onPressed: () => _editCake(cake),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: const Icon(
              Icons.add,
            ),
            onPressed: _addCake,
          ),
          FloatingActionButton(
            child: const Icon(
              Icons.edit,
            ),
            onPressed: _sort(context),
          ),
        ],
      ),
    );
  }

  _loadCakes() async {
    final cakes = await _cakeRepository.getAllCakes();
    setState(() => _cakes = cakes);
  }

  _addCake() async {
    final list = ["apple", "orange", "chocolate"]..shuffle();
    final name = "My yummy ${list.first} cake";
    //final id = 1;
    final yummyness = Random().nextInt(10);
    final newCake = Cake(id: yummyness, name: name, yummyness: yummyness);
    await _cakeRepository.insertCake(newCake);
    _loadCakes();
  }

  _deleteCake(Cake cake) async {
    await _cakeRepository.deleteCake(cake.id);
    _loadCakes();
  }

  _editCake(Cake cake) async {
    final list = ["apple", "orange", "chocolate"]..shuffle();
    final name = "My yummy ${list.first} cake";
    final updatedCake =
        cake.copyWith(id: cake.id, name: name, yummyness: cake.yummyness + 1);
    await _cakeRepository.updateCake(updatedCake);
    _loadCakes();
  }

  _sort(field) async {
    SortOrder(field);
    await _cakeRepository.sort(SortOrder(field));
    _loadCakes();
  }
}
