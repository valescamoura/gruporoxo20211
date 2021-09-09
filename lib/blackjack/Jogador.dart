import 'package:gruporoxo20211/blackjack/Carta.dart';

// Classe contendo as informações de cada um dos jogadores localmente

class Jogador {
  // Atributos
  List<Carta> mao; 
  int pontos;
 
  bool abaixou = false;
  bool estourou = false;

  // Construtor
  Jogador(this.mao, this.pontos);
}