import 'package:flutter/material.dart';

import 'main.dart';
import 'game_main_page.dart';

/// リザルトページ
class ResultPage extends StatefulWidget {
  // ゲームの残り時間
  double gameTime = 0;
  // ゲームクリアしたかどうか
  bool gameClear = false;

  // コンストラクタ
  ResultPage(this.gameTime, this.gameClear, {Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

/// 動的ページ
class _ResultPageState extends State<ResultPage> {
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
                    top: 50,
                    right: 50,
                    left: 50,
                  ),
                  child: Image.asset(
                    "assets/images/result.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 80,
                    right: 20,
                    left: 20,
                  ),
                  child: Image.asset(
                    widget.gameClear == true
                        ? "assets/images/gameclear.png"
                        : "assets/images/gameover.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 2,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    widget.gameClear == true ? "ゲームクリア" : "ゲームオーバー",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: 30,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "■ゲーム評価",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  child: Text(
                    "残り時間 : " + widget.gameTime.toStringAsFixed(0),
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: 40,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "■ランク評価",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Text(
                    "ランク : " + SetLank(),
                    style: TextStyle(fontSize: 45, color: Colors.white),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                      onPrimary: Colors.grey,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      // ゲームページに遷移する
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return GameMainPage();
                      }));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 5, bottom: 5, right: 50, left: 50),
                      child: Text(
                        "リプレイ",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                ),
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
                      // タイトルページに遷移する
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyTitlePage();
                      }));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 5, bottom: 5, right: 50, left: 50),
                      child: Text(
                        "タイトルに戻る",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ランクの設定
  String SetLank() {
    if (widget.gameClear == false) {
      // ゲームオーバーになっている
      return "評価無し";
    }

    if (widget.gameTime > 150.0) {
      // 30以内にCLEAR
      return "SS";
    }
    if (widget.gameTime > 120.0) {
      // 1分以内にCLEAR
      return "A";
    }
    if (widget.gameTime > 90.0) {
      // 1分30秒以内にCLEAR
      return "B";
    }
    if (widget.gameTime > 60.0) {
      // 2分以内にCLEAR
      return "C";
    }
    if (widget.gameTime > 30.0) {
      // 2分30秒以内にCLEAR
      return "D";
    }
    if (widget.gameTime > 0.0) {
      // ３分以内にCLEAR
      return "E";
    }

    // ここには来ないはず
    return "バグ";
  }
}
