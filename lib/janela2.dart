import 'package:flutter/material.dart';
import 'package:flutter_application_1/botao_resposta.dart';
import 'package:flutter_application_1/pergunta.dart';

class Janela2 extends StatelessWidget {
  const Janela2({
    super.key,
    required this.pergunta,
    required this.aoResponder,
  });

  final Pergunta pergunta;
  final void Function() aoResponder;

  @override
  Widget build(BuildContext context) {
    List<String> embaralhada = pergunta.Embaralha();

    final List<Color> cores = [
      const Color.fromARGB(255, 224, 55, 47),
      const Color.fromARGB(255, 13, 117, 181),
      const Color.fromARGB(255, 251, 176, 41),
      const Color.fromARGB(255, 121, 79, 129),
    ];

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/imagens/palhaco_ouve.png',
              ),
            ),
          ),
          Text(pergunta.texto),
          const SizedBox(
            height: 10,
          ),
          ...List.generate(embaralhada.length, (index) {
            return Column(
              children: [
                BotaoReposta(
                  cor: cores[index % cores.length],
                  textoResposta: embaralhada[index],
                  callResposta: aoResponder,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
