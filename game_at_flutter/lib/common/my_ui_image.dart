import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

/// スプライトを用意する
class MyUIImage extends SpriteComponent with HasGameRef {
  // 適応させる座標系
  PositionType posType = PositionType.viewport;
  // 画像パス
  String imagePath = "";
  // スプライトサイズ
  Vector2 spritSize = Vector2(32.0, 32.0);

  /// コンストラクタ
  /// [imagePath] 表示したい画像名
  /// [spritSize] スプライトのサイズ
  /// [posType] 表示したい画像の座標先
  MyUIImage(this.imagePath, this.spritSize,
      {this.posType = PositionType.viewport});

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load(imagePath, srcSize: spritSize);
    size = spritSize;
    positionType = posType;

    await super.onLoad();
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

  /// 色を設定する
  /// [col] 色
  void GetColor(Color col) {
    paint.color = col;
  }

  /// サイズを設定する
  void GetSize(Vector2 newSize) {
    size = newSize;
  }
}
