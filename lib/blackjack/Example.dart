import 'package:flame/game.dart'; 
import 'package:flame/gestures.dart'; 
import 'package:flame/sprite.dart'; 
import 'package:flutter/material.dart';

Future<void> main() async {
  final myGame = MyGame();
  runApp(GameWidget(game: myGame));
}

class MyGame extends Game with TapDetector {
  late SpriteAnimation runningRobot;
  late Sprite pressedButton;
  late Sprite unpressedButton;
  late Sprite card;
  

  bool isPressed = false;

  final buttonPosition = Vector2(200, 120);
  final buttonSize = Vector2(120, 30);

  final robotPosition = Vector2(240, 50);
  final robotSize = Vector2(48, 60);

  double x = 1;

  @override
  Future<void> onLoad() async {
    runningRobot = await loadSpriteAnimation(
      'robot.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2(16, 18),
      ),
    );

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

    card = await loadSprite(
      'cardClubsA.png',
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
      runningRobot.update(dt);
    }
  }


  // GAME LOOP AQUI
  @override
  void render(Canvas canvas) {
    runningRobot
        .getSprite()
        .render(canvas, position: robotPosition, size: robotSize);

    final button = isPressed ? pressedButton : unpressedButton;
    button.render(canvas, position: buttonPosition, size: buttonSize);

    //card.render(canvas, position: Vector2(0, 0), size: Vector2(188, 254));
    canvas.save();
    //canvas.skew(0.5, 0.5); //ajeitar eixo de inclinação
    //canvas.translate(100, 100);
    if (x > 0){
      x -= 0.02;
    }
    else{
      x = 1; //voltando
    }
    canvas.scale(x, 1);
    //canvas.rotate(.3);
    card.renderRect(canvas, Rect.fromLTWH(0, 0, 140, 190));
    canvas.restore();
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);
}