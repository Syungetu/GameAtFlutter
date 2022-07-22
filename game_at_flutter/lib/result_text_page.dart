import 'package:flutter/material.dart';

import 'result_page.dart';

/// ゲーム終了後のテキストページ
class ResultTextPage extends StatefulWidget {
  // ゲームの残り時間
  double gameTime = 0;
  // ゲームクリアしたかどうか
  bool gameClear = false;

  // コンストラクタ
  ResultTextPage(this.gameTime, this.gameClear, {Key? key}) : super(key: key);

  @override
  State<ResultTextPage> createState() => _ResultTextPageState();
}

/// 動的ページ
class _ResultTextPageState extends State<ResultTextPage> {
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
                  child: Image.asset("assets/images/epilogue.png"),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 2,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "エピローグ",
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
                style: TextStyle(fontSize: 25, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            // 次のページ表示S
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
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return ResultPage(widget.gameTime, widget.gameClear);
                  }));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, right: 50, left: 50),
                  child: Text(
                    "リザルト画面へ",
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
    String resultText = "";

    // ゲームクリアとゲームオーバーでテキストを切り替える
    if (widget.gameClear == true) {
      // ゲームクリア
      resultText =
          "私はこの群の研究所から\n必死の思いで脱出することができた！\n\n後にあの研究所の出来事が\nマスコミに暴露されて、非難を受けて研究所は閉鎖したらしい……\n";
    } else {
      // ゲームオーバー
      resultText =
          "私は脱走に失敗して、\nまた捕まってしまった……\n\nあの後、私は軍の研究の\n実験台にされて、\n段々と知性がなくなっていくの\nを感じながら日々を\n過ごしていったのだった。";
    }

    return resultText;
  }
}
