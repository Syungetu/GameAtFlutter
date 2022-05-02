import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import 'package:flutter/material.dart';

/// ジョイスティック操作管理
class MyJoystickController extends JoystickComponent {
  /// コンストラクタ
  /// [knobRadius] スティックの大きさ
  /// [knobPaint] スティックの色
  /// [backgroundRadius] スティック背景の大きさ
  /// [backgroundPaint] スティック背景の色
  /// [margin] 画面端からのマージン
  MyJoystickController(
      {double knobRadius = 30.0,
      Paint? knobPaint,
      double backgroundRadius = 100.0,
      Paint? backgroundPaint,
      EdgeInsets? margin})
      : super(
          background:
              CircleComponent(radius: backgroundRadius, paint: backgroundPaint),
          knob: CircleComponent(radius: knobRadius, paint: knobPaint),
          margin: margin,
        );
}
