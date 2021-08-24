import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'Carta.dart';

/*class GetGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myGame = MyGame(context);
    return GameWidget(game: myGame);
  }
}*/

class MyGame extends Game with TapDetector {
  late Sprite pressedButton;
  late Sprite unpressedButton;
  //late Carta teste = Carta("0", 1,"0", 0, 200);
  late List<Carta> teste = [
    Carta("0", 1, "0", 0, 100),
    Carta("0", 1, "0", 0, 300)
  ];

  BuildContext? context;

  MyGame(BuildContext context) {
    this.context = context;
  }

  bool isPressed = false;
  bool draw = false;
  bool turnCard = false;

  final buttonPosition = Vector2(200, 120);
  final buttonSize = Vector2(120, 30);

  @override
  Future<void> onLoad() async {
    for (var i = 2; i < 4; i++) {
      teste[i - 2].baralho = await loadSprite(
        'cardClubs' + i.toString() + ".png",
      );
    }

    for (var i = 2; i < 4; i++) {
      teste[i - 2].cardBack = await loadSprite(
        'cardBack.png',
      );
    }

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

    /* teste.baralho = await loadSprite(
      'cardClubsA.png',
    );
    teste.cardBack = await loadSprite(
      'cardBack.png',
    );  */
  }

  @override
  void onTapDown(TapDownInfo info) {
    final buttonArea = buttonPosition & buttonSize;

    isPressed = buttonArea.contains(info.eventPosition.game.toOffset());
    turnCard = buttonArea.contains(info.eventPosition.game.toOffset());
  }

  @override
  void onTapUp(TapUpInfo info) {
    isPressed = false;
    turnCard = false;
  }

  @override
  void onTapCancel() {
    isPressed = false;
    turnCard = false;
  }

  @override
  void update(double dt) {
    if (isPressed) {
      draw = true;
      turnCard = true;
    }
  }

  // GAME LOOP AQUI
  @override
  void render(Canvas canvas) {
    final button = isPressed ? pressedButton : unpressedButton;
    button.render(canvas, position: buttonPosition, size: buttonSize);
    if (draw) {
      print("Teste: ${this.context!.read<AppService>().getNickname()}");
      //teste.draw();
    }

    for (var i = 0; i < 2; i++) {
      if (turnCard) {
        teste[i].turnCard();
      }
      teste[i].render(canvas);
    }
    // Virada da carta
  }

  @override
  Color backgroundColor() => const Color(0xFF062B06);
}
