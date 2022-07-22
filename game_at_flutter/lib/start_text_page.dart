import 'package:flutter/material.dart';

import 'game_main_page.dart';

/// ゲーム開始時のテキストページ
class StartTextPage extends StatefulWidget {
  // コンストラクタ
  StartTextPage({Key? key}) : super(key: key);

  @override
  State<StartTextPage> createState() => _StartTextPageState();
}

/// 動的ページ
class _StartTextPageState extends State<StartTextPage> {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 100,
                  ),
                  child: Image.asset("assets/images/prologue.png"),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 2,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "プロローグ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
            // テキスト表示
            Container(
              margin: EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Text(
                GetShowResultText(),
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // 次のページ表示
            Container(
              margin: EdgeInsets.only(
                bottom: 50,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  onPrimary: Colors.grey,
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
                  // ゲームメインページに遷移する
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return GameMainPage();
                  }));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, right: 50, left: 50),
                  child: Text(
                    "脱出する",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// テキスト表示
  String GetShowResultText() {
    String resultText =
        "ある日、私が住んでいる街に\nいきなり軍隊がやってきて\n略奪をしてきた。\n\n私も家族から引き離され\n研究所に連れて行かれた。\n\nこれからどうなるのか\n分からないが良いことは\n起こりそうにない、\nなにか起きる前に逃げ出そう。";
    return resultText;
  }
}
