import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const JanelaTabuada());
}

class JanelaTabuada extends StatelessWidget {
  const JanelaTabuada({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(child: PrincipalTabuada()),
      ),
    );
  }
}

class PrincipalTabuada extends StatefulWidget {
  const PrincipalTabuada({super.key});

  @override
  State<PrincipalTabuada> createState() => _PrincipalTabuadaState();
}

class _PrincipalTabuadaState extends State<PrincipalTabuada> {
  int fator1 = 5;
  int fator2 = 4;

  String textoDigitado = '';

  final controlaTexto = TextEditingController();

  void sortearNovaOperacao() {
    setState(() {
      fator1 = Random().nextInt(10) + 1;
      fator2 = Random().nextInt(10) + 1;
      textoDigitado = '';
      controlaTexto.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    int resultadoCorreto = fator1 * fator2;

    bool acertou = textoDigitado == resultadoCorreto.toString();

    bool digitouAlgo = textoDigitado.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Resolva a operação:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Text(
            '$fator1 x $fator2',
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: controlaTexto,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Sua resposta',
              suffixIcon: digitouAlgo
                  ? Icon(
                      acertou ? Icons.check_circle : Icons.cancel,
                      color: acertou ? Colors.green : Colors.red,
                    )
                  : null,
            ),
            onChanged: (valor) {
              setState(() {
                textoDigitado = valor;
              });
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: sortearNovaOperacao,
            child: const Text('Nova Operação'),
          ),
        ],
      ),
    );
  }
}
