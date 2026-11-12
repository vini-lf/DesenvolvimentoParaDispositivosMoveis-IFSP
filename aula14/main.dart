import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(TwitterCloneApp());

class TwitterCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: JanelaInicial(),
    );
  }
}

class JanelaInicial extends StatefulWidget {
  @override
  _JanelaInicialState createState() => _JanelaInicialState();
}

class _JanelaInicialState extends State<JanelaInicial> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool isLogin = true;

  Future<void> acaoAutenticacao() async {
    if (isLogin) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _emailController.text);
      await prefs.setString('senha', _senhaController.text);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TelaPrincipal()));
    } else {
      final url = 'http://localhost/cadastro.php';
      final body = {
        'nome': _nomeController.text,
        'email': _emailController.text,
        'senha': _senhaController.text
      };

      final response = await http.post(Uri.parse(url), body: body);
      if (response.body.contains("sucesso")) {
        setState(() => isLogin = true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Cadastro realizado com sucesso! Faça o seu login.')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao cadastrar.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Cadastro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLogin)
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: acaoAutenticacao,
              child: Text(isLogin ? 'Entrar' : 'Cadastrar'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? 'Criar nova conta' : 'Já tenho conta'),
            )
          ],
        ),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final _textoController = TextEditingController();
  File? _foto;
  final ImagePicker _picker = ImagePicker();
  String _emailUsuario = "";
  List<dynamic> _feed = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado().then((_) => _carregarFeed());
  }

  Future<void> _carregarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailUsuario = prefs.getString('email') ?? "";
    });
  }

  Future<void> selecionarFoto() async {
    final XFile? fotoSelecionada =
        await _picker.pickImage(source: ImageSource.gallery);
    if (fotoSelecionada != null) {
      setState(() => _foto = File(fotoSelecionada.path));
    }
  }

  Future<void> _carregarFeed() async {
    if (_emailUsuario.isEmpty) return;
    final url = Uri.parse('http://localhost/feed.php?email=$_emailUsuario');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() => _feed = json.decode(response.body));
    }
  }

  Future<void> fazerPostagem() async {
    if (_textoController.text.isEmpty && _foto == null) return;
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://localhost/postagem.php'));
    request.fields['email'] = _emailUsuario;
    request.fields['texto'] = _textoController.text;
    if (_foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', _foto!.path));
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        _textoController.clear();
        _foto = null;
      });
      _carregarFeed();
    }
  }

  Future<void> _enviarAcao(Map<String, String> dados) async {
    await http.post(Uri.parse('http://localhost/interacao.php'), body: dados);
    _carregarFeed();
  }

  void curtir(String postId) {
    _enviarAcao(
        {'acao': 'curtir', 'postagem_id': postId, 'email': _emailUsuario});
  }

  void solicitarAmizade(String autorPost) {
    _enviarAcao({
      'acao': 'solicitar_amizade',
      'email_solicitante': _emailUsuario,
      'email_solicitado': autorPost
    });
  }

  void aceitarAmizade(String solicitante) {
    _enviarAcao({
      'acao': 'aceitar_amizade',
      'email_solicitante': solicitante,
      'email_solicitado': _emailUsuario
    });
  }

  void comentar(String postId, String texto) {
    if (texto.isEmpty) return;
    _enviarAcao({
      'acao': 'comentar',
      'postagem_id': postId,
      'email_autor': _emailUsuario,
      'texto': texto
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed - $_emailUsuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => JanelaInicial())),
          )
        ],
      ),
      body: Column(
        children: [
          // Área de Postagem
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                    controller: _textoController,
                    decoration: InputDecoration(
                        labelText: 'O que está a acontecer?',
                        border: OutlineInputBorder()),
                    maxLines: 2),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.photo, color: Colors.blue),
                        onPressed: selecionarFoto),
                    Text(_foto != null ? 'Foto anexada' : ''),
                    Spacer(),
                    ElevatedButton(
                        onPressed: fazerPostagem, child: Text('Postar')),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 2),

          // Feed
          Expanded(
            child: ListView.builder(
              itemCount: _feed.length,
              itemBuilder: (context, index) {
                final post = _feed[index];
                final postId = post['id'].toString();
                final bool euCurti = post['eu_curti'];
                final String statusAmizade = post['status_amizade'] ?? '';
                final autorPost = post['email'];
                TextEditingController comentarioController =
                    TextEditingController();

                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(autorPost,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                        SizedBox(height: 5),
                        if (post['texto'] != null && post['texto'].isNotEmpty)
                          Text(post['texto']),
                        if (post['foto_caminho'] != null &&
                            post['foto_caminho'].isNotEmpty)
                          Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Image.network(
                                  'http://localhost/${post['foto_caminho']}')),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                  euCurti
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: euCurti ? Colors.red : Colors.grey),
                              onPressed: () => curtir(postId),
                            ),
                            Text('${post['total_curtidas']}'),
                            Spacer(),
                            if (statusAmizade == '')
                              TextButton(
                                  onPressed: () => solicitarAmizade(autorPost),
                                  child: Text("Solicitar Amizade")),
                            if (statusAmizade == 'pendente' &&
                                post['quem_solicitou'] == _emailUsuario)
                              Text("Pedido Pendente",
                                  style: TextStyle(color: Colors.orange)),
                            if (statusAmizade == 'pendente' &&
                                post['quem_solicitou'] != _emailUsuario)
                              TextButton(
                                  onPressed: () =>
                                      aceitarAmizade(post['quem_solicitou']),
                                  child: Text("Aceitar Amizade",
                                      style: TextStyle(color: Colors.green))),
                            if (statusAmizade == 'aceito')
                              Text("Amigos",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Divider(),
                        if (post['comentarios'].isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: (post['comentarios'] as List)
                                .map((c) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      child: Text(
                                          '${c['email_autor']}: ${c['texto']}',
                                          style: TextStyle(fontSize: 13)),
                                    ))
                                .toList(),
                          ),
                        if (statusAmizade == 'aceito' ||
                            statusAmizade == 'proprio')
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: comentarioController,
                                  decoration: InputDecoration(
                                      hintText: "Adicionar comentário...",
                                      isDense: true),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send, color: Colors.blue),
                                onPressed: () =>
                                    comentar(postId, comentarioController.text),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TelaBusca extends StatefulWidget {
  @override
  _TelaBuscaState createState() => _TelaBuscaState();
}

