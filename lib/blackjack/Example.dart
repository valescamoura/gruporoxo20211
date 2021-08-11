import 'package:flame/game.dart'; 
import 'package:flame/gestures.dart'; 
import 'package:flame/sprite.dart'; 
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'Carta.dart';

Future<void> main() async {
  final myGame = MyGame();
  runApp(GameWidget(game: myGame));
  Flame.images.loadAll(<String>['cardClubsA.png',]);
}

class MyGame extends Game with TapDetector {
  late Sprite pressedButton;
  late Sprite unpressedButton;
  late Carta teste = Carta("0", 1,"0", 0, 200);

  bool isPressed = false;
  bool draw = false;

  final buttonPosition = Vector2(200, 120);
  final buttonSize = Vector2(120, 30);

  final robotPosition = Vector2(240, 50);
  final robotSize = Vector2(48, 60);

  double x = 1;

  @override
  Future<void> onLoad() async {

    unpressedButton = await loadSprite(
      'buttons.png',
      srcPosition: Vector2.zero(),
      srcSize: Vector2(60, 20),
    );

    pressedButton = await loadSprite(
      'buttons.png',
      srcPosition: Vector2(0, 20),
      srcSize: Vector2(60, 20),
    );

    teste.baralho = await loadSprite(
      'cardBack.png',
    );

  }

  @override
  void onTapDown(TapDownInfo info) {
    final buttonArea = buttonPosition & buttonSize;

    isPressed = buttonArea.contains(info.eventPosition.game.toOffset());
  }

  @override
  void onTapUp(TapUpInfo info) {
    isPressed = false;
  }

  @override
  void onTapCancel() {
    isPressed = false;
  }

  @override
  void update(double dt) {
    if (isPressed) {
      draw = true;
    }
  }


  // GAME LOOP AQUI
  @override
  void render(Canvas canvas) {

    final button = isPressed ? pressedButton : unpressedButton;
    if (draw){
      teste.draw();
    }
    button.render(canvas, position: buttonPosition, size: buttonSize);
    teste.render(canvas);
    canvas.save();
    canvas.restore();
  }

  @override
  Color backgroundColor() => const Color(0xFF062B06);
}