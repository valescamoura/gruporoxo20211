import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/BlackJack.dart';
import 'package:gruporoxo20211/blackjack/SizeConfig.dart';

class Carta {
  // Atributos
  late String naipe;
  int valor;
  double x;
  double xAnt = 0;
  double y;
  double width = BlackJack.cardWidth;
  double height = BlackJack.cardHeight;
  bool isTurning = false; // true, quando a carta está virando. false, caso contrário
  bool isTurned = true; // true, quando carta está virada para baixo. false, caso contrário
  bool zoom = false;
  late Sprite baralho;
  late Sprite cardBack;

  // Atributos auxiliares
  var metadeDaTela = ((SizeConfig.screenWidth/2)-(BlackJack.cardWidth/2));
  var cardDivSeis= BlackJack.cardWidth/6;

  // Construtor
  Carta(this.naipe, this.valor, this.x, this.y);

  // Métodos

  // Armazena a posição da carta antes de deixar ela na posição central da tela para que no zoomOut ela volte na posição correta
  void zoomIn(){

    xAnt = x;
    x = ((SizeConfig.screenWidth/2) - (width/2));
    y = ((SizeConfig.screenHeight/2) - (height/2));
    zoom = true;

  }

  // Retorna todos os valores da carta para suas versões originais de quando estavam na mão do usuário
  void zoomOut(){

    width = width / 2;
    height = height / 2;
    x = xAnt;
    y = (SizeConfig.screenHeight/2) + (BlackJack.cardHeight/2) + (SizeConfig.blockSizeVertical*12);
    zoom = false;

  }

  // Movimentar as cartas na mão no eixo x ao comprar uma nova carta
  bool moveX(int quant){
    if (x <= (metadeDaTela + (cardDivSeis * (quant - 1)))) {
      // x foi velocidade escolhida na carta, quão mais rápido a carta se move
      x += ((metadeDaTela - (SizeConfig.blockSizeHorizontal * 5)) / 55) +
          (cardDivSeis * (quant - 1) / 55);
      return true;
    }
    return false;
  }

  // Comprar a carta: Mudar a posição dos eixos x e y da carta
  bool draw(int quant){

    var yFinal = (SizeConfig.screenHeight/2) + (BlackJack.cardHeight/2) + (SizeConfig.blockSizeVertical*12);

    // y é a velocidade escolhida para movimento da carta
    y += (yFinal -  (SizeConfig.blockSizeVertical*50) + (BlackJack.cardHeight/2))/55;

    if(!moveX(quant) && y >= yFinal -  ((SizeConfig.blockSizeVertical*50) + (BlackJack.cardHeight/2))/55) {
      y = yFinal;
      BlackJack.isPressed = false;
      return false;

    }
    return true;
  }

  // Compra de carta única para a escolha de valor do A
  bool drawA(){
    if (x <= (metadeDaTela + cardDivSeis )){
      // x foi velocidade escolhida na carta, quão mais rápido a carta se move
      x += ((metadeDaTela - (SizeConfig.blockSizeHorizontal*5))/55);
      return true;
    }
    return false;
  }

  // Comprar a carta oponente: Mudar a posição dos eixos x e y da carta
  bool drawOp(int quant){

    var yFinal = (SizeConfig.screenHeight/2) - (BlackJack.cardHeight/2) - (SizeConfig.blockSizeVertical*27);

    if (x <= (metadeDaTela + (cardDivSeis * (quant - 1)))){
      // x foi velocidade escolhida na carta, quão mais rápido a carta se move
      x += ((metadeDaTela - (SizeConfig.blockSizeHorizontal*5))/55) + (cardDivSeis * (quant - 1) / 55);

      // y é a velocidade escolhida para movimento da carta
      print((yFinal -  (SizeConfig.blockSizeVertical*50) + (BlackJack.cardHeight/2))/55);
      y += (yFinal -  (SizeConfig.blockSizeVertical*50) + (BlackJack.cardHeight/2))/55;

      if (y <= yFinal +  ((SizeConfig.blockSizeVertical*50) - (BlackJack.cardHeight/2))/55) {
        y = yFinal;
        BlackJack.isPressed = false;
      }
      return true;
    }
    return false;
  }

  // Movimentar no eixo X as cartas que já foram compradas
  void move() {
    x -= cardDivSeis/57;
  }

  // Virar carta: diminuir largura até 0, depois voltar até tamanho original da carta
  Future<void> turnCard() async {
    if (isTurned && width > 0){
      width -= 9;
    }
    else if (isTurned && width <= 0){
      isTurned = false;
    }
    else if (width < BlackJack.cardWidth){
      width += 9;
    }
    else{
      isTurned = false;
      width = BlackJack.cardWidth;
    }
  }

  // Renderizando carta
  void render(Canvas c){
    c.save();
    if (isTurned){
      cardBack.renderRect(c, Rect.fromLTWH(x, y, width, height));
    }
    else{
      baralho.renderRect(c, Rect.fromLTWH(x, y, width, height)); 
    }
    c.restore();
  }

  static Carta toCard(String naipe) {
    var valor;

    // Descobrir valor numérico da carta através dos últimos dígitos do naipe
    var variavelAux = naipe[0];
    switch(variavelAux) { 
      case 'A': { 
          valor = 1; 
      } 
      break; 
      
      case 'J': { 
          valor = 10;
      } 
      break;

      case 'Q': { 
          valor = 10;
      } 
      break; 

      case 'K': { 
          valor = 10;
      } 
      break; 

      case 'D': { 
          valor = 10;
      } 
      break;  
          
      default: { 
         valor = int.parse(variavelAux);
      }
      break; 
    }

    var carta = Carta(naipe, valor, BlackJack.deckPosition.x, BlackJack.deckPosition.y);
    carta.baralho = BlackJack.sprites[naipe];
    carta.cardBack = BlackJack.sprites['cardBack'];

    return carta;
  }

  // Comprar cartas
  static comprarCarta() {
    if (BlackJack.jogador.pontos >= 21) {
      BlackJack.jogador.estourou = true;
    }
    else{
      var naipe = 'AE';
      var carta  = toCard(naipe);
      BlackJack.jogador.mao.add(carta);

      //TODO: somar diferente quando for ás
      BlackJack.jogador.pontos += carta.valor;
    }
  }

  // Animar cartas compradas pelo adversário
  static animarCartasAdv() {
    // alguma comunicação com BD para saber se é necessário animar
  }

  // Virar cartas do adversário
  static virarCartasAdv() {

  }
}