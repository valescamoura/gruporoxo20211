import 'package:gruporoxo20211/blackjack/Carta.dart';

class Jogador {
  // Atributos
  List<Carta> mao; 
  int pontos;
 
  bool abaixou = false;
  bool estourou = false;

  // Construtor
  Jogador(this.mao, this.pontos);
}