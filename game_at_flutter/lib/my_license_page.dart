import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

/// ライセンス表示
class MyLicensePage extends StatefulWidget {
  // コンストラクタ
  MyLicensePage({Key? key}) : super(key: key);

  @override
  State<MyLicensePage> createState() => _MyLicensePageState();
}

/// 動的ページ
class _MyLicensePageState extends State<MyLicensePage> {
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 40,
                    bottom: 10,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "ライセンス",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "このゲームは以下の素材を使用しております。",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // テキスト表示
                Container(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: TextButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "■ ゲームエンジン FLAME :\n https://flame-engine.org/",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("https://flame-engine.org/"),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "■ タイトルアイコン素材 ICOOON MONO :\n https://icooon-mono.com/",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("https://icooon-mono.com/"),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "■ キャラクター素材 ひぽや倉庫 :\n https://pipoya.net/sozai/",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("https://pipoya.net/sozai/"),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "■ マップチップ素材 ひぽや倉庫 :\n https://pipoya.net/sozai/",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("https://pipoya.net/sozai/"),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "■ マップオブジェクトドット BOUGAINVILLEA :\n http://bougainvillea.egoism.jp",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("http://bougainvillea.egoism.jp"),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "■ UIウインドウ画像 びたちー素材館 :\n http://www.vita-chi.net/sozai1.htm",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("http://www.vita-chi.net/sozai1.htm"),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  width: double.infinity,
                  child: TextButton(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "■ ボタン画像 空想曲線 :\n https://kopacurve.blog.fc2.com/",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse("https://kopacurve.blog.fc2.com/"),
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ),
                // 次のページ表示
                Container(
                  margin: EdgeInsets.only(
                    top: 50,
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
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 5, bottom: 5, right: 50, left: 50),
                      child: Text(
                        "戻る",
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
}
