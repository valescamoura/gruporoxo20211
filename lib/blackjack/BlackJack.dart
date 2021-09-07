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

  static late Jogador jogador = Jogador([],0);
  static late Jogador adversario = Jogador([],0);
  static late Map sprites = {};
  
  late Sprite deck;
  late Sprite pressedButton;
  late Sprite unpressedButton;
  late Sprite button1;
  late Sprite button2;

  static final double cardWidth = 87.5; //140 (largura do sprite) / 1.6
  static final double cardHeight = 118.75; //190 (altura do sprite)/ 1.6
  static late Vector2 deckPosition;

  final Vector2 buttonSize = Vector2(138, 50);
  late final Vector2 buttonPosition;
  late TextPaint labelBtn;

  final Vector2 button1Size = Vector2(50, 50);
  final Vector2 button2Size = Vector2(50, 50);
  late final Vector2 button1Position;
  late final Vector2 button2Position;
  late TextPaint labelBtn1;
  late TextPaint labelBtn2;
  
  late final Vector2 lineSize;
  late Sprite lineJogador;
  late Vector2 lineJogadorPos;
  late Sprite lineAdversario;
  late Vector2 lineAdversarioPos;
  
  int pos = 0;
  static bool isPressed = false;
  static bool abaixar = false;
  static bool draw = false;
  static bool drawUp = false;
  static bool zoom = false;
  static bool click = false;
  static bool chooseValue = false;
  static bool valueChosen = false;
  BuildContext? context;

  late String nicknameJogador;
  late String nicknameAdversario;
  late TextPaint nickJogador;
  late TextPaint nickAdversario;

  static String message = "";
  static bool hasMessage = false;
  late TextPaint labelMessage;

  BlackJack(BuildContext context) {
    this.context = context;
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

    button1 = await loadSprite(
        'btn_a.png'
    );

    button2 = await loadSprite(
        'btn_a.png'
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
    button1Position = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.screenHeight) - buttonSize.y - (SizeConfig.blockSizeVertical*3));
    button2Position = Vector2((SizeConfig.blockSizeHorizontal*95)-button2Size.x, (SizeConfig.screenHeight) - buttonSize.y - (SizeConfig.blockSizeVertical*3));

    lineJogador = await loadSprite(
      'sliderHorizontal.png',
    );

    lineAdversario = await loadSprite(
      'sliderHorizontal.png',
    );

    lineSize = Vector2(SizeConfig.blockSizeHorizontal*90, SizeConfig.blockSizeVertical*0.5);
    lineJogadorPos = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.screenHeight/2) + (cardHeight/2) + (SizeConfig.blockSizeVertical)*8);
    lineAdversarioPos = Vector2(SizeConfig.blockSizeHorizontal*5, (SizeConfig.screenHeight/2) - (cardHeight/2) - (SizeConfig.blockSizeVertical)*8);
  
    nicknameJogador = this.context?.read<AppService>().getNickname() as String;
    nicknameAdversario = this.context?.read<AppService>().getOpponentNick() as String;
    //jogador.mao = [];

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

    labelBtn = TextPaint(
      config: TextPaintConfig(
        fontSize: 20.0,
        fontFamily: 'Arial',
        color: Color(0xFFFFFFFF),
      ),
    );

    labelBtn1 = TextPaint(
      config: TextPaintConfig(
        fontSize: 20.0,
        fontFamily: 'Arial',
        color: Color(0xFFFFFFFF),
      ),
    );

    labelBtn2 = TextPaint(
      config: TextPaintConfig(
        fontSize: 20.0,
        fontFamily: 'Arial',
        color: Color(0xFFFFFFFF),
      ),
    );

    labelMessage = TextPaint(
      config: TextPaintConfig(
        fontSize: 14.0,
        fontFamily: 'Arial',
        color: Color(0xFFFDFD96),
      ),
    );
  }

  @override
  Future<void> onTapDown(TapDownInfo info) async {
    final buttonArea = buttonPosition & buttonSize;
    if (buttonArea.contains(info.eventPosition.game.toOffset())) {
      print('botão abaixar clicado');
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
          isPressed = true;
          click = true;
          var card = await this.context?.read<AppService>().askForCard() as String;
          print('A carta retornada foi: $card');
          Carta.comprarCarta(card);
        }
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
    final buttonArea = buttonPosition & buttonSize;
    if (buttonArea.contains(info.eventPosition.game.toOffset())) {
      print("soltar botão abaixar");
      abaixar = false;
    }
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
  void update(double dt) {
    if (isPressed) {
      if(!draw) {
        valueChosen = false;
      }
      draw = true;
    }
  }

  // GAME LOOP AQUI
  @override
  void render(Canvas canvas) {

    // Renderizar botões para escolher valor do Às.
    if (chooseValue) {
      button1.render(canvas, position: button1Position, size: button1Size);
      button2.render(canvas, position: button2Position, size: button2Size);
      labelBtn1.render(canvas, "1", Vector2(button1Position.x+button1Size.x/2, button1Position.y+35), anchor: Anchor.bottomCenter);
      labelBtn2.render(canvas, "11", Vector2(button2Position.x+button2Size.x/2, button2Position.y+35), anchor: Anchor.bottomCenter);
    }

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

    // Movimentação das cartas após a compra
    if (draw && jogador.mao.length!=0){
      //print("Teste: ${this.context!.read<AppService>().getNickname()}");
      if (jogador.mao[jogador.mao.length - 1].naipe[0] == "A" && !valueChosen){
        if (!jogador.mao[jogador.mao.length - 1].drawA()) {
          jogador.mao[jogador.mao.length - 1].isTurning = true;
          pos = jogador.mao.length - 1;
          chooseValue = true;
        }
      }

      else{
        for (int i = 0; i < jogador.mao.length; i++) {
          if (i != jogador.mao.length - 1)
            jogador.mao[i].move();
          else if (!jogador.mao[i].draw(jogador.mao.length) && !isPressed) {
            jogador.mao[i].isTurning = true;
            draw = false;
          }
        }
      } 
    }
    
    // Virada da carta
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

    // Renderizar cartas na tela
    for (var i = 0; i < jogador.mao.length; i++){
      jogador.mao[i].render(canvas);
    } 

    print('Temporizador = $timer');
  }

  @override
  Color backgroundColor() => const Color(0xFF062B06);
}
