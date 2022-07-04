import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';

import '../game_main_page.dart';

/// マップチップを表示する
class MyMapChip extends Component with HasGameRef, CollisionCallbacks {
  // マップチップデータ
  String mapPath = "";
  // 当たり判定用のレイヤーを指定する
  String hitLayerName = "";
  // 1フレームのスプライトサイズ
  Vector2 spritSize = Vector2(32.0, 32.0);
  // マップタイル
  TiledComponent? _mapTiled = null;
  // 追加するメインクラス
  MyGameMain myGameMain;
  // 適応させる座標系
  PositionType posType = PositionType.game;

  // 読み込み完了フラグ
  bool _IsLoad = false;

  // 読み込み完了フラグ
  bool GetIsLoad() {
    return _IsLoad;
  }

  /// コンストラクタ
  /// [myGameMain] 追加するメインクラス
  /// [mapPath] マップチップのデータ
  /// [spritSize] 1タイルの表示サイズ
  /// [hitLayer] 当たり判定用のレイヤー名
  /// [posType] 配置する座標系の種類
  MyMapChip(this.myGameMain, this.mapPath, this.spritSize,
      {this.hitLayerName = "", this.posType = PositionType.game});

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    // 読み込みフラグを下ろす
    _IsLoad = false;

    _mapTiled = await TiledComponent.load(mapPath, spritSize);
    await add(_mapTiled!);

    print("Load Map : " + mapPath);
    positionType = posType;

    // マップチップの情報から当たり判定を作る
    if (hitLayerName == "") {
      return;
    }
    TileLayer? hitLayer = _mapTiled!.tileMap.getLayer(hitLayerName);
    int line = 0;
    int column = 0;
    hitLayer!.tileData!.forEach((element) {
      element.forEach((childElement) {
        if (childElement.tile == 33) {
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
          //rectangleHitbox.renderShape = true;
          //rectangleHitbox.paint = BasicPalette.red.withAlpha(100).paint();
        }
        column++;
      });
      column = 0;
      line++;
    });

    // 読み込みフラグを立てる
    _IsLoad = true;

    await super.onLoad();
  }
}
