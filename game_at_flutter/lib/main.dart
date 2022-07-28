import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'start_text_page.dart';
import 'my_license_page.dart';

void main() {
  // 広告周りの初期化
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 150,
              ),
              child: Image.asset("assets/images/TitleLogo.png"),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5,
              ),
              child: const Text(
                "敵に見つからずに脱出せよ",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
            // 始めるボタン
            Container(
              margin: EdgeInsets.only(
                top: 40,
                bottom: 10,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  onPrimary: Colors.grey,
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
                  // メインページに遷移させる（タイトルページは破棄する）
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return StartTextPage();
                  }));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, right: 50, left: 50),
                  child: Text(
                    "はじめる",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
            // ライセンス
            Container(
              margin: EdgeInsets.only(
                bottom: 40,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  onPrimary: Colors.grey,
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
                  // メインページに遷移させる（タイトルページは破棄する）
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return MyLicensePage();
                  }));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                  child: Text(
                    "ライセンス表示",
                    style: TextStyle(fontSize: 21, color: Colors.white),
                  ),
                ),
              ),
            ),
            // コピーライト表示
            Container(
              margin: EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              child: const Text(
                "Copyright © 2021 すたじお・くろす！",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
