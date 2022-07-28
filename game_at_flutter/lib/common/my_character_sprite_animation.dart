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

/// キャラの種類
enum SpriteType {
  // プレイヤー
  Player,
  // 敵
  Enemy,
  // その他
  Other,
  // ドアの判定
  Door,
}

/// アニメーション付きのスプライト表示
class MyCharacterSpriteAnimation extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
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
  MyCharacterSpriteAnimation(this.imagePath, this.spritSize, this.spriteType,
      {this.animationSpeed = 0.15, this.posType = PositionType.game});

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

    buffPosition = Vector2.zero();

    positionType = posType;

    print("Load Image : " + imagePath);
    await super.onLoad();
  }

  /// 更新処理
  @override
  void update(double dt) {
    super.update(dt);
    // 移動
    if (isCollisionHit == false) {
      position += verocity;
    }
    verocity = Vector2.zero();
    isCollisionHit = false;
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

  /// 移動させる
  /// [verocity] 移動向き
  void SetMove(Vector2 v) {
    verocity = v;

    if (v.x.abs() > v.y.abs()) {
      if (v.x > 0.0) {
        // 右に進んでいる
        animation = rightSpriteAnimation;
      } else if (v.x < 0.0) {
        // 左に進んでいる
        animation = leftSpriteAnimation;
      }
    } else {
      if (v.y < 0.0) {
        // 上に進んでいる
        animation = upSpriteAnimation;
      } else if (v.y > 0.0) {
        // 下に進んでいる
        animation = downSpriteAnimation;
      }
    }
  }

  /// 当たり判定コールバック
  /// [intersectionPoints] 接触箇所
  /// [other] 衝突した相手のオブジェクト
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is EnemyFieldOfViewController) {
      // 視野判定なので処理しない
      return;
    }
    if (other is KeyOpenProcessing) {
      // ドアの開閉用の判定なので処理しない
      return;
    }

    isCollisionHit = false;

    Vector2 dis =
        ((other.position + other.size) - (position + spritSize)).normalized();

    intersectionPoints.forEach((pos) {
      Vector2 overlapDistance = Vector2.zero();
      if (dis.x.abs() < dis.y.abs()) {
        if ((position.y + spritSize.y) > other.position.y &&
            position.y < other.position.y) {
          // 上
          overlapDistance.y = (pos.y - other.position.y);
        } else if (position.y < (other.position.y + other.size.y) &&
            position.y > other.position.y) {
          // 下
          overlapDistance.y = (position.y - pos.y);
        }
      } else if (dis.x.abs() > dis.y.abs()) {
        if ((position.x + spritSize.x) > other.position.x &&
            position.x < other.position.x) {
          // 左
          overlapDistance.x = (pos.x - other.position.x);
        } else if (position.x < (other.position.x + other.size.x) &&
            position.x > other.position.x) {
          // 右
          overlapDistance.x = (position.x - pos.x);
        }
      }
      position -= overlapDistance;
      // print("over:" + overlapDistance.toString());
    });
  }

  /// 当たり判定開始コールバック
  /// [intersectionPoints] 接触箇所
  /// [other] 衝突した相手のオブジェクト
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
  }

  /// 当たり判定終了コールバック
  /// [other] 衝突した相手のオブジェクト
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
  }

  /// デバッグ用にテキストを返す
  String GetDebugText() {
    return debugText;
  }
}
