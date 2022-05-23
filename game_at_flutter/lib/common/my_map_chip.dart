import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';

import '../game_main_page.dart';

/// マップチップを表示する
class MyMapChip extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  // マップチップデータ
  String mapPath = "";
  // 画像パス
  String imagePath = "";
  // 当たり判定用のレイヤーを指定する
  String hitLayerName = "";
  // 1フレームのスプライトサイズ
  Vector2 spritSize = Vector2(32.0, 32.0);
  // マップタイル
  TiledComponent? _mapTiled = null;
  // 追加するメインクラス
  MyGameMain myGameMain;

  /// コンストラクタ
  /// [myGameMain] 追加するメインクラス
  /// [mapPath] マップチップのデータ
  /// [imagePath] 表示したい画像パスを入力
  /// [spritSize] 1タイルの表示サイズ
  /// [hitLayer] 当たり判定用のレイヤー名
  MyMapChip(this.myGameMain, this.mapPath, this.imagePath, this.spritSize,
      {this.hitLayerName = ""});

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    _mapTiled = await TiledComponent.load(mapPath, spritSize);
    add(_mapTiled!);

    // マップチップの情報から当たり判定を作る
    if (hitLayerName == "") {
      return;
    }
    TileLayer? hitLayer = _mapTiled!.tileMap.getLayer(hitLayerName);
    int line = 0;
    int column = 0;
    hitLayer!.tileData!.forEach((element) {
      element.forEach((childElement) {
        if (childElement.tile > 10 && childElement.tile != 291) {
          // 通れる地面以外の場合当たり判定を置く
          PositionComponent hitSprite = new PositionComponent(
            position: Vector2(spritSize.x * column, spritSize.y * line),
            size: spritSize,
          );
          RectangleHitbox rectangleHitbox = RectangleHitbox(
            position: Vector2.zero(),
            size: spritSize,
          );
          hitSprite.add(rectangleHitbox);
          myGameMain.add(hitSprite);
          rectangleHitbox.renderShape = true;
          rectangleHitbox.paint = BasicPalette.red.withAlpha(100).paint();
        }
        column++;
      });
      column = 0;
      line++;
    });
  }
}
