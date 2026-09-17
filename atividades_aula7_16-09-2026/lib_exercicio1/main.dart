import 'package:flutter/material.dart';
import 'imagem_controle.dart';

void main() {
  runApp(const AppImagens());
}

class AppImagens extends StatelessWidget {
  const AppImagens({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(child: Principal()),
      ),
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
          const Text(
            'Galeria Wikipedia',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Image.network(
            controle.imagemAtual.url,
            width: 200,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              setState(() {
                controle.imagemAtual.mudaLike();
              });
            },
            child: Icon(
              controle.imagemAtual.liked
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 40,
              color: controle.imagemAtual.liked ? Colors.red : Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                controle.proximaImagem();
              });
            },
            child: const Text('Próxima Imagem'),
          ),
        ],
      ),
    );
  }
}
