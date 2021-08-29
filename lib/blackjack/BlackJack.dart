import 'package:flame/game.dart'; 
import 'package:flame/gestures.dart'; 
import 'package:flame/sprite.dart'; 
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/Jogador.dart';
import 'package:gruporoxo20211/blackjack/SizeConfig.dart';
import 'package:provider/provider.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'Carta.dart';

class GetGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myGame = BlackJack(context);
    return GameWidget(game: myGame);
  }
}

class BlackJack extends Game with TapDetector {
  static late Jogador jogador = Jogador([],0);
  static late Jogador adversario = Jogador([],0);
  static late Map sprites = {};

  static final double cardWidth = 87.5; //140 / 1.6
  static final double cardHeight = 118.75; //190 / 1.6

  late Sprite pressedButton;
  late Sprite unpressedButton;
  late Sprite deck;
  static late Vector2 deckPosition;

  final Vector2 buttonSize = Vector2(120, 30);
  late final Vector2 buttonPosition;
  
  int quant = 0;
  bool isPressed = false;
  bool draw = false;
  bool turnCard = false;
  BuildContext? context;

  BlackJack(BuildContext context) {
    this.context = context;
    SizeConfig().init(context);
  }

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

    deck = await loadSprite(
      'cardBack.png'
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

    deckPosition = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.blockSizeVertical*50)-(cardHeight/2));
    buttonPosition = Vector2((SizeConfig.blockSizeHorizontal*50)-(buttonSize.x/2), SizeConfig.screenHeight-5*SizeConfig.blockSizeVertical-(buttonSize.y/2));
  }

  @override
  void onTapDown(TapDownInfo info) {
    final buttonArea = buttonPosition & buttonSize;
    if (buttonArea.contains(info.eventPosition.game.toOffset())) {
      isPressed = true;
      turnCard = true;
      print('botão abaixar clicado');
    }

    final deckArea = deckPosition & Vector2(cardWidth, cardHeight);
    if (deckArea.contains(info.eventPosition.game.toOffset())) {
      isPressed = true;
      turnCard = true;
      print('botão comprar clicado');
    
      for (var i = 0; i < jogador.mao.length; i++){
        //print(jogador.mao[i].valor);
      }
      Carta.comprarCarta();
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

    //print(quant);
    final button = isPressed ? pressedButton : unpressedButton;
    button.render(canvas, position: buttonPosition, size: buttonSize);

    deck.render(canvas, position: deckPosition, size: Vector2(cardWidth, cardHeight));

    if (draw){
      print("Teste: ${this.context!.read<AppService>().getNickname()}");
      for (int i = 0; i < jogador.mao.length; i++){
        if (i != quant - 1)
          jogador.mao[i].move(quant);
        else
          if(!jogador.mao[i].draw(quant) && !isPressed)
            draw = false;

        print(jogador.mao[i].x);
        print(jogador.mao[i].y);
      } 
    }
    
    // Virada da carta
    for (var i = 0; i < jogador.mao.length; i ++){
      if (turnCard){
        //jogador.mao[i].turnCard();
      } 
      jogador.mao[i].render(canvas);
    } 
  }

  @override
  Color backgroundColor() => const Color(0xFF062B06);
}