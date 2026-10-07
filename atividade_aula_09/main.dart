import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Endereco {
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;

  const Endereco({
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'logradouro': String rua,
        'bairro': String bairro,
        'localidade': String cidade,
        'uf': String estado
      } =>
        Endereco(
          rua: rua,
          bairro: bairro,
          cidade: cidade,
          estado: estado,
        ),
      _ => throw const FormatException('Falha no carregamento...'),
    };
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controlador = TextEditingController();
  Future<Endereco>? enderecoFuturo;

  Future<Endereco> buscaEndereco() async {
    final resposta = await http.get(
      Uri.parse('https://viacep.com.br/ws/${controlador.text}/json/'),
    );

    if (resposta.statusCode == 200) {
      return Endereco.fromJson(
          jsonDecode(resposta.body) as Map<String, dynamic>);
    } else {
      throw Exception('Falha ao carregar endereço.');
    }
  }

  void salvar() {
    setState(() {
      enderecoFuturo = buscaEndereco();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Buscar CEP'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Digite o CEP!',
                    border: OutlineInputBorder(),
                  ),
                  controller: controlador,
                ),
              ),
              ElevatedButton(onPressed: salvar, child: const Text('Buscar')),
              if (enderecoFuturo != null)
                FutureBuilder<Endereco>(
                  future: enderecoFuturo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(snapshot.data!.rua),
                          Text(snapshot.data!.bairro),
                          Text(snapshot.data!.cidade),
                          Text(snapshot.data!.estado),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Text('Carregando...');
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
