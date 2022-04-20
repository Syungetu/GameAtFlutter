import 'package:flutter/material.dart';

import 'game_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '見下ろし型アクションゲーム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyTitlePage(),
    );
  }
}

/// タイトルページ
class MyTitlePage extends StatefulWidget {
  const MyTitlePage({Key? key}) : super(key: key);

  @override
  State<MyTitlePage> createState() => _MyTitlePageState();
}

class _MyTitlePageState extends State<MyTitlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 50,
              ),
              child: const Text(
                "Flutter De アクションゲーム",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 50,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue.shade300,
                  onPrimary: Colors.black,
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
                  // メインページに遷移させる（タイトルページは破棄する）
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return GameMainPage();
                  }));
                },
                child: const Text(
                  "はじめる",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
