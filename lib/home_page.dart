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
  var controller = TextEditingController();
  bool isCaseSensitive = false;
  String firstkey = '';
  String secondkey = '';
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadCakes();
    //_sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //キーボードによって画面サイズを変更させないため
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
                    Text('FirstString:$firstkey  \nSecondString:$secondkey'),
                  ],
                )),
            Focus(
              child: TextFormField(
                //focusNode: focusNode,
                autofocus: true,
                textInputAction: TextInputAction.search,
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'hintText',
                  /*
                enabledBorder: OutlineInputBorder(
                    //何もしていない時の挙動、見た目
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.greenAccent,
                    )),
                */
                  border: OutlineInputBorder(
                    //フォーカスされた時の挙動、見た目
                    borderRadius: BorderRadius.circular(15),
                    //borderSide: const BorderSide(
                    //  color: Colors.amber,
                    //)
                  ),
                ),
                onChanged: (String val) {
                  //ユーザーがデバイス上でTextFieldの値を変更した場合のみ発動される.
                },
                onFieldSubmitted: (String val) {
                  print(val);
                  String location = val.substring(0, 1);
                  if (firstkey.isEmpty) {
                    setState(() => firstkey = val);
                    controller.clear(); //リセット処理
                    focusNode.requestFocus;
                    if (location == 'p') {
                      _search(firstkey, "");
                    }
                    return;
                  }
                  if (firstkey.isNotEmpty && secondkey.isEmpty) {
                    setState(() => secondkey = val);
                    controller.clear(); //リセット処理
                  }
                  if (firstkey.isNotEmpty && secondkey.isNotEmpty) {
                    _search(firstkey, secondkey);
                    firstkey = '';
                    secondkey = '';
                  }
                },
              ),
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
            onPressed: () => _addCake(firstkey, secondkey),
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

  _addCake(String farstkey, String secondkey) async {
    //final list = ["apple", "orange", "chocolate"]..shuffle();
    //final name = "My yummy ${list.first} cake";
    final name = farstkey;
    final yummyness = secondkey; //Random().nextInt(10);
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
        id: cake.id, name: cake.name, yummyness: cake.yummyness + '1');
    await _cakeRepository.updateCake(updatedCake);
    _loadCakes();
  }

  _sort() async {
    List<Cake> sortresult = await _cakeRepository.sort();
    setState(() => _cakes = sortresult);
    //_loadCakes();
  }

  _search(String firstkey, String secondkey) async {
    // 指定した文字列(パターン)で始まるか否かを調べる。
    var name = '';
    String location = firstkey.substring(0, 1);
    if (location == 'a') {
      name =
          "Area to $firstkey  by  Rack $secondkey "; //"My yummy ${list.first} cake";
    }
    if (location == 'r') {
      name =
          "Rack to $firstkey  by $secondkey Board"; //"My yummy ${list.first} cake";
    }
    if (location == 'b') {
      name =
          "Board to $firstkey  by $secondkey Contaner"; //"My yummy ${list.first} cake";
    }
    if (location == 'p') {
      List<Cake> sortresult = await _cakeRepository.search(firstkey);

      setState(() => _cakes = sortresult);
      print(_cakes.length);
      return;
    }

    //final id = 1;
    final yummyness = secondkey; // Random().nextInt(10);
    final newCake = Cake(id: Anything, name: name, yummyness: yummyness);
    await _cakeRepository.insertCake(newCake);
    _loadCakes();
  }
}
