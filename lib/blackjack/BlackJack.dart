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
  int timer = 0; 
  int quant = 0;

  static late Jogador jogador = Jogador([], 0);
  static late Jogador adversario = Jogador([], 0);
  static late Map sprites = {};
  
  late Sprite deck;
  late Sprite pressedButton;
  late Sprite unpressedButton;

  static final double cardWidth = 87.5; //140 (largura do sprite) / 1.6
  static final double cardHeight = 118.75; //190 (altura do sprite)/ 1.6
  static late Vector2 deckPosition;

  final Vector2 buttonSize = Vector2(138, 50);
  late final Vector2 buttonPosition;
  late TextPaint labelBtn;
  
  late final Vector2 lineSize;
  late Sprite lineJogador;
  late Vector2 lineJogadorPos;
  late Sprite lineAdversario;
  late Vector2 lineAdversarioPos;
  
  int pos = 0;
  static bool isPressed = false;
  static bool abaixar = false;
  static bool gameEnd = false;
  static bool draw = false;
  static bool zoom = false;
  static bool click = false;
  static bool cardAdv = false;
  static bool turnAdv = false;
  BuildContext? context;

  late String nicknameJogador;
  late String nicknameAdversario;
  late TextPaint nickJogador;
  late TextPaint nickAdversario;

  late TextPaint pontosJogador;
  late TextPaint pontosAdversario;

  late TextPaint labelTimer;

  BlackJack(BuildContext context) {
    this.context = context;

    //Reiniciar váriaveis estáticas
    isPressed = false;
    abaixar = false;
    gameEnd = false;
    draw = false;
    zoom = false;
    click = false;
    turnAdv = false;
    cardAdv = false;
    jogador = Jogador([], 0);
    adversario = Jogador([], 0);
    sprites = {};

    SizeConfig().init(context);
  }

  // Função executada ao iniciar a classe e o game loop para carregamento de sprites
  // e inicialização de atributos do jogo
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
      'btn_out.png',
      srcPosition: Vector2.zero(),
      srcSize: Vector2(381, 138),
    );

    pressedButton = await loadSprite(
      'btn_in.png',
      srcPosition: Vector2.zero(),
      srcSize: Vector2(381, 138),
    );
    
    deckPosition = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.blockSizeVertical*50)-(cardHeight/2));
    buttonPosition = Vector2((SizeConfig.blockSizeHorizontal*50)-(buttonSize.x/2), (SizeConfig.screenHeight) - buttonSize.y - (SizeConfig.blockSizeVertical*3));

    lineJogador = await loadSprite(
      'sliderHorizontal.png',
    );

    lineAdversario = await loadSprite(
      'sliderHorizontal.png',
    );

    lineSize = Vector2(SizeConfig.blockSizeHorizontal*90, SizeConfig.blockSizeVertical*0.5);
    lineJogadorPos = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.screenHeight/2) + (cardHeight/2) + (SizeConfig.blockSizeVertical)*8);
    lineAdversarioPos = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.screenHeight/2) - (cardHeight/2) - (SizeConfig.blockSizeVertical)*8);
  
    // Inicializando nick dos jogadores
    nicknameJogador = this.context?.read<AppService>().getNickname() as String;
    nicknameAdversario = this.context?.read<AppService>().getOpponentNick() as String;

    var textPaint = TextPaint(
      config: TextPaintConfig(
        fontSize: 20.0,
        fontFamily: 'Arial',
        color: Color(0xFFFFFFFF),
      ),
    );

    var textPaint2 = TextPaint(
      config: TextPaintConfig(
        fontSize: 20.0,
        fontFamily: 'Arial',
        color: Color(0xFFAD200C),
      ),
    );

    nickJogador = textPaint;
    nickAdversario = textPaint;
    labelBtn = textPaint;
    labelTimer = textPaint2;
    pontosJogador = textPaint;
    pontosAdversario = textPaint;
  }

  @override
  Future<void> onTapDown(TapDownInfo info) async {
    final buttonArea = buttonPosition & buttonSize;
    // // se jogador tem mais de 16 pontos, ainda não abaixou a mão e clica no botão abaixar
    if (buttonArea.contains(info.eventPosition.game.toOffset()) && abaixar == false && jogador.pontos >= 16) {
      await this.context?.read<AppService>().putHandDown();
      abaixar = true;
    }

    final deckArea = deckPosition & Vector2(cardWidth, cardHeight);
    if (!draw && !zoom){
      if (deckArea.contains(info.eventPosition.game.toOffset())) {
        // Verificar se jogador pode comprar cartas
        if(jogador.pontos >= 21){
          jogador.estourou = true;
        }
        else{
          var card = await this.context?.read<AppService>().askForCard() as String;
          isPressed = true;
          click = true;
          
          print('A carta retornada foi: $card');
          draw = true;
          quant += 1;
          Carta.comprarCarta(card);
        }
      }
    }

    // Foi feita essa condição do if para que ao comprar a carta ela continue com o tamanho menor dela e que durante a compra não seja possível fazer o zoom
    if (!zoom && !draw && !click) {
      if (jogador.mao.length > 0){
        // Começa na última posição do vetor para que nas cartas que estão com sobreposição seja selecionada a carta mais exterior
        for (int i = jogador.mao.length - 1; i >= 0; i --) {
          Rect cardArea = Vector2(jogador.mao[i].x, jogador.mao[i].y) & Vector2(jogador.mao[i].width, jogador.mao[i].height);
          if (cardArea.contains(info.eventPosition.game.toOffset())) {
            // O valor do width é atualizado fora da função para ser atualizada em cada frame
            jogador.mao[i].width = 175;
            jogador.mao[i].height = 237.75;
            jogador.mao[i].zoomIn();
            zoom = true;
            click = true;
            break;
          }
        }
      }
    }

    // Realização do zoomOut
    if (zoom && !click){
      for (int i = jogador.mao.length - 1; i >= 0; i --) {
        if (jogador.mao[i].zoom){
          final cardArea = Vector2(jogador.mao[i].x, jogador.mao[i].y) & Vector2(
              jogador.mao[i].width, jogador.mao[i].height);
          if (!cardArea.contains(info.eventPosition.game.toOffset()) && !draw) {
            jogador.mao[i].zoomOut();
            zoom = false;
            click = true;
            break;
          }
        }
      }
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    /* final buttonArea = buttonPosition & buttonSize;
    if (buttonArea.contains(info.eventPosition.game.toOffset())) {
      print("soltar botão abaixar");
      abaixar = false;
    } */

    final tela = Vector2(0, 0) & Vector2(SizeConfig.screenWidth, SizeConfig.screenHeight);
    if (tela.contains(info.eventPosition.game.toOffset())){
      click = false;
    }
  }

  @override
  void onTapCancel() {
    // zoomUp = false;
  }

  @override
  Future<void> update(double dt) async {
    if (isPressed) {
      draw = true;
    }

    // Se jogador tem mais de 21 pontos não pode abaixar a mão mais e é setado no firebase que ele abaixou a mão
    if (jogador.pontos >= 21 && abaixar == false) {
      await context?.read<AppService>().putHandDown();
      abaixar = true;
    }
  }

  // GAME LOOP AQUI
  @override
  void render(Canvas canvas) {
    // Renderizar botão de "abaixar a mão"
    final button = abaixar ? pressedButton : unpressedButton;
    button.render(canvas, position: buttonPosition, size: buttonSize);
    labelBtn.render(canvas, "Abaixar", Vector2(buttonPosition.x+buttonSize.x/2, buttonPosition.y+35), anchor: Anchor.bottomCenter);
    
    // Renderizar baralho de cartas
    deck.render(canvas, position: deckPosition, size: Vector2(cardWidth, cardHeight));

    // Renderar linha e nickname dos players
    lineJogador.render(canvas, position: lineJogadorPos, size: lineSize);
    lineAdversario.render(canvas, position: lineAdversarioPos, size: lineSize);

    nickJogador.render(canvas, nicknameJogador, Vector2(lineJogadorPos.x+lineSize.x, lineJogadorPos.y), anchor: Anchor.bottomRight);
    nickAdversario.render(canvas, nicknameAdversario, Vector2(lineAdversarioPos.x, lineAdversarioPos.y), anchor: Anchor.bottomLeft);

    // Renderizar pontuação do jogador e do adversário
    pontosJogador.render(canvas, jogador.pontos.toString(), Vector2(lineJogadorPos.x, lineJogadorPos.y), anchor: Anchor.bottomLeft);
    if (gameEnd){
      pontosAdversario.render(canvas, adversario.pontos.toString(), Vector2(lineAdversarioPos.x+lineSize.x, lineAdversarioPos.y), anchor: Anchor.bottomRight);
    }

    // Renderizar timer na tela
    var minutos = (timer ~/ 60).toString();
    var segundos = (timer % 60) > 9 ? (timer % 60).toString() :  '0'+(timer % 60).toString();
    labelTimer.render(canvas, minutos+':'+segundos, Vector2(SizeConfig.screenWidth/2, SizeConfig.blockSizeVertical*7), anchor: Anchor.bottomCenter);
    
    // Movimentação das cartas após a compra
    if (draw && quant == jogador.mao.length){
      for (int i = 0; i < jogador.mao.length; i++) {
        if (i != jogador.mao.length - 1)
          jogador.mao[i].move();
        else if (!jogador.mao[i].draw(jogador.mao.length) && !isPressed) {
          jogador.mao[i].isTurning = true;
          draw = false;
        }
      }
    }
    
    // Virada da carta do jogador após a compra
    for (var i = 0; i < jogador.mao.length; i++){
      if (jogador.mao[i].isTurning) {
        jogador.mao[i].turnCard();
      }
    }

    // Zoom da carta, o valor é constantemente atualizado do width e do height por causa da função de virada da carta que muda o valor do width
    for (var i = 0; i < jogador.mao.length; i++){
      if (jogador.mao[i].zoom) {
        jogador.mao[i].width = 175;
        jogador.mao[i].height = 237.75;
      }
    }

    //Animar cartas compradas pelo adversário
    if(!zoom && cardAdv)
      Carta.animarCartasAdv();

    if(turnAdv)
      Carta.virarCartasAdv();

    // Renderizar cartas na tela
    for (var i = 0; i < jogador.mao.length; i++){
      jogador.mao[i].render(canvas);
    } 

    //print('Temporizador = $timer');
  }

  @override
  Color backgroundColor() => const Color(0xFF062B06);
}
