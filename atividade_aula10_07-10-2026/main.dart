import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController controladorCep = TextEditingController();
  TextEditingController controladorNumero = TextEditingController();

  String dadosSalvos = '';
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final rua = prefs.getString('rua');
    final bairro = prefs.getString('bairro');
    final cidade = prefs.getString('cidade');
    final estado = prefs.getString('estado');
    final numero = prefs.getString('numero');

    setState(() {
      if (rua != null && rua.isNotEmpty) {
        dadosSalvos =
            'Rua: $rua, $numero\nBairro: $bairro\nCidade: $cidade - $estado';
      } else {
        dadosSalvos = 'Nenhum endereço salvo.';
      }
    });
  }

  Future<void> buscarESalvar() async {
    setState(() {
      carregando = true;
    });

    try {
      final resposta = await http.get(
        Uri.parse('https://viacep.com.br/ws/${controladorCep.text}/json/'),
      );

      if (resposta.statusCode == 200) {
        final endereco = Endereco.fromJson(
            jsonDecode(resposta.body) as Map<String, dynamic>);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('rua', endereco.rua);
        await prefs.setString('bairro', endereco.bairro);
        await prefs.setString('cidade', endereco.cidade);
        await prefs.setString('estado', endereco.estado);
        await prefs.setString('numero', controladorNumero.text);

        carregarDados();
      } else {
        setState(() {
          dadosSalvos = 'Falha ao carregar endereço.';
        });
      }
    } catch (e) {
      setState(() {
        dadosSalvos = 'Erro ao buscar o CEP.';
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }

  void apagarDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    carregarDados();
    controladorCep.clear();
    controladorNumero.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Busca e Salvamento de CEP')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Endereço Salvo:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Text(
                  dadosSalvos,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Digite o CEP (somente números)',
                    border: OutlineInputBorder(),
                    labelText: 'CEP',
                  ),
                  keyboardType: TextInputType.number,
                  controller: controladorCep,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Digite o número da casa',
                    border: OutlineInputBorder(),
                    labelText: 'Número',
                  ),
                  keyboardType: TextInputType.number,
                  controller: controladorNumero,
                ),
                const SizedBox(height: 20),
                carregando
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: buscarESalvar,
                            child: const Text('Buscar e Salvar'),
                          ),
                          ElevatedButton(
                            onPressed: apagarDados,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white),
                            child: const Text('Apagar Dados'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
