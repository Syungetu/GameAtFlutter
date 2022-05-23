import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import 'package:flutter/material.dart';

/// ジョイスティック操作管理
class MyJoystickController extends JoystickComponent {
  double backgroundRadius = 100.0;

  /// コンストラクタ
  /// [knobRadius] スティックの大きさ
  /// [knobPaint] スティックの色
  /// [backgroundRadius] スティック背景の大きさ
  /// [backgroundPaint] スティック背景の色
  /// [margin] 画面端からのマージン
  MyJoystickController(
      {double knobRadius = 30.0,
      Paint? knobPaint,
      backgroundRadius = 100.0,
      Paint? backgroundPaint,
      EdgeInsets? margin})
      : super(
          background:
              CircleComponent(radius: backgroundRadius, paint: backgroundPaint),
          knob: CircleComponent(radius: knobRadius, paint: knobPaint),
          margin: margin,
        );

  /// 傾きを0～１の値で出力する
  Vector2 GetValue() {
    Vector2 value = Vector2.zero();
    if (delta.x != 0.0) {
      value.x = delta.x / backgroundRadius;
    }
    if (delta.y != 0.0) {
      value.y = delta.y / backgroundRadius;
    }
    return value;
  }
}
