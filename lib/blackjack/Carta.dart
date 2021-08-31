import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/BlackJack.dart';
import 'package:gruporoxo20211/blackjack/SizeConfig.dart';

class Carta {
  // Atributos
  String naipe = "ClubsA";
  int valor;
  double x;
  double y;
  double width = BlackJack.cardWidth;
  double height = BlackJack.cardHeight;
  bool isTurning = false;
  bool isTurned = true; // true, quando carta está virada para baixo. false, caso contrário 
  late Sprite baralho;
  late Sprite cardBack;
  var metadeDaTela = ((SizeConfig.screenWidth/2)-(BlackJack.cardWidth/2));
  var cardDivSeis= BlackJack.cardWidth/6;

  // Construtor
  Carta(this.naipe, this.valor, this.x, this.y);

  // Métodos

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

  // Virar carta: diminuir largura até 0, depois voltar até 1
  Future<void> turnCard() async {
    if (isTurned && width > 0){
      width -= 8.5;
    }
    else if (isTurned && width <= 0){
      isTurned = false;
    }
    else if (width < BlackJack.cardWidth){
      width += 8.5;
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

  // Comprar cartas
  static Carta comprarCarta() {
    var naipe = 'AE';
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
    BlackJack.jogador.mao.add(carta);
    return carta;
  }
}