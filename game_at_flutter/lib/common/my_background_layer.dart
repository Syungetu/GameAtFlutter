import 'package:flame/components.dart';
import 'package:flame/layers.dart';

class MyBackgroundLayer extends PreRenderedLayer {
  final Component sprite;

  MyBackgroundLayer(this.sprite) {
    preProcessors.add(ShadowProcessor());
  }

  @override
  void drawLayer() {
    sprite.render(canvas);
  }
}
