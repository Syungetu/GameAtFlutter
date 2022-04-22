import 'package:flame/components.dart';

import 'package:flutter/material.dart';

/// ジョイスティック操作管理
class MyJoystickController extends JoystickComponent {
  /// コンストラクタ
  /// [knobPaint] スティックの色
  /// [backgroundPaint] スティック背景の色
  MyJoystickController(Paint knobPaint, Paint backgroundPaint)
      : super(
          background: CircleComponent(radius: 100, paint: backgroundPaint),
          knob: CircleComponent(radius: 30, paint: knobPaint),
          margin: const EdgeInsets.only(left: 40.0, bottom: 40.0),
        );
}
