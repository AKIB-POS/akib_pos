import 'package:akib_pos/features/cashier/data/models/addition_option.dart';

class AdditionModel {
  int id;
  String additionType;
  List<SubAddition> subAdditions;

  AdditionModel({
    required this.id,
    required this.additionType,
    required this.subAdditions,
  });

  factory AdditionModel.fromJson(Map<String, dynamic> json) {
    return AdditionModel(
      id: json['id'],
      additionType: json['addition_type'],
      subAdditions: List<SubAddition>.from(json['sub_additions'].map((x) => SubAddition.fromJson(x))),
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
  int id;
  String subAdditionType;
  List<AdditionOption> options;

  SubAddition({
    required this.id,
    required this.subAdditionType,
    required this.options,
  });

  factory SubAddition.fromJson(Map<String, dynamic> json) {
    return SubAddition(
      id: json['id'],
      subAdditionType: json['sub_addition_type'],
      options: List<AdditionOption>.from(json['options'].map((x) => AdditionOption.fromJson(x))),
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
  int id;
  String name;
  int price;

  AdditionOption({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AdditionOption.fromJson(Map<String, dynamic> json) {
    return AdditionOption(
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
