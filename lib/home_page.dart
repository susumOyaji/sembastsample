import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:sembastsample/cake.dart';
import 'package:sembastsample/cake_repository.dart';
import 'sembast_cake_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CakeRepository _cakeRepository = GetIt.I.get();
  List<Cake> _cakes = [];
  int Anything = 0; //dumy
  TextEditingController? controller;
  bool isCaseSensitive = false;

  @override
  void initState() {
    super.initState();
    _loadCakes();
    //_sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text("My Favorite Cakes"),
      //),
      body: Container(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //12crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FirstString:  \nSecondString:'),
                  ],
                )),
            TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (String val) {
                print(val);
                _search(val, val);
                //search(val, isCaseSensitive: isCaseSensitive);
                controller?.clear(); //リセット処理

                //controller?.clear(); //リセット処理
              },
              controller: controller,
              decoration: InputDecoration(
                hintText: 'hintText',
                enabledBorder: OutlineInputBorder(
                    //何もしていない時の挙動、見た目
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.greenAccent,
                    )),
                focusedBorder: OutlineInputBorder(
                    //フォーカスされた時の挙動、見た目
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.amber,
                    )),
              ),
              onChanged: (String val) {
                //ユーザーがデバイス上でTextFieldの値を変更した場合のみ発動される.
                //search(val, isCaseSensitive: isCaseSensitive);
                //controller?.clear(); //リセット処理
              },
            ),
            ListView.builder(
              //reverse: true, // この行を追加
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cakes.length,
              itemBuilder: (BuildContext context, int index) {
                final cake = _cakes[index];
                return ListTile(
                  title: Text(cake.name),
                  subtitle: Text("Yummyness: ${cake.yummyness}  ID:${cake.id}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteCake(cake),
                    //style: TextStyle(fontSize: 10)
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () => _editCake(cake),
                  ),
                );
              },
            ),
          ],
        ),
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
              Icons.sort,
            ),
            onPressed: _sort,
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
    final newCake = Cake(id: Anything, name: name, yummyness: yummyness);
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
    final updatedCake = cake.copyWith(
        id: cake.id, name: cake.name, yummyness: cake.yummyness + 1);
    await _cakeRepository.updateCake(updatedCake);
    _loadCakes();
  }

  _sort() async {
    List<Cake> sortresult = await _cakeRepository.sort();
    setState(() => _cakes = sortresult);
    //_loadCakes();
  }

  __search(String val, String val) async {
    List<Cake> searchresult = await _cakeRepository.search(val, val);
  }
}
