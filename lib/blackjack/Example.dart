import 'package:flame/game.dart'; 
import 'package:flame/gestures.dart'; 
import 'package:flame/sprite.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'Carta.dart';

class GetGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myGame = MyGame(context);
    return GameWidget(game: myGame);
  }
}

class MyGame extends Game with TapDetector {
  late Sprite pressedButton;
  late Sprite unpressedButton;
  // late Sprite baralho;
  late List <Carta> teste = [Carta("0", 1, 0, 360), Carta("0", 1, 0, 360), Carta("0", 1, 0, 360), Carta("0", 1, 0, 360)];
  static late Map sprites = {};
  int quant = 0;
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

    var listaDeNaipes = generateDeck();
    for (var i = 0; i < listaDeNaipes.length; i ++){
      sprites[listaDeNaipes[i]] = await loadSprite(
        listaDeNaipes[i] + ".png",
      );
    }
    
    sprites["cardBack"] = await loadSprite(
         "cardBack.png",
    );

    /* for (var i = 2; i < 6; i ++){
      teste[i-2].baralho = await loadSprite(
        'cardClubs' + i.toString() + ".png",
      );
    }

    for (var i = 2;i < 6;i ++){
      teste[i-2].cardBack = await loadSprite(
        'cardBack.png',
      );
    } */

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

  }

  @override
  void onTapDown(TapDownInfo info) {
    final buttonArea = buttonPosition & buttonSize;

    if (buttonArea.contains(info.eventPosition.game.toOffset())) {
      isPressed = true;
      turnCard = true;
    }
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
      if(!draw) {
        quant += 1;
      }
      draw = true;
    }
  }


  // GAME LOOP AQUI
  @override
  void render(Canvas canvas) {

    print(quant);
    final button = isPressed ? pressedButton : unpressedButton;
    button.render(canvas, position: buttonPosition, size: buttonSize);
    if (draw){
      print("Teste: ${this.context!.read<AppService>().getNickname()}");
      for (int i = 0; i < quant; i++){
        if (i != quant - 1)
          teste[i].move(quant);
        else
          if(!teste[i].draw(quant) && !isPressed)
            draw = false;
      }
    }
    
    // Virada da carta
    for (var i = 0;i < 4; i ++){
      if (turnCard){
        Carta.comprarCarta();
        //teste[i].turnCard();
      } 
     teste[i].render(canvas);
    }
    
    // baralho.render(canvas, position: )
    
  }

  @override
  Color backgroundColor() => const Color(0xFF062B06);
}