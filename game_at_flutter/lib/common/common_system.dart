import 'dart:ffi';

/// 共通で管理する変数とか
class CommonSystem {
  // デバッグモード
  static bool isDebugMode = false;
  // マップの当たり判定表示
  static bool isShowMapHitBox = false;
  // キャラの当たり判定表示
  static bool isShowCharterHitBox = false;
  // 敵の目線表示
  static bool isShowEnemyFieldOfView = false;
  // ドアの当たり判定
  static bool isShowDoorHitBox = false;
  // ドアの解除判定
  static bool isShowDoorOpenHitBox = false;
}
