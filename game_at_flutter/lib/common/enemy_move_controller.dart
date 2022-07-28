import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flame/components.dart';

import 'my_character_sprite_animation.dart';

/// 敵の動きを管理する
class EnemyMoveController {
  // 道順配列
  List<Vector2> directions = [];
  // 現在進んでいる道順番号
  int directionsIndex = 0;
  // 移動速度
  double velocity = 0.5;

  // 移動させるスプライト
  MyCharacterSpriteAnimation? moveSprite = null;
  // プレイヤースプライト
  MyCharacterSpriteAnimation? playerSprite = null;

  /// コンストラクタ
  /// [moveSprite] 　移動させるスプライト
  /// [playerSprite] プレイヤースプライト
  /// [directions] 　道順配列
  /// [directionsIndex] 巡回の開始位置
  /// [velocity] 移動速度
  EnemyMoveController(this.moveSprite, this.playerSprite, this.directions,
      {this.directionsIndex = 0, this.velocity = 0.5});

  // 移動処理
  void SetMove() {
    // 現在の目的地座標
    Vector2 nowRoute = directions[directionsIndex];
    // 目的地とスプライトの距離を求める
    double dis = math.sqrt((moveSprite!.SetPos().x - nowRoute.x) *
            (moveSprite!.SetPos().x - nowRoute.x) +
        (moveSprite!.SetPos().y - nowRoute.y) *
            (moveSprite!.SetPos().y - nowRoute.y));

    // 距離が近ければ次の目的地に変更する
    if (dis < 1.0) {
      directionsIndex++;
      if (directionsIndex >= directions.length) {
        // リストを超えていた場合は０に戻す
        directionsIndex = 0;
      }
    }

    // 新しい目的地に変更する
    nowRoute = directions[directionsIndex];
    dis = math.sqrt((moveSprite!.SetPos().x - nowRoute.x) *
            (moveSprite!.SetPos().x - nowRoute.x) +
        (moveSprite!.SetPos().y - nowRoute.y) *
            (moveSprite!.SetPos().y - nowRoute.y));

    //移動する
    Vector2 spriteVelocity = Vector2.zero();
    Vector2 buffNextPos = moveSprite!.SetPos();
    //２点間の角度を取得
    double rot = math.atan2(moveSprite!.SetPos().y - nowRoute.y,
        moveSprite!.SetPos().x - nowRoute.x);
    if (dis > velocity) {
      spriteVelocity.x = -velocity * math.cos(rot);
      spriteVelocity.y = -velocity * math.sin(rot);
    } else {
      // 近い場合は速度調整
      spriteVelocity.x = -dis * math.cos(rot);
      spriteVelocity.y = -dis * math.sin(rot);
    }
    // 実際に移動させる
    moveSprite!.SetMove(spriteVelocity);
  }
}
