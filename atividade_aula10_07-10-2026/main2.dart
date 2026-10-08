import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const EditorApp());
}

class EditorApp extends StatefulWidget {
  const EditorApp({super.key});

  @override
  State<EditorApp> createState() => _EditorAppState();
}

class _EditorAppState extends State<EditorApp> {
  TextEditingController controlador = TextEditingController();

  @override
  void initState() {
    super.initState();
    lerArquivo();
  }

  Future<String> get _pastaDocumentos async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _arquivo async {
    final caminho = await _pastaDocumentos;
    return File('$caminho/organiza.md');
  }

  void lerArquivo() async {
    try {
      final arquivo = await _arquivo;
      final conteudo = await arquivo.readAsString();
      setState(() {
        controlador.text = conteudo;
      });
    } catch (_) {
      setState(() {
        controlador.text = '';
      });
    }
  }

  void salvar() async {
    final arquivo = await _arquivo;
    await arquivo.writeAsString(controlador.text);
  }

  void apagar() async {
    final arquivo = await _arquivo;
    await arquivo.writeAsString('');
    setState(() {
      controlador.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Editor - organiza.md')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: controlador,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Escreva seu texto markdown aqui...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: salvar,
                    child: const Text('Salvar Arquivo'),
                  ),
                  ElevatedButton(
                    onPressed: apagar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apagar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
