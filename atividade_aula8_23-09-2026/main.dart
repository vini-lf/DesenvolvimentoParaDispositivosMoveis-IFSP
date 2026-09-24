import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Avaliador de Imagens',
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<String> imagensPendentes = [
    'https://picsum.photos/id/237/200/300',
    'https://picsum.photos/id/1025/200/300',
    'https://picsum.photos/id/1062/200/300',
    'https://picsum.photos/id/1074/200/300',
  ];

  List<String> imagensAprovadas = [];

  Future<void> avaliarImagem(String url, BuildContext context) async {
    final bool? resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaAvaliacao(url: url)),
    );

    if (!context.mounted || resultado == null) return;

    setState(() {
      imagensPendentes.remove(url);
      if (resultado == true) {
        imagensAprovadas.add(url);
      }
    });
  }

  Widget carregarImagemSegura(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
            child: Icon(Icons.broken_image, color: Colors.grey, size: 40));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Galeria'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.image_search), text: 'Avaliar'),
              Tab(icon: Icon(Icons.check_circle), text: 'Aprovadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imagensPendentes.length,
              itemBuilder: (context, index) {
                final url = imagensPendentes[index];
                return GestureDetector(
                  onTap: () => avaliarImagem(url, context),
                  child: carregarImagemSegura(url),
                );
              },
            ),
            GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imagensAprovadas.length,
              itemBuilder: (context, index) {
                final url = imagensAprovadas[index];
                return carregarImagemSegura(url);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TelaAvaliacao extends StatelessWidget {
  final String url;

  const TelaAvaliacao({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avaliar Imagem')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.thumb_down, color: Colors.red),
                    label: const Text('Reprovar'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.thumb_up, color: Colors.green),
                    label: const Text('Aprovar'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
