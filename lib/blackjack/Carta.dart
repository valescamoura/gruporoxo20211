import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/BlackJack.dart';
import 'package:gruporoxo20211/blackjack/SizeConfig.dart';

// Classe com os atributos e métodos relacionados a carta que é utilizada
// durante a partida

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

  // Comprar a carta oponente: Mudar a posição dos eixos x e y da carta
  bool drawAdv(int quant){

    var yFinal = (SizeConfig.screenHeight/2) - (BlackJack.cardHeight/2) - (SizeConfig.blockSizeVertical*27);

    // y é a velocidade escolhida para movimento da carta
    y += (yFinal -  (SizeConfig.blockSizeVertical*50) + (BlackJack.cardHeight/2))/55;

    if(!moveX(quant) && y <= yFinal -  ((SizeConfig.blockSizeVertical*50) + (BlackJack.cardHeight/2))/55) {
      y = yFinal;
      return false;

    }
    return true;
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

    // Descobrir valor numérico da carta através do primeiro dígito do naipe
    var variavelAux = naipe[0];
    switch(variavelAux) { 
      case 'A': { 
          valor = 11; 
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
  static comprarCarta(String naipe) {
    // Criar objeto carta a partir da string do naipe
    var carta  = toCard(naipe);
    // Somar pontos à mão do jogador
    BlackJack.jogador.pontos += carta.valor;
    // Adicionar carta à mão do jogador
    BlackJack.jogador.mao.add(carta); 
  }

  // Animar cartas compradas pelo adversário
  static animarCartasAdv() {
    for (int i = 0; i < BlackJack.adversario.mao.length; i++) {
      if (i != BlackJack.adversario.mao.length - 1)
        BlackJack.adversario.mao[i].move();
      else if (!BlackJack.adversario.mao[i].drawAdv(BlackJack.adversario.mao.length)) {
        BlackJack.cardAdv = false;
      }
    }
  }

  // Virar cartas do adversário
  static virarCartasAdv() {
    if (BlackJack.adversario.mao.length > 0){
      BlackJack.adversario.mao[BlackJack.adversario.mao.length - 1].isTurning = true;
      for (int i = BlackJack.adversario.mao.length - 1; i >= 0; i --){
        BlackJack.adversario.mao[i].isTurning = true;
        BlackJack.adversario.mao[i].turnCard();
        if (BlackJack.adversario.mao[i].isTurned)
          break;
      }
    }
  }
}