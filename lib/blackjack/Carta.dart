import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';


class Carta {
  // Atributos
  String naipe;
  int valor;
  String url;
  double x;
  double y;
  late Sprite baralho;

  // Construtor
  Carta(this.naipe, this.valor,this.url, this.x, this.y);

  // Métodos

  void draw(){
    if (x <= 150){
      x += 1;
      y += 1;
    }
  }

  void render(Canvas c){
    baralho.renderRect(c,Rect.fromLTWH(x, y, 100, 200));
  }

}