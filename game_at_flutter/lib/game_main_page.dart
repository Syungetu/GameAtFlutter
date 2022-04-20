import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flame/palette.dart';

/// ゲームメイン
class GameMainPage extends StatefulWidget {
  GameMainPage({Key? key}) : super(key: key);

  @override
  State<GameMainPage> createState() => _GameMainPageState();
}

class _GameMainPageState extends State<GameMainPage> {
  @override
  Widget build(BuildContext context) {
    /*
    return Container(
      child: const Text(
        "メインページ",
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
    */
    return GameWidget(game: MyGameMain());
  }
}

/// Flameを使ったゲーム駆動
class MyGameMain extends FlameGame with DoubleTapDetector, HasTappables {
  double x_pos = 0.0;
  double x_count = 0.0;
  double velocity = 5.0;

  /// 描画処理
  /// [canvas] キャンバスオブジェクト
  @override
  void render(Canvas canvas) {
    // テスト表示
    canvas.drawRect(size.toRect(), BasicPalette.white.paint()); // 全体表示
    canvas.drawRect(Rect.fromLTWH(x_pos, 50, 50, 50),
        BasicPalette.green.paint()); // 座標と大きさ指定表示
  }

  /// 更新処理
  @override
  void update(double dt) {
    super.update(dt);
    x_count += velocity;
    x_pos = 100.0 + (25.0 * math.sin((math.pi / 360.0) * x_count));
    //x_pos += 1.0;
  }
}
