import 'package:flutter/material.dart';

//-----------------------------------
//Página de Regras, usada pra mostrar ao usuário como funciona o jogo
class GameRulesPage extends StatelessWidget {
  const GameRulesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Regras do Jogo',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFAD200C),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFF062B06),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 20.0),
                        child: Text("BlackJack 21",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)))),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFFAD200C),
                      ),
                      padding: EdgeInsets.only(top: 10.0),
                      width: 120,
                      height: 100,
                      child: Column(
                        children: [
                          Text("2",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                          Text("Jogadores",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Image.asset(
                                "assets/images/imageTwoPeople.png",
                                width: 35,
                                height: 35),
                          )
                        ],
                      ),
                    )),
                Row(children: [
                  Image.asset(
                    "assets/images/imageGoal.png",
                    width: 50,
                    height: 50,
                  ),
                  Text("Objetivo do Jogo: ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold))
                ]),
                Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                        "Alcançar 21 ou chegar o mais próximo possível de 21 sem ultrapassar esse número. Caso o jogador ultrapasse 21, então ele perde a rodada.",
                        style: TextStyle(color: Colors.white, fontSize: 18.0))),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 20.0),
                        child: Text("Valor das cartas: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)))),
                Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 10.0),
                    child: Column(children: [
                      Row(children: [
                        Image.asset(
                          'assets/images/imageCards2to10.png',
                          width: 150,
                          height: 80,
                        ),
                        Padding(padding: EdgeInsets.only(right: 10.0)),
                        Expanded(
                            child: Text(
                                "Cartas de 2 a 10 tem o valor correspondente.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0))),
                      ]),
                      Row(
                        children: [
                          Image.asset('assets/images/imageCardsJQK.png',
                              width: 80, height: 80),
                          Padding(padding: EdgeInsets.only(right: 10.0)),
                          Text("J, Q e K valem 10 pontos.",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset('assets/images/imageCardA.png',
                              width: 80, height: 80),
                          Padding(padding: EdgeInsets.only(right: 5.0)),
                          Expanded(
                              child: Text("O Ás vale 11 pontos.",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0))),
                        ],
                      ),
                    ])),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(children: [
                      Image.asset(
                        "assets/images/imageRules.png",
                        width: 50,
                        height: 50,
                      ),
                      Text("Regras: ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold))
                    ])),
                Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 50.0),
                    child: Text(
                        "Cada jogador pode clicar em cima do baralho para comprar cartas, e quando clicar no botão"
                        " 'Abaixar' indica que acabou suas jogadas e não pretende comprar mais nenhuma carta. "
                        "Porém o jogador só consegue abaixar a mão se possuir no mínimo 16 pontos. "
                        "Caso complete 21 pontos o jogador não consegue mais comprar cartas no baralho e o sistema "
                        "do jogo 'Abaixa' automaticamente a mão do jogador. Caso ambos os jogadores tenham valores "
                        "abaixo de 16 pontos é decretado empate, já que as regras do Blackjack não permite ganhador "
                        "com valores abaixo de 16 pontos. Caso ambos os jogadores tenham a mesma soma de valores nas "
                        "cartas viradas é decretado o empate também, ou caso ambos tenham valores maiores do que 21. \nO jogador "
                        "não sabe quando o oponente abaixou as cartas, mas assim que ambos abaixam as cartas são viradas "
                        "para cima na mesa, revelando seus valores e é anunciado o vencedor que atingiu 21 ou que chegou mais próximo de 21. "
                        "Os jogadores possuem 3 minutos para terminar a partida, caso o limite de tempo seja excedito sem os jogadores terem clicado "
                        "no botão 'Abaixar' o sistema abaixará automaticamente as mãos e fará o calculo das pontuações para declarar a vitória ou derrota"
                        " de um jogador ou empate.",
                        style: TextStyle(color: Colors.white, fontSize: 18.0)))
              ],
            ),
          ),
        ));
  }
}
