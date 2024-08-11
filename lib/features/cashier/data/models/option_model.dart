class OptionModel {
  final String name;
  final String price;

  OptionModel({
    required this.name,
    required this.price,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
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
