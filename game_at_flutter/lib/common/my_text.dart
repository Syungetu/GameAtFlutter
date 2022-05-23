import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

/// テキスト表示
class MyText extends TextBoxComponent with HasGameRef {
  // コンストラクタ
  MyText(TextBoxConfig boxConfig) : super(boxConfig: boxConfig);

  /// 更新処理
  @override
  void update(double dt) {
    super.update(dt);
  }

  /// テキスト表示
  /// [drawText] 表示テキスト
  /// [drawColor] 色
  /// [drawSize] フォントサイズ
  void SetText(String drawText, Color drawColor, double drawSize) {
    text = drawText;
    TextPaint tP = TextPaint(
      style: TextStyle(
        fontSize: drawSize,
        color: drawColor,
        overflow: TextOverflow.clip,
      ),
    );
    textRenderer = tP;
  }

  /// 座標を変更する
  /// [pos] Vector2型の座標
  void GetPos(Vector2 pos) {
    position = pos;
  }
}
