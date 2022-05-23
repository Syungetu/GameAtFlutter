import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';

import 'common/my_sprite.dart';
import 'common/my_joystick_controller.dart';
import 'common/my_text.dart';
import 'common/my_map_chip.dart';

/// ゲームメイン
class GameMainPage extends StatefulWidget {
  GameMainPage({Key? key}) : super(key: key);

  @override
  State<GameMainPage> createState() => _GameMainPageState();
}

class _GameMainPageState extends State<GameMainPage> {
  final MyGameMain myGameMain = MyGameMain();
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: myGameMain,
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Flameを使ったゲーム駆動
class MyGameMain extends FlameGame
    with DoubleTapDetector, HasTappables, HasDraggables, HasCollisionDetection {
  double x_pos = 0.0;
  double x_count = 0.0;
  double velocity = 5.0;

  // プレイヤースプライト
  MySprite? playerSprite = null;
  // プレイヤースプライト
  MySprite? otherSprite = null;
  // デバッグ用テキスト
  MyText? debugText = null;
  // マップチップ
  MyMapChip? mapChip = null;
  // ジョイスティック
  MyJoystickController? myJoystickController = null;

  MyGameMain() : super();

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    // マップチップ
    mapChip = new MyMapChip(
      this,
      "maptmx.tmx",
      "BaseChip_pipo.png",
      Vector2(32.0, 32.0),
      hitLayerName: "grund",
    );
    add(mapChip!);

    // プレイヤーオブジェクト
    playerSprite = new MySprite("character/player.png", Vector2(32.0, 32.0));
    add(playerSprite!);
    playerSprite!.GetPos(Vector2(469, 469));

    otherSprite = new MySprite("character/enemy.png", Vector2(32.0, 32.0));
    add(otherSprite!);
    otherSprite!.GetPos(Vector2(500, 600));

    debugText = new MyText(new TextBoxConfig(
      maxWidth: 1080,
    ));
    debugText!.SetText("test", Colors.white, 24.0);
    add(debugText!);

    // ジョイスティック操作
    myJoystickController = new MyJoystickController(
        knobRadius: 30.0,
        knobPaint: BasicPalette.white.withAlpha(200).paint(),
        backgroundRadius: 100.0,
        backgroundPaint: BasicPalette.white.withAlpha(100).paint(),
        margin: EdgeInsets.only(left: 40.0, bottom: 40.0));
    add(myJoystickController!);

    await super.onLoad();
  }

/*
  /// 描画処理
  /// [canvas] キャンバスオブジェクト
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // テスト表示
    canvas.drawRect(size.toRect(), BasicPalette.white.paint()); // 全体表示
    canvas.drawRect(Rect.fromLTWH(x_pos, 50, 50, 50),
        BasicPalette.green.paint()); // 座標と大きさ指定表示
  }
*/
  /// 更新処理
  @override
  void update(double dt) {
    super.update(dt);
    if (myJoystickController!.delta.isZero() != true) {
      // スティックが倒されている
      playerSprite!.SetMove((myJoystickController!.GetValue() * 10.0));
    }

    String tt = "FPS:" + (6.0 / dt).toStringAsFixed(2) + "\n";
    tt += "Player " + myJoystickController!.GetValue().toString() + "\n";
    tt += "Enemy " + otherSprite!.GetDebugText() + "\n";
    debugText!.SetText(tt, Colors.white, 21.0);

    // カメラ設定
    camera.followComponent(playerSprite!);
  }
}
