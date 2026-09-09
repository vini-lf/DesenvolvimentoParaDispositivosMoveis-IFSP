import 'package:flutter/material.dart';
import 'package:flutter_application_1/janela1.dart';
import 'package:flutter_application_1/janela2.dart';
import 'package:flutter_application_1/questoes.dart';

void main() {
  runApp(
    Controle(),
  );
}

class Controle extends StatefulWidget {
  const Controle({super.key});

  @override
  State<Controle> createState() => _ControleState();
}

class _ControleState extends State<Controle> {
  var janela = 'um';
  int indiceQuestao = 0;

  void muda() {
    setState(() {
      janela = 'dois';
      indiceQuestao = 0;
    });
  }

  void responder() {
    setState(() {
      if (indiceQuestao < questoes.length - 1) {
        indiceQuestao++;
      } else {
        janela = 'um';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget atual = Janela1(muda);

    if (janela == 'um') {
      atual = Janela1(muda);
    } else {
      atual = Janela2(
        pergunta: questoes[indiceQuestao],
        aoResponder: responder,
      );
    }

    return MaterialApp(
      home: atual,
    );
  }
}
