import 'package:flutter/material.dart';
import 'imagem_controle.dart';

void main() {
  runApp(const Janela());
}

class Janela extends StatelessWidget {
  const Janela({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Principal()),
    );
  }
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  ImagemControle controle = ImagemControle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            controle.imagemAtual.url,
            width: 200,
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: Icon(
              controle.imagemAtual.like
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: controle.imagemAtual.like ? Colors.red : Colors.grey,
              size: 32,
            ),
            onPressed: () {
              setState(() {
                controle.curtirImagem();
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  controle.proximaImagem();
                });
              },
              child: const Text('Próxima'))
        ],
      ),
    );
  }
}
