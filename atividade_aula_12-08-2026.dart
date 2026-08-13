import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              JogoAdivinha(),
            ],
          ),
        ),
      ),
    );
  }
}

class JogoAdivinha extends StatefulWidget {
  const JogoAdivinha({super.key});

  @override
  State<JogoAdivinha> createState() => _JogoAdivinhaState();
}

int sorteado = Random().nextInt(5) + 1;
String resultado = "Escolha de 1 a 5";

class _JogoAdivinhaState extends State<JogoAdivinha> {
  void verificar(int numero) {
    setState(() {
      if (numero == sorteado) {
        resultado = "Acertou! O número era $sorteado";
      } else {
        resultado = "Errou! Escolheu $numero e era $sorteado";
      }
      sorteado = Random().nextInt(5) + 1;
    });
    print("Apertado: $numero");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          resultado,
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 28),
              ),
              onPressed: () {
                verificar(1);
              },
              child: const Text("1"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 28),
              ),
              onPressed: () {
                verificar(2);
              },
              child: const Text("2"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 28),
              ),
              onPressed: () {
                verificar(3);
              },
              child: const Text("3"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 28),
              ),
              onPressed: () {
                verificar(4);
              },
              child: const Text("4"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 28),
              ),
              onPressed: () {
                verificar(5);
              },
              child: const Text("5"),
            ),
          ],
        ),
      ],
    );
  }
}
