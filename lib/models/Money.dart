// ignore_for_file: file_names, non_constant_identifier_names

class Money {
  final String? title, image, type;

  Money({this.title, this.image, this.type});
}

List<Money> demo_moneys = [
  Money(title: "200", type: "Reais", image: "assets/images/money/200reais.jpg"),
  Money(title: "100", type: "Reais", image: "assets/images/money/100reais.jpg"),
  Money(title: "50", type: "Reais", image: "assets/images/money/50reais.jpg"),
  Money(title: "20", type: "Reais", image: "assets/images/money/20reais.jpg"),
  Money(title: "10", type: "Reais", image: "assets/images/money/10reais.jpg"),
  Money(title: "05", type: "Reais", image: "assets/images/money/5reais.jpg"),
  Money(title: "02", type: "Reais", image: "assets/images/money/2reais.jpg"),
  Money(title: "01", type: "Real", image: "assets/images/money/1real.png"),
  Money(
      title: "0.50",
      type: "Centavos",
      image: "assets/images/money/50cents.png"),
  Money(
      title: "0.25",
      type: "Centavos",
      image: "assets/images/money/25cents.png"),
  Money(
      title: "0.10",
      type: "Centavos",
      image: "assets/images/money/10cents.png"),
  Money(
      title: "0.05", type: "Centavos", image: "assets/images/money/5cents.png"),
];
