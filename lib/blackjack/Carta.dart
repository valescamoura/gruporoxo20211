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
  double width = 1;
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
      width -= 0.05;
    }
    else if (isTurned && width < 0){
      isTurned = false;
    }
    else if (width < 1){
      width += 0.05;
    }
    else{
      isTurned = false;
    }
  }

  // Renderizando carta
  void render(Canvas c){
    c.save();
    c.scale(width, 1);
    if (isTurned){
      cardBack.renderRect(c, Rect.fromLTWH(x, y, 140, 190));
    } else{
      baralho.renderRect(c, Rect.fromLTWH(x, y, 140, 190));
    }  
    c.restore();
  }
}