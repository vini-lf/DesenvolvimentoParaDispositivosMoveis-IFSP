import 'imagem_modelo.dart';

class ImagemControle {
  final List<ImagemModelo> imagens = [
    ImagemModelo(url: 'https://picsum.photos/id/1018/200/250'), // Natureza
    ImagemModelo(url: 'https://picsum.photos/id/1015/200/250'), // Rio
    ImagemModelo(url: 'https://picsum.photos/id/1019/200/250'), // Paisagem
    ImagemModelo(url: 'https://picsum.photos/id/1016/200/250'), // Montanhas
    ImagemModelo(url: 'https://picsum.photos/id/1025/200/250'), // Cachorro
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
