import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:game_at_flutter/game_main_page.dart';

import 'common_system.dart';
import 'my_character_sprite_animation.dart';

/// ドアの管理
class MyMapDoor extends SpriteComponent with HasGameRef, CollisionCallbacks {
  // 画像パス
  String imagePath = "";
  // スプライトの表示開始位置
  Vector2 imagePos = Vector2.zero();
  // スプライトサイズ
  Vector2 spritSize = Vector2(32.0, 32.0);
  // ドアの判定を入れるオブジェクト
  MyGameMain? myGameMain;
  // 当たり判定を入れているオブジェクト
  List<PositionComponent?> positionComponent = [];
  // 当たり判定
  List<RectangleHitbox?> _hitBoxList = [];
  // 鍵解除の処理
  KeyOpenProcessing? keyOpenProcessing = null;
  // 座標
  Vector2 _pos = Vector2.zero();

  /// 鍵番号
  int keyIndex = -1;
  // ドアを開けたかどうか
  bool _isOpen = false;

  /// コンストラクタ
  /// [imagePath] 表示したい画像名
  /// [imagePos] 画像の開始位置
  /// [_pos] 配置位置
  /// [myGameMain] ドアの判定入れるオブジェクト
  /// [spritSize] スプライトのサイズ
  /// [keyIndex] 鍵番号
  MyMapDoor(
    this.imagePath,
    this.imagePos,
    this._pos,
    this.myGameMain,
    this.spritSize,
    this.keyIndex,
  );

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    // 画像の設定
    sprite =
        await Sprite.load(imagePath, srcPosition: imagePos, srcSize: spritSize);
    size = spritSize;
    position = _pos;

    _hitBoxList.clear();
    positionComponent.clear();

    Vector2 sub = spritSize / 32.0;
    for (int x = 0; x < sub.x.toInt(); x++) {
      for (int y = 0; y < sub.y.toInt(); y++) {
        PositionComponent pComponent = new PositionComponent(
          position: _pos + Vector2(32.0 * x.toDouble(), 32.0 * y.toDouble()),
          size: Vector2(32.0, 32.0),
        );
        // 当たり判定を設定
        RectangleHitbox hitBox = RectangleHitbox(
          position: Vector2.zero(),
          size: Vector2(32.0, 32.0),
        );
        if (CommonSystem.isShowDoorHitBox == true) {
          hitBox.renderShape = true;
          hitBox.paint = BasicPalette.green.withAlpha(100).paint();
        }
        await pComponent.add(hitBox);
        await myGameMain!.add(pComponent);
        _hitBoxList.add(hitBox);
        positionComponent.add(pComponent);
      }
    }

    // 会議解除用の当たり判定
    keyOpenProcessing = new KeyOpenProcessing(spritSize);
    await add(keyOpenProcessing!);

    _isOpen = false;
    await super.onLoad();
  }

  /// 座標を変更する
  /// [pos] Vector2型の座標
  void GetPos(Vector2 pos) {
    position = pos;
    positionComponent.forEach((element) {
      element!.position = pos;
    });
  }

  /// ドアを開く
  /// [keyIndexList] 所持している鍵番号リスト
  bool SetDoorOpen(List<int> keyIndexList) {
    if (_isOpen == true) {
      // すでに開けている
      return false;
    }

    // 触れていない
    if (keyOpenProcessing == null || keyOpenProcessing!._isPlayerHit == false) {
      return false;
    }

    int index = keyIndexList.indexWhere((element) => element == keyIndex);

    // 鍵を持っている場合は変化させる
    if (index > -1) {
      for (RectangleHitbox? box in _hitBoxList) {
        box!.size = Vector2.zero();
      }
      sprite!.srcSize = Vector2(0, spritSize.y);
      _isOpen = true;
      return true;
    }
    return false;
  }

  /// ドアを閉じる
  /// [keyIndexList] 所持している鍵番号リスト
  bool SetDoorClose(List<int> keyIndexList) {
    if (_isOpen == false) {
      return false;
    }
    // 触れていない
    if (keyOpenProcessing == null || keyOpenProcessing!._isPlayerHit == false) {
      return false;
    }

    int index = keyIndexList.indexWhere((element) => element == keyIndex);

    // 鍵を持っている場合は変化させる
    if (index > -1) {
      for (RectangleHitbox? box in _hitBoxList) {
        box!.size = Vector2(32.0, 32.0);
      }
      sprite!.srcSize = spritSize;
      _isOpen = false;
      return true;
    }
    return false;
  }
}

/// 鍵解除用の判定
class KeyOpenProcessing extends PositionComponent
    with HasGameRef, CollisionCallbacks {
  // スプライトサイズ
  Vector2 spritSize = Vector2(32.0, 32.0);
  // 鍵の解除範囲判定
  RectangleHitbox? _openHitBox = null;
  // 当たり判定種類
  SpriteType spriteType = SpriteType.Door;

  /// コンストラクタ
  /// [spritSize] スプライトのサイズ
  KeyOpenProcessing(
    this.spritSize,
  );

  // プレイヤーが触れているかどうか
  bool _isPlayerHit = false;

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    // 解除用の当たり判定
    _openHitBox = RectangleHitbox(
      position: -(spritSize * 0.2) / 2.0,
      size: spritSize * 1.2,
    );
    if (CommonSystem.isShowDoorOpenHitBox == true) {
      _openHitBox!.renderShape = true;
      _openHitBox!.paint = BasicPalette.red.withAlpha(100).paint();
    }
    await add(_openHitBox!);

    _isPlayerHit = false;
    spriteType = SpriteType.Door;
    await super.onLoad();
  }

  /// 当たり判定開始コールバック
  /// [intersectionPoints] 接触箇所
  /// [other] 衝突した相手のオブジェクト
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // プレイヤーのみ判定する
    if (other is MyCharacterSpriteAnimation) {
      if (other.spriteType == SpriteType.Player) {
        _isPlayerHit = true;
        print("開閉できるようになった");
        return;
      }
    }
  }

  /// 当たり判定終了コールバック
  /// [other] 衝突した相手のオブジェクト
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // プレイヤーのみ判定する
    if (other is MyCharacterSpriteAnimation) {
      if (other.spriteType == SpriteType.Player) {
        _isPlayerHit = false;
        print("開閉できなくなった");
        return;
      }
    }
  }
}
