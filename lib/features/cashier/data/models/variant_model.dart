

class VariantModel {
  int id;
  String variantType;
  List<SubVariant> subVariants;

  VariantModel({
    required this.id,
    required this.variantType,
    required this.subVariants,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'],
      variantType: json['variant_type'],
      subVariants: List<SubVariant>.from(json['sub_variants'].map((x) => SubVariant.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_type': variantType,
      'sub_variants': List<dynamic>.from(subVariants.map((x) => x.toJson())),
    };
  }
}

class SubVariant {
  int id;
  String subVariantType;
  List<VariantOption> options;

  SubVariant({
    required this.id,
    required this.subVariantType,
    required this.options,
  });

  factory SubVariant.fromJson(Map<String, dynamic> json) {
    return SubVariant(
      id: json['id'],
      subVariantType: json['sub_variant_type'],
      options: List<VariantOption>.from(json['options'].map((x) => VariantOption.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_variant_type': subVariantType,
      'options': List<dynamic>.from(options.map((x) => x.toJson())),
    };
  }
}

class VariantOption {
  int id;
  String name;
  int price;

  VariantOption({
    required this.id,
    required this.name,
    required this.price,
  });

  factory VariantOption.fromJson(Map<String, dynamic> json) {
    return VariantOption(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
