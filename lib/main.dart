import 'package:flutter/material.dart';
import 'package:http_request_firebase/pages/add-player-page.dart';
import 'package:http_request_firebase/pages/detail-player-page.dart';
import 'package:http_request_firebase/pages/home-page.dart';
import 'package:http_request_firebase/provider/player.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Players(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          AddPlayer.routeName:(context) => AddPlayer(),
          DetailPlayer.routeName:(context) => DetailPlayer(),
        },
      ),
    );
  }
}