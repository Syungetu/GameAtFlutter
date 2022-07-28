import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';

import 'common_system.dart';
import 'enemy_field_of_view_controller.dart';
import 'my_map_door.dart';
import 'my_character_sprite_animation.dart';

/// アニメーション付きのスプライト表示
class MySpriteAnimation extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  // 画像パス
  String imagePath = "";
  // モーションの切り替えタイミング
  double animationSpeed = 0.15;
  // 1フレームのスプライトサイズ
  Vector2 spritSize = Vector2(32.0, 32.0);
  // スプライト本体
  SpriteSheet? playerSprite = null;
  // モーション（画像差分）
  SpriteAnimation? spriteAnimation = null;
  // 当たり判定を使うかどうか
  bool isUseHitBox = false;
  // 当たり判定
  late RectangleHitbox hitBox;
  // 移動速度
  Vector2 verocity = Vector2.zero();
  // 何かにあたっているかどうか
  bool isCollisionHit = false;
  // 前フレームの座標バッファ
  Vector2 buffPosition = Vector2.zero();
  // 適応させる座標系
  PositionType posType = PositionType.game;
  // オブジェクト種類
  SpriteType spriteType = SpriteType.Other;

  // デバッグ用テキスト
  String debugText = "";

  /// コンストラクタ
  /// [imagePath] 表示したい画像パスを入力
  MySpriteAnimation(this.imagePath, this.spritSize, this.spriteType,
      {this.animationSpeed = 0.15,
      this.posType = PositionType.game,
      this.isUseHitBox = false});

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    // スプライト画像の読み込み
    playerSprite = SpriteSheet(
      image: await gameRef.images.load(imagePath),
      srcSize: spritSize,
    );
    // モーション
    spriteAnimation =
        playerSprite!.createAnimation(row: 0, stepTime: animationSpeed, to: 3);

    animation = spriteAnimation;
    size = spritSize;

    if (isUseHitBox == true) {
      // 当たり判定を設定
      hitBox = RectangleHitbox(
        position: Vector2.zero(),
        size: spritSize,
      );
      if (CommonSystem.isShowCharterHitBox == true) {
        hitBox.renderShape = true;
        hitBox.paint = BasicPalette.green.withAlpha(100).paint();
      }
      await add(hitBox);
    }

    buffPosition = Vector2.zero();

    positionType = posType;

    print("Load Image : " + imagePath);
    await super.onLoad();
  }

  /// 更新処理
  @override
  void update(double dt) {
    super.update(dt);
  }

  // 削除されたときに処理される
  @override
  void onRemove() {
    super.onRemove();
    this.removeFromParent();
  }

  /// 座標を変更する
  /// [pos] Vector2型の座標
  void GetPos(Vector2 pos) {
    position = pos;
  }

  /// 座標を取得する
  /// [return] Vector2型の座標
  Vector2 SetPos() {
    return position;
  }

  /// デバッグ用にテキストを返す
  String GetDebugText() {
    return debugText;
  }
}
