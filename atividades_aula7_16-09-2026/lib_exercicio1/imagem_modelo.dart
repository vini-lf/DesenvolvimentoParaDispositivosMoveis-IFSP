class ImagemModelo {
  final String url;
  bool liked;

  ImagemModelo({required this.url, this.liked = false});

  void mudaLike() {
    liked = !liked;
  }
}
