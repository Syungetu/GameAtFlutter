import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';

import 'common/my_sprite_animation.dart';
import 'common/my_joystick_controller.dart';
import 'common/my_text.dart';
import 'common/my_map_chip.dart';
import 'common/my_background_layer.dart';
import 'common/enemy_move_controller.dart';
import 'common/my_ui_image.dart';
import 'common/my_button.dart';
import 'common/enemy_field_of_view_controller.dart';
import 'common/my_map_door.dart';
import 'common/key_controller.dart';

/// ゲームメイン
class GameMainPage extends StatefulWidget {
  GameMainPage({Key? key}) : super(key: key);

  @override
  State<GameMainPage> createState() => _GameMainPageState();
}

Size viewSize = new Size(0, 0);

class _GameMainPageState extends State<GameMainPage> {
  final MyGameMain myGameMain = MyGameMain();
  @override
  Widget build(BuildContext context) {
    viewSize = MediaQuery.of(context).size;
    return GameWidget(
      game: myGameMain,
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Flameを使ったゲーム駆動
class MyGameMain extends FlameGame
    with DoubleTapDetector, HasTappables, HasDraggables, HasCollisionDetection {
  double x_pos = 0.0;
  double x_count = 0.0;
  double velocity = 5.0;

  // プレイヤースプライト
  MySpriteAnimation? playerSprite = null;
  // 敵スプライト
  List<MySpriteAnimation?> otherSprite = [null];
  // 敵の移動処理
  List<EnemyMoveController?> enemyMoveControllerList = [null];
  // 敵の視線処理
  List<EnemyFieldOfViewController?> enemyFieldOfViewControllerList = [null];
  // デバッグ用テキスト
  MyText? debugText = null;
  // マップチップ
  MyMapChip? mapChip = null;
  // ドア処理
  List<MyMapDoor?> mapDoorList = [null];
  // 鍵設置処理
  List<KeyController?> mapKeyList = [null];
  // ジョイスティック
  MyJoystickController? myJoystickController = null;
  // 調べるボタン
  MyButton? searchButton = null;
  // バックグラウンドレイヤー
  MyBackgroundLayer? backgroundLayer = null;
  // 上に表示するUI画像
  MyUIImage? headerUIWindow = null;
  // ui用テキスト
  MyText? uiText = null;
  // メッセージUI画像
  MyUIImage? messageUIWindow = null;
  // メッセージui用テキスト
  MyText? messageUiText = null;
  // ゲームオーバー画像
  MyUIImage? gameOverImage = null;
  // ゲームクリア画像
  MyUIImage? gameClearImage = null;
  // ui用テキスト
  MyText? uiGameEndText = null;
  // ゲーム終了時に表示するボタン
  MyButton? gameEndButton = null;

  // 残りゲーム時間
  double gameCount = 180.0;
  // ゲームの終了かどうか
  bool isGameEnd = false;
  // ゲームクリアしたかどうか
  bool isGameClear = false;
  // ゲーム終了時の表示をしたかどうか
  bool isShowGameEndImage = false;
  // 敵に見つかったかどうか
  bool isEnemyFound = false;

  // 取得した鍵リスト
  List<int> _haveKeyList = [];
  // メッセージ表示時間
  double messageUIShowCount = 0;

  // 敵のルート1
  List<Vector2> EnemyDirections1 = [
    new Vector2(144, 256),
    new Vector2(144, 390),
    new Vector2(43, 390),
    new Vector2(43, 708),
    new Vector2(217, 718),
    new Vector2(218, 640),
    new Vector2(302, 640),
    new Vector2(374, 611),
    new Vector2(474, 650),
    new Vector2(550, 650),
    new Vector2(545, 256),
  ];

  // 敵のルート2
  List<Vector2> EnemyDirections2 = [
    new Vector2(542, 106),
    new Vector2(1017, 106),
    new Vector2(1017, 406),
    new Vector2(525, 406),
  ];

  // 敵のルート3
  List<Vector2> EnemyDirections3 = [
    new Vector2(525, 406),
    new Vector2(525, 714),
    new Vector2(1017, 725),
    new Vector2(1017, 406),
  ];

  // ドア配置
  List<Vector2> DoorPosList = [
    // 独房
    new Vector2(96, 192),
    new Vector2(256, 192),
    new Vector2(416, 192),
    // 小部屋
    new Vector2(352, 292),
    new Vector2(384, 292),
    // 大部屋上
    new Vector2(768, 352),
    new Vector2(800, 352),
    // 大部屋下
    new Vector2(768, 448),
    new Vector2(800, 448),
    // 出口
    new Vector2(1088, 640),
  ];
  // ドアの鍵番号
  List<int> DoorKeyIndexList = [
    // 独房
    1,
    1,
    1,
    // 小部屋
    4,
    4,
    // 大部屋上
    2,
    2,
    // 大部屋下
    3,
    3,
    // 出口
    5,
  ];

  // 鍵の位置
  List<Vector2> KeyPosList = [
    // 独房
    new Vector2(128, 96),
    // 大部屋上
    new Vector2(352, 672),
    // 大部屋下
    new Vector2(704, 224),
    // 小部屋
    new Vector2(928, 608),
    // 出口
    new Vector2(288, 352),
  ];
  // 鍵の番号
  List<int> KeyIndexList = [
    1,
    2,
    3,
    4,
    5,
  ];
  // 鍵の名称
  List<String> KeyNameList = [
    "なし",
    "独房の鍵",
    "ロッカー室の鍵",
    "準備倉庫室の鍵",
    "モニター室の鍵",
    "出口の鍵"
  ];

  /// コンストラクタ
  MyGameMain() : super();

  /// 読み込み処理
  ///
  @override
  Future<void>? onLoad() async {
    // ゲーム設定初期化
    gameCount = 180.0;
    isGameEnd = false;
    isGameClear = false;
    isShowGameEndImage = false;
    isEnemyFound = false;

    // マップチップ
    mapChip = new MyMapChip(
      this,
      "map.tmx",
      Vector2(32.0, 32.0),
      hitLayerName: "yuka",
    );
    await add(mapChip!);
    backgroundLayer = new MyBackgroundLayer(mapChip!);

    // プレイヤーオブジェクト
    playerSprite = new MySpriteAnimation(
        "character/player_01.png", Vector2(32.0, 32.0), SpriteType.Player);
    await add(playerSprite!);
    playerSprite!.GetPos(Vector2(94, 108));

    otherSprite.clear();
    enemyMoveControllerList.clear();
    enemyFieldOfViewControllerList.clear();
    for (int n = 1; n <= 1; n++) {
      MySpriteAnimation childOtherSprite = new MySpriteAnimation(
          "character/enemy_0" + n.toString() + ".png",
          Vector2(32.0, 32.0),
          SpriteType.Enemy);
      await add(childOtherSprite);
      otherSprite.add(childOtherSprite);

      // 敵の視線を設定
      EnemyFieldOfViewController fieldOfView = new EnemyFieldOfViewController(
          childOtherSprite, playerSprite, Sethitprocessing,
          viewingDistance: 300.0);
      enemyFieldOfViewControllerList.add(fieldOfView);
      await add(fieldOfView);

      // 敵の動きを作成
      EnemyRouteSetting(n, childOtherSprite, playerSprite!);
    }

    //ドアを配置する
    await SetPutDoor();
    // 鍵を配置する
    SetPutKey();

    debugText = new MyText(
      new TextBoxConfig(
        maxWidth: 300,
      ),
      PositionType.viewport,
    );
    debugText!.SetText("test", Colors.green, 24.0);
    await add(debugText!);

    // ジョイスティック操作
    myJoystickController = new MyJoystickController(
        knobRadius: 30.0,
        knobPaint: BasicPalette.white.withAlpha(200).paint(),
        backgroundRadius: 100.0,
        backgroundPaint: BasicPalette.white.withAlpha(100).paint(),
        margin: EdgeInsets.only(left: 40.0, bottom: 40.0));
    await add(myJoystickController!);

    // ボタンを追加する
    searchButton = new MyButton(
        "windows/button_001.png",
        "windows/button_001_hover.png",
        "\n調べる",
        Vector2(108, 96),
        onPushsearchButtonPressed);
    searchButton!.GetPos(new Vector2(270, 680));
    await add(searchButton!);

    // 上部のUIを表示
    headerUIWindow =
        new MyUIImage("windows/long_horror_gr.png", Vector2(566, 53));
    await add(headerUIWindow!);
    headerUIWindow!.GetPos(new Vector2(0, 20));
    headerUIWindow!.GetSize(new Vector2(viewSize.width, 53));

    uiText = new MyText(
      new TextBoxConfig(
        maxWidth: 500,
      ),
      PositionType.viewport,
    );
    uiText!.SetText("残り時間：" + gameCount.toStringAsFixed(0), Colors.white, 21.0);
    await add(uiText!);

    // メッセージUIを表示
    messageUIWindow =
        new MyUIImage("windows/long_horror_gr.png", Vector2(566, 53));
    await add(messageUIWindow!);
    messageUIWindow!.GetPos(new Vector2(0, viewSize.height / 2.0));
    messageUIWindow!.GetSize(new Vector2(viewSize.width, 53));
    messageUIWindow!.scale = new Vector2(0, 0);
    // メッセージUI用のテキスト
    messageUiText = new MyText(
      new TextBoxConfig(
        maxWidth: 500,
      ),
      PositionType.viewport,
    );
    messageUiText!.SetText("", Colors.white, 21.0);
    messageUiText!.GetPos(new Vector2(10, viewSize.height / 2.0));
    messageUiText!.scale = new Vector2(0, 0);
    await add(messageUiText!);

    gameOverImage =
        new MyUIImage("windows/GameOverImage.png", Vector2(540, 960));
    //await add(gameOverImage!);
    gameOverImage!.GetSize(new Vector2(viewSize.width, viewSize.height));
    gameOverImage!.GetColor(new Color(0xFFFFFF00));

    gameClearImage =
        new MyUIImage("windows/GameClearImage.png", Vector2(540, 960));
    //await add(gameClearImage!);
    gameClearImage!.GetSize(new Vector2(viewSize.width, viewSize.height));
    gameClearImage!.GetColor(new Color(0xFFFFFF00));
    // ゲーム終了時のテキスト
    uiGameEndText = new MyText(
      new TextBoxConfig(
        maxWidth: 500,
      ),
      PositionType.viewport,
    );

    gameEndButton = new MyButton(
        "windows/mini_horror_gr.png",
        "windows/mini_horror_gr.png",
        "　　　終了する",
        Vector2(234, 53),
        OnGameEndProcessing);

    _haveKeyList.clear();
    messageUIShowCount = 0;

    await super.onLoad();
  }

  /// 敵の巡回ルートを振り分ける
  void EnemyRouteSetting(int routeNum, MySpriteAnimation enemySprite,
      MySpriteAnimation playerSprite) {
    // 巡回ルート設定
    int startIndex = 0;
    List<Vector2> directions = [];
    switch (routeNum) {
      case 1:
      case 2:
        directions = EnemyDirections1;
        // 重なると不都合があるので開始位置を振り分ける
        startIndex = routeNum - 1;
        break;
      case 3:
        directions = EnemyDirections2;
        startIndex = 0;
        break;
      case 4:
        directions = EnemyDirections3;
        startIndex = 0;
        break;
    }
    // 敵の動きを作成
    EnemyMoveController enemyMoveControllers = new EnemyMoveController(
        enemySprite, playerSprite, directions,
        directionsIndex: startIndex, velocity: 50.0);
    enemyMoveControllerList.add(enemyMoveControllers);

    // 開始座標設定
    enemySprite.GetPos(directions[startIndex]);
  }

  /// ドアを配置する
  Future<void> SetPutDoor() async {
    mapDoorList.clear();
    // リストからドアを配置する
    DoorPosList.forEach((element) async {
      MyMapDoor door = new MyMapDoor(
          "tiles/door.png", new Vector2.zero(), new Vector2(32, 64), 1);

      door.GetPos(element);
      await add(door);

      mapDoorList.add(door);
    });
  }

  /// 鍵を設置する
  void SetPutKey() {
    mapKeyList.clear();
    int index = 0;
    KeyPosList.forEach((element) {
      KeyController keyC =
          new KeyController(KeyIndexList[index], element + Vector2(16, 16));
      mapKeyList.add(keyC);
      index++;
    });
  }

  /// ゲームに追加する
  @override
  void onMount() {
    super.onMount();
  }

  /// 描画処理
  /// [canvas] キャンバスオブジェクト
  @override
  void render(Canvas canvas) {
    backgroundLayer!.render(canvas);
    super.render(canvas);
  }

  /// 更新処理
  @override
  void update(double dt) {
    // ゲームの残り時間を減らす
    if (isGameClear == false) {
      if (gameCount > 0) {
        // ゲーム的に残り時間をーにしない
        //gameCount -= dt;
        if (gameCount <= 0) {
          gameCount = 0;
        }
      }
    }

    // メッセージウインドウのカウント
    if (messageUIShowCount > 0) {
      messageUIShowCount -= dt;
    }

    // 時間切れ
    if (gameCount <= 0) {
      // カウントが終わったのでゲーム終了
      isGameEnd = true;
      // ゲームオーバーの表示
      if (isShowGameEndImage == false) {
        add(gameOverImage!);
        add(uiGameEndText!);
        add(gameEndButton!);
      }
      gameOverImage!.GetSize(new Vector2(viewSize.width, viewSize.height));
      if (isEnemyFound == true) {
        uiGameEndText!.SetText("敵に見つかってしまった……", Colors.red, 24);
        uiGameEndText!.GetPos(new Vector2(60, 380));
      } else {
        uiGameEndText!.SetText("時間切れ……", Colors.red, 48);
        uiGameEndText!.GetPos(new Vector2(80, 380));
      }
      gameEndButton!.GetPos(new Vector2(100, 700));
      gameEndButton!.SetText();

      isShowGameEndImage = true;
    } else {
      if (isGameClear == true) {
        // ゲームクリアの表示
        if (isShowGameEndImage == false) {
          add(gameClearImage!);
          add(uiGameEndText!);
          add(gameEndButton!);
        }
        gameClearImage!.GetSize(new Vector2(viewSize.width, viewSize.height));
        uiGameEndText!.SetText("脱出成功！！", Colors.yellow, 48);
        uiGameEndText!.GetPos(new Vector2(100, 430));
        gameEndButton!.GetPos(new Vector2(-5, 350));
        gameEndButton!.SetText();
        isShowGameEndImage = true;
      }
      if (isEnemyFound == true) {
        // 敵に見つかってゲームオーバー
        gameCount = 0;
      }
    }

    if (myJoystickController!.delta.isZero() != true &&
        isGameEnd == false &&
        isGameClear == false) {
      // スティックが倒されている
      playerSprite!.SetMove((myJoystickController!.GetValue() * 75.0));
    }

    String tt = "FPS:" + (6.0 / dt).toStringAsFixed(2) + "\n";
    tt += "Player X:" +
        playerSprite!.SetPos().x.toStringAsFixed(2) +
        " Y:" +
        playerSprite!.SetPos().y.toStringAsFixed(2) +
        "\n";
    //tt += "Enemy " + otherSprite!.GetDebugText() + "\n";
    debugText!.SetText(tt, Colors.green, 21.0);
    debugText!.GetPos(new Vector2(0, 250));

    // ゲーム時間表示
    uiText!.SetText("残り時間：" + gameCount.toStringAsFixed(0), Colors.white, 21.0);
    uiText!.GetPos(new Vector2(10, 18));

    // 敵の処理
    if (isGameEnd == false && isGameClear == false) {
      // 敵を動かす
      enemyMoveControllerList.forEach((element) {
        element!.SetMove();
      });
      // 目線判定をONにする
      enemyFieldOfViewControllerList.forEach((element) {
        element!.isPlay = true;
      });
    } else {
      // 目線判定をONにする
      enemyFieldOfViewControllerList.forEach((element) {
        element!.isPlay = false;
      });
    }

    // カメラ設定
    camera.followComponent(playerSprite!);

    // メッセージUI設定
    SetShowMessageUI();

    super.update(dt);
  }

  /// ゲーム終了時に呼ばれる関数
  void OnGameEndProcessing() {}

  /// 敵に見つかった時の処理
  void Sethitprocessing() {
    isEnemyFound = true;
  }

  /// 調べるボタンを押した時
  void onPushsearchButtonPressed() {
    print("調べるボタンを押した");

    // 鍵を見つける
    for (KeyController? element in mapKeyList) {
      int keyID = element!.GetKey(playerSprite!.SetPos());
      if (keyID == -1) {
        // 鍵は見つからなかった
        continue;
      }
      if (_haveKeyList.indexWhere((e) => e == keyID) > -1) {
        // すでに持っている
        continue;
      }
      _haveKeyList.add(keyID);
      print("鍵を取得した:" + keyID.toString());
      SetMessageText(KeyNameList[keyID] + "を見つけました！");
    }

    // ドアを開ける
    mapDoorList.forEach((element) {
      if (element!.SetDoorOpen(_haveKeyList) == true) {
        // ドアを開けた
        SetMessageText("鍵を解除してドアを開けました！");
      }
    });
  }

  void SetMessageText(String mes) {
    messageUIShowCount = 5.0;
    messageUiText!.SetText(mes, Colors.white, 21.0);
  }

  /// メッセージUIを表示させる
  void SetShowMessageUI() {
    if (messageUIShowCount <= 0.0) {
      messageUiText!.SetText("", Colors.white, 21.0);
      messageUIWindow!.scale = new Vector2(0, 0);
      messageUiText!.scale = new Vector2(0, 0);
      return;
    }

    messageUIWindow!.scale = new Vector2(1.0, 1.0);
    messageUiText!.scale = new Vector2(1.0, 1.0);
  }
}
