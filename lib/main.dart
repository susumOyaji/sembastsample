import 'package:flutter/material.dart';
import 'package:sembastsample/home_page.dart';
import 'package:sembastsample/init.dart';

void main() => runApp(const CakeApp());

class CakeApp extends StatefulWidget {
  const CakeApp({super.key});
  @override
  _CakeAppState createState() => _CakeAppState();
}

class _CakeAppState extends State<CakeApp> {
  final Future _init =  Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Favorite Cakes',
      home: FutureBuilder(
        future: _init,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
            return HomePage();
          } else {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

