import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  // 全画面広告
  InterstitialAd? _interstitialAd = null;
  // 全画面広告の読み込みカウント
  int _adLoadCount = 0;
  // 読み込み街
  StreamController _isAdLoadWaiteStream = StreamController();

  /// 広告の作成
  void SetCreateAD() {
    String adUnitId = "";
    if (Theme.of(context).platform == TargetPlatform.android) {
      // Androidで実行
      adUnitId = "ca-app-pub-3940256099942544/1033173712";
    }
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOSで実行
      adUnitId = "ca-app-pub-3940256099942544/1033173712";
    }

    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        // 正常に読み込まれたときに処理される
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          print("全画面広告の読み込み完了");
          _interstitialAd = ad;
          _adLoadCount = 0;
          _isAdLoadWaiteStream.add(true);
        }, onAdFailedToLoad: (LoadAdError error) async {
          print("全画面広告の読み込み失敗");
          _interstitialAd = null;
          _adLoadCount++;
          // 3回まで失敗してもロードし直す
          if (_adLoadCount <= 2) {
            // 失態したので読み込みし直す
            SetCreateAD();
          } else {
            // 3回以上読み込んで失敗したので、読み込み完了として先の処理をする
            _isAdLoadWaiteStream.add(true);
          }
        }));
  }

  /// 広告の表示
  /// [afterProcessing] 広告再生後に実行する処理
  Future<void> SetShowAD(Function afterProcessing) async {
    if (_interstitialAd == null) {
      // 広告を読み込んでいないので終了
      return;
    }
    // 全画面広告を表示している時
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("全画面広告を表示している");
    },
        // 全画面広告を破棄した時
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("全画面広告を破棄した");
      _interstitialAd?.dispose();

      // タイトルページに遷移する
      afterProcessing();
    },
        // 全画面広告がエラーとなった
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print("全画面広告がエラーとなった:" + error.toString());
      _interstitialAd?.dispose();

      // タイトルページに遷移する
      afterProcessing();
    });

    // 全画面広告を再生する
    await _interstitialAd!.show();
  }

  /// 初期時に呼ばれる
  @override
  void initState() {
    super.initState();
    // 広告を作成
    _isAdLoadWaiteStream.add(false);
    // initStateにTheme.of(context).が動かないので、非同期化処理にして処理を後に回す
    Future(() {
      SetCreateAD();
    });
  }

  /// 画面の破棄処理
  @override
  void dispose() {
    super.dispose();
    // 広告も破棄する
    _interstitialAd?.dispose();
  }

  // 画面作成
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: StreamBuilder(
            stream: _isAdLoadWaiteStream.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData == true && snapshot.data == true) {
                // 広告の読み込みに成功した
                return Column(
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
                              // 広告を再生する
                              await SetShowAD(() async {
                                // ゲームページに遷移する
                                await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return GameMainPage();
                                }));
                              });
                              // 広告を表示している時、ローディング画面にする
                              _isAdLoadWaiteStream.add(false);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 5, right: 50, left: 50),
                              child: Text(
                                "リプレイ",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
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
                              // 広告を再生する
                              await SetShowAD(() async {
                                // タイトルページに遷移する
                                await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return MyTitlePage();
                                }));
                              });
                              // 広告を表示している時、ローディング画面にする
                              _isAdLoadWaiteStream.add(false);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 5, right: 50, left: 50),
                              child: Text(
                                "タイトルに戻る",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              // 広告の読み込み中
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
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
