import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/BlackJack.dart';

class Carta {
  // Atributos
  String naipe = "ClubsA";
  int valor;
  double x;
  double y;
  double width = BlackJack.cardWidth;
  double height = BlackJack.cardHeight;
  bool isTurned = true; // true, quando carta está virada para baixo. false, caso contrário 
  late Sprite baralho;
  late Sprite cardBack;

  // Construtor
  Carta(this.naipe, this.valor, this.x, this.y);

  // Métodos

  // Comprar a carta: Mudar a posição dos eixos x e y da carta
  bool draw(int quant){
    if (x <= (165 + (20 * (quant - 1)))){
      x += 3 + (20 * (quant - 1) / 165/3);
      y += 4;
      if (y >= 576)
        y = 576;
      return true;
    }
    return false;
  }

  // Comprar a carta oponente: Mudar a posição dos eixos x e y da carta
  bool drawOp(int quant){
    if (x <= (165 + (20 * (quant - 1)))){
      x += 3 + (20 * (quant - 1) / 55);
      y -= 4;
      if (y <= 140)
        y = 140;
      return true;
    }
    return false;
  }

  // Movimentar no eixo X as cartas que já foram compradas
  void move(int quant) {
    {
      x -= 0.36;
    }
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
    // alguma comunicação com BD para comprar carta

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