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
      id: json['id'] ?? 0,
      additionType: json['addition_type'] ?? '',
      subAdditions: List<SubAddition>.from(
          json['sub_additions'].map((x) => SubAddition.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addition_type': additionType,
      'sub_additions': List<dynamic>.from(subAdditions.map((x) => x.toJson())),
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
      id: json['id'] ?? 0,
      subAdditionType: json['sub_addition_type'] ?? '',
      options: List<AdditionOption>.from(
          json['options'].map((x) => AdditionOption.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_addition_type': subAdditionType,
      'options': List<dynamic>.from(options.map((x) => x.toJson())),
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
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
