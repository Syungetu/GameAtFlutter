import 'dart:math' as math;

import 'package:flame/game.dart';

/// 鍵管理
class KeyController {
  // 鍵番号
  int keyIndex = -1;
  // 検索範囲
  double searchRange = 36.0;
  // 鍵の位置
  Vector2 keyPos = Vector2.zero();

  // コンストラクタ
  KeyController(this.keyIndex, this.keyPos);

  // 鍵を見つける処理
  int GetKey(Vector2 playerPos) {
    int found = -1;

    // 鍵とプレイヤーの距離
    Vector2 sub = playerPos - keyPos;
    double playerDis = math.sqrt(sub.x * sub.x + sub.y * sub.y);

    if (playerDis <= searchRange) {
      // 鍵を見つけた
      print("鍵：" + keyIndex.toString() + " をみつけた");
      found = keyIndex;
    }

    return found;
  }
}
