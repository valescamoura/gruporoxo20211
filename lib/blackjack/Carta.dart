import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/Example.dart';
import 'package:flame/sprite.dart';

class Carta {
  // Atributos
  String naipe = "ClubsA";
  int valor;
  String url;
  double x;
  double y;
  double width = 75;
  bool isTurned = true; // true, quando carta está virada para baixo. false, caso contrário 
  late Sprite baralho;
  late Sprite cardBack;

  // Construtor
  Carta(this.naipe, this.valor,this.url, this.x, this.y);

  // Métodos

  void draw(){
    if (x <= 150){
      x += 1;
      y += 1;
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
    else if (width < 75){
      width += 8.5;
    }
    else{
      isTurned = false;
      width = 75;
    }
    print(width);
    print(x);
  }

  // Renderizando carta
  void render(Canvas c){
    c.save();
    //c.scale(width, width);
    if (isTurned){
      cardBack.renderRect(c, Rect.fromLTWH(x, y, width, 95));
    } else{
      baralho.renderRect(c, Rect.fromLTWH(x, y, width, 95));
    }  
    c.restore();
  }
}