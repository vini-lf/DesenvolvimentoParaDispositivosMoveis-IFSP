void main() {
  String nome = 'Camiseta ADS';
  int quantidade = 3;
  double preco = 49.90;
  bool disponivel = true;
  const imposto = 5.0;
  
  double precoTotal = ((quantidade*preco) * (1+imposto/100));
  
  print("Produto: " + nome);
  print("Disponível em estoque: " + disponivel.toString());
  print("Quantidade: " + quantidade.toString());
  print("Preço unitário: " + preco.toString());
  print("Valor total: R\$" + precoTotal.toString());
}
