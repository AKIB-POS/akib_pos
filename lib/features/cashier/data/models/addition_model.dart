import 'package:akib_pos/features/cashier/data/models/addition_option.dart';

class AdditionModel {
  final int id;
  final String additionType;
  final List<SubAddition> subAdditions;

  AdditionModel({
    required this.id,
    required this.additionType,
    required this.subAdditions,
  });

  factory AdditionModel.fromJson(Map<String, dynamic> json) {
    return AdditionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      additionType: json['addition_type'] ?? '',
      subAdditions: (json['sub_additions'] as List?)
              ?.map((x) => SubAddition.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addition_type': additionType,
      'sub_additions': subAdditions.map((x) => x.toJson()).toList(),
    };
  }
}

class SubAddition {
  final int id;
  final String? subAdditionType;
  final List<AdditionOption> options;

  SubAddition({
    required this.id,
    required this.subAdditionType,
    required this.options,
  });

  factory SubAddition.fromJson(Map<String, dynamic> json) {
    return SubAddition(
      id: (json['id'] as num?)?.toInt() ?? 0,
      subAdditionType: json['sub_addition_type'] ?? '',
      options: (json['options'] as List?)
              ?.map((x) => AdditionOption.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_addition_type': subAdditionType,
      'options': options.map((x) => x.toJson()).toList(),
    };
  }
}

class AdditionOption {
  final int id;
  final String name;
  final int price;

  AdditionOption({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AdditionOption.fromJson(Map<String, dynamic> json) {
    return AdditionOption(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
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
