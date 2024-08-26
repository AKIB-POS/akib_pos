class AdditionOption {
  final String name;
  final int price;

  AdditionOption({required this.name, required this.price});

  factory AdditionOption.fromJson(Map<String, dynamic> json) {
    return AdditionOption(
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
