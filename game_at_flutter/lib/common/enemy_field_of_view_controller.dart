import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';
import 'package:game_at_flutter/game_main_page.dart';

import 'common_system.dart';
import 'my_character_sprite_animation.dart';

/// 敵の視野処理
class EnemyFieldOfViewController extends PositionComponent
    with CollisionCallbacks {
  // 視野判定元のコンポーネント
  PositionComponent? mainComponent = null;
  // 判定先のコンポーネント（プレイヤー）
  PositionComponent? targetComponent = null;
  // 視野距離
  double viewingDistance = 300.0;
  // 1フレーム前の座標を取得
  Vector2 _buffPos = Vector2.zero();
  // 当たり判定
  RectangleHitbox? _hitbox = null;
  // 見つかった時の処理
  Function? Sethitprocessing = null;
  // 実行するかどうか
  bool isPlay = false;

  // マップとの当たり判定の距離
  double _hitMapChipDis = double.infinity;

  /// コンストラクタ
  EnemyFieldOfViewController(
      this.mainComponent, this.targetComponent, this.Sethitprocessing,
      {this.viewingDistance = 300.0})
      : super();

  /// 読み込み処理
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    position = mainComponent!.position + (mainComponent!.size / 2.0);
    size = mainComponent!.size;
    anchor = Anchor.center;
    angle = 0.0;

    _hitbox = new RectangleHitbox(
      position: (mainComponent!.size / 2.0),
      size: Vector2(1.0, viewingDistance),
      anchor: Anchor.bottomCenter,
      angle: 0,
    );
    if (CommonSystem.isShowEnemyFieldOfView == true) {
      // 当たり判定のデバッグ表示
      _hitbox!.renderShape = true;
      _hitbox!.paint = BasicPalette.red.withAlpha(100).paint();
    }
    await add(_hitbox!);

    _hitMapChipDis = double.infinity;
  }

  /// 更新処理
  @override
  void update(double dt) {
    super.update(dt);

    // 処理しない
    if (isPlay == false) {
      return;
    }
    // 座標を更新する
    position = mainComponent!.position + (mainComponent!.size / 2.0);
    // プレイヤーとの角度を計算する
    Vector2 sub = mainComponent!.position - targetComponent!.position;
    double rot = math.atan2(sub.y, sub.x);
    // プレイヤーまでの距離を計算する
    sub = targetComponent!.position - mainComponent!.position;
    double playerDis = math.sqrt(sub.x * sub.x + sub.y * sub.y);
    // プレイヤーに向けて判定を伸ばす
    //size = new Vector2(1.0, viewingDistance);
    angle = rot - (math.pi / 2.0);

    // プレイヤーの向きと敵の向きを比較して前方のみの判定にする
    bool isFieldOfView = false;
    Vector2 subPos = position - _buffPos;
    // 角度に変換する
    double degree = (rot - (math.pi / 2.0)) * (180.0 / math.pi) % 360.0;
    if (subPos.x.abs() > subPos.y.abs()) {
      // 左右方向の移動
      if (subPos.x > 0.0) {
        // 右方向
        // 45~135
        if (degree >= 45.0 && degree <= 135.0) {
          isFieldOfView = true;
        }
      } else {
        // 左方向
        // 225~315
        if (degree >= 225.0 && degree <= 315.0) {
          isFieldOfView = true;
        }
      }
    } else {
      // 前後方向の移動
      if (subPos.y > 0.0) {
        // 下方向
        // 135~225
        if (degree > 135.0 && degree < 225.0) {
          isFieldOfView = true;
        }
      } else {
        // 上方向
        // 315~360 & 0~45
        if ((degree > 315.0 && degree <= 360.0) ||
            (degree >= 0.0 && degree < 45.0)) {
          isFieldOfView = true;
        }
      }
    }

    // 向きに合わせた視覚に入っているかどうか
    if (isFieldOfView == true) {
      // 視線の距離を制限する
      if (playerDis < viewingDistance) {
        // 壁とプレイヤーどちらが近いか
        if (_hitMapChipDis > playerDis) {
          // 壁よりもプレイヤーの方が近い
          // = 見える範囲にプレイヤーが居る
          if (Sethitprocessing != null) {
            Sethitprocessing!();
          }
          print("見つかった : playerDis:" +
              playerDis.toStringAsFixed(2) +
              " mapDis:" +
              _hitMapChipDis.toStringAsFixed(2));
        }
      }
    }
    //　当たり判定までの距離を初期化する
    _hitMapChipDis = double.infinity;

    _buffPos = new Vector2(position.x, position.y);
  }

  /// 座標を変更する
  /// [pos] Vector2型の座標
  void GetPos(Vector2 pos) {
    position = pos;
  }

  /// 当たり判定コールバック
  /// [intersectionPoints] 接触箇所
  /// [other] 衝突した相手のオブジェクト
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // 処理しない
    if (isPlay == false) {
      return;
    }

    // プレイヤーはここでは判定しない
    if (other is MyCharacterSpriteAnimation) {
      if (other.spriteType == SpriteType.Player ||
          other.spriteType == SpriteType.Enemy) {
        return;
      }
    }

    // マップの当たり判定を取得
    Vector2 sub = mainComponent!.position - other.position;
    double dis = math.sqrt(sub.x * sub.x + sub.y * sub.y);
    if (_hitMapChipDis > dis) {
      // プレイヤーと敵の間により近い位置に壁があった
      _hitMapChipDis = dis;
    }
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
}