class _TelaBuscaState extends State<TelaBusca> {
  final TextEditingController _buscaController = TextEditingController();
  String _tipoBusca = 'postagem'; // 'pessoa' ou 'postagem'
  List<dynamic> _resultados = [];

  Future<void> realizarBusca() async {
    final termo = _buscaController.text;
    if (termo.isEmpty) return;

    final url =
        Uri.parse('http://localhost/busca.php?termo=$termo&tipo=$_tipoBusca');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _resultados = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Busca')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscaController,
                    decoration: InputDecoration(
                      labelText: 'Pesquisar...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, size: 30, color: Colors.blue),
                  onPressed: realizarBusca,
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'postagem',
                  groupValue: _tipoBusca,
                  onChanged: (value) => setState(() => _tipoBusca = value!),
                ),
                Text('Postagens'),
                Radio<String>(
                  value: 'pessoa',
                  groupValue: _tipoBusca,
                  onChanged: (value) => setState(() => _tipoBusca = value!),
                ),
                Text('Pessoas'),
              ],
            ),
            Divider(),
            Expanded(
              child: _resultados.isEmpty
                  ? Center(child: Text("Sem resultados."))
                  : ListView.builder(
                      itemCount: _resultados.length,
                      itemBuilder: (context, index) {
                        final item = _resultados[index];
                        if (_tipoBusca == 'pessoa') {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text(item['nome'] ?? 'Sem nome'),
                            subtitle: Text(item['email']),
                          );
                        } else {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(item['email'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(item['texto']),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
