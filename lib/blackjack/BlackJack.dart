import 'package:flame/components.dart';
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
  late Sprite button1;
  late Sprite button2;
  static late Vector2 deckPosition;

  final Vector2 buttonSize = Vector2(190, 49);
  late final Vector2 buttonPosition;

  final Vector2 button1Size = Vector2(50, 50);
  final Vector2 button2Size = Vector2(50, 50);
  late final Vector2 button1Position;
  late final Vector2 button2Position;
  
  late final Vector2 lineSize;
  late Sprite lineJogador;
  late Vector2 lineJogadorPos;
  late Sprite lineAdversario;
  late Vector2 lineAdversarioPos;

  late TextPaint nickJogador;
  late TextPaint nickAdversario;
  
  int quant = 0;
  int pos = 0;
  static bool isPressed = false;
  static bool draw = false;
  static bool drawUp = false;
  static bool chooseValue = false;
  static bool valueChosen = false;
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

    button1 = await loadSprite(
        'botão.png'
    );

    button2 = await loadSprite(
        'botão.png'
    );

    unpressedButton = await loadSprite(
      'buttonUp.png',
      srcPosition: Vector2.zero(),
      srcSize: Vector2(190, 49),
    );

    pressedButton = await loadSprite(
      'buttonDown.png',
      srcPosition: Vector2.zero(),
      srcSize: Vector2(190, 49),
    );
    
    button1Position = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.blockSizeVertical*90));
    button2Position = Vector2(SizeConfig.blockSizeHorizontal*90, (SizeConfig.blockSizeVertical*90));
    deckPosition = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.blockSizeVertical*50)-(cardHeight/2));
    buttonPosition = Vector2((SizeConfig.blockSizeHorizontal*50)-(buttonSize.x/2), SizeConfig.screenHeight-5*SizeConfig.blockSizeVertical-(buttonSize.y/2));

    lineJogador = await loadSprite(
      'sliderHorizontal.png',
    );

    lineAdversario = await loadSprite(
      'sliderHorizontal.png',
    );

    lineSize = Vector2(SizeConfig.blockSizeHorizontal*90, SizeConfig.blockSizeVertical*0.5);
    lineJogadorPos = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.screenHeight/2) + (cardHeight/2) + (SizeConfig.blockSizeVertical)*8);
    lineAdversarioPos = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.screenHeight/2) - (cardHeight/2) - (SizeConfig.blockSizeVertical)*8);
  
    nickJogador = TextPaint(
      config: TextPaintConfig(
        fontSize: 20.0,
        fontFamily: 'Arial',
        color: Color(0xFFFFFFFF),
      ),
    );
  
    nickAdversario = TextPaint(
      config: TextPaintConfig(
        fontSize: 20.0,
        fontFamily: 'Arial',
        color: Color(0xFFFFFFFF),
      ),
    );
  }

  @override
  void onTapDown(TapDownInfo info) {
    final buttonArea = buttonPosition & buttonSize;
    if (buttonArea.contains(info.eventPosition.game.toOffset())) {
      print('botão abaixar clicado');
    }

    final deckArea = deckPosition & Vector2(cardWidth, cardHeight);
    if (!draw){
      if (deckArea.contains(info.eventPosition.game.toOffset())) {
        isPressed = true;
        print('botão comprar clicado');
        Carta.comprarCarta();
      }
    }

    final button1Area = button1Position & button1Size;
    if (button1Area.contains(info.eventPosition.game.toOffset()) && chooseValue) {
      jogador.mao[pos].valor = 1;
      chooseValue = false;
      valueChosen = true;
    }

    final button2Area = button2Position & button2Size;
    if (button2Area.contains(info.eventPosition.game.toOffset()) && chooseValue) {
      jogador.mao[pos].valor = 11;
      chooseValue = false;
      valueChosen = true;
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    //isPressed = false; 
  }

  @override
  void onTapCancel() {
    //isPressed = false;
  }


  @override
  void update(double dt) {
    if (isPressed) {
      // quando botão é clicado, somar em 1 a quantidade de cartas se draw é 
      if(!draw) {
        valueChosen = false;
        quant += 1;
      }
      draw = true;
    }
  }


  // GAME LOOP AQUI
  @override
  void render(Canvas canvas) {

    if (chooseValue) {
      button1.render(canvas, position: button1Position, size: button1Size);
      button2.render(canvas, position: button2Position, size: button2Size);
    }

    // Renderizar botão de "abaixar a mão"
    final button = isPressed ? pressedButton : unpressedButton;
    button.render(canvas, position: buttonPosition, size: buttonSize);

    // Renderizar baralho de cartas
    deck.render(canvas, position: deckPosition, size: Vector2(cardWidth, cardHeight));

    // Renderar linha e nickname dos players
    lineJogador.render(canvas, position: lineJogadorPos, size: lineSize);
    lineAdversario.render(canvas, position: lineAdversarioPos, size: lineSize);

    nickJogador.render(canvas, 'Nickname do jogador', Vector2(lineJogadorPos.x+lineSize.x, lineJogadorPos.y), anchor: Anchor.bottomRight);
    nickAdversario.render(canvas, 'Nickname do adversário', Vector2(lineAdversarioPos.x, lineAdversarioPos.y), anchor: Anchor.bottomLeft);

    // Movimentação das cartas após a compra
    if (draw){

      //print("Teste: ${this.context!.read<AppService>().getNickname()}");
        if (jogador.mao[quant - 1].naipe[0] == "A" && !valueChosen){
          if (!jogador.mao[quant - 1].drawA()) {
            jogador.mao[quant - 1].isTurning = true;
            pos = quant - 1;
            chooseValue = true;
          }
        }
      else{
        for (int i = 0; i < jogador.mao.length; i++) {
          if (i != quant - 1)
            jogador.mao[i].move();
          else if (!jogador.mao[i].draw(quant) && !isPressed) {
            jogador.mao[i].isTurning = true;
            draw = false;
          }
        }
      } 
    }
    
    // Virada da carta
    for (var i = 0; i < jogador.mao.length; i++){
      if (jogador.mao[i].isTurning)
        jogador.mao[i].turnCard();
    }

    // Renderizar cartas na tela
    for (var i = 0; i < jogador.mao.length; i++){
      jogador.mao[i].render(canvas);
    } 
  }

  @override
  Color backgroundColor() => const Color(0xFF062B06);
}