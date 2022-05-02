import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class MySprite extends SpriteAnimationComponent with HasGameRef {
  // 画像パス
  String imagePath = "";
  // モーションの切り替えタイミング
  double animationSpeed = 0.15;
  // 1フレームのスプライトサイズ
  Vector2 spritSize = Vector2(32.0, 32.0);
  // スプライト本体
  SpriteSheet? playerSprite = null;
  // 下向きモーション（画像差分）
  SpriteAnimation? downSpriteAnimation = null;
  // 左向きモーション（画像差分）
  SpriteAnimation? leftSpriteAnimation = null;
  // 右向きモーション（画像差分）
  SpriteAnimation? rightSpriteAnimation = null;
  // 上向きモーション（画像差分）
  SpriteAnimation? upSpriteAnimation = null;

  /// コンストラクタ
  /// [imagePath] 表示したい画像パスを入力
  MySprite(this.imagePath, this.spritSize, {this.animationSpeed = 0.15});

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    // スプライト画像の読み込み
    playerSprite = SpriteSheet(
      image: await gameRef.images.load(imagePath),
      srcSize: spritSize,
    );
    // 下向きモーション
    downSpriteAnimation =
        playerSprite!.createAnimation(row: 0, stepTime: animationSpeed, to: 3);
    // 左向きモーション
    leftSpriteAnimation =
        playerSprite!.createAnimation(row: 1, stepTime: animationSpeed, to: 3);
    // 右向きモーション
    rightSpriteAnimation =
        playerSprite!.createAnimation(row: 2, stepTime: animationSpeed, to: 3);
    // 上向きモーション
    upSpriteAnimation =
        playerSprite!.createAnimation(row: 3, stepTime: animationSpeed, to: 3);

    animation = upSpriteAnimation;
    size = spritSize;

    print("Load Image : " + imagePath);
    await super.onLoad();
  }

  /// 更新処理
  @override
  void update(double dt) {
    super.update(dt);
  }

  /// 座標を変更する
  /// [pos] Vector2型の座標
  void GetPos(Vector2 pos) {
    position = pos;
  }

  /// 移動させる
  /// [verocity] 移動向き
  void SetMove(Vector2 verocity) {
    position += verocity;

    if (verocity.x.abs() > verocity.y.abs()) {
      if (verocity.x > 0.0) {
        // 右に進んでいる
        animation = rightSpriteAnimation;
      } else if (verocity.x < 0.0) {
        // 左に進んでいる
        animation = leftSpriteAnimation;
      }
    } else {
      if (verocity.y < 0.0) {
        // 上に進んでいる
        animation = upSpriteAnimation;
      } else if (verocity.y > 0.0) {
        // 下に進んでいる
        animation = downSpriteAnimation;
      }
    }
  }
}
