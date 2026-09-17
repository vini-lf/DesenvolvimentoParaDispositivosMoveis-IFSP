import 'imagem_modelo.dart';

class ImagemControle {
  final List<ImagemModelo> imagens = [
    ImagemModelo(
        url:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/300px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg'),
    ImagemModelo(
        url:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Tour_Eiffel_Wikimedia_Commons.jpg/300px-Tour_Eiffel_Wikimedia_Commons.jpg'),
    ImagemModelo(
        url:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Colosseum_in_Rome-April_2007-1-_copie_2B.jpg/300px-Colosseum_in_Rome-April_2007-1-_copie_2B.jpg'),
    ImagemModelo(
        url:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Statue_of_Liberty_7.jpg/300px-Statue_of_Liberty_7.jpg'),
    ImagemModelo(
        url:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/The_Earth_seen_from_Apollo_17.jpg/300px-The_Earth_seen_from_Apollo_17.jpg'),
  ];

  int atual = 0;

  ImagemModelo get imagemAtual => imagens[atual];

  void proximaImagem() {
    // Se não for a última imagem, avança. Se for, volta para a primeira (0).
    if (atual < imagens.length - 1) {
      atual++;
    } else {
      atual = 0;
    }
  }
}
