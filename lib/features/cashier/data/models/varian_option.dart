class VariantOption {
  final String name;
  final int price;

  VariantOption({required this.name, required this.price});

  factory VariantOption.fromJson(Map<String, dynamic> json) {
    return VariantOption(
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
