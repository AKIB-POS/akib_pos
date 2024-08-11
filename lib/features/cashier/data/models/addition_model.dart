import 'package:akib_pos/features/cashier/data/models/option_model.dart';

class AdditionModel {
  final int id;
  final String additionType;
  final List<SubAdditionModel> subAdditions;

  AdditionModel({
    required this.id,
    required this.additionType,
    required this.subAdditions,
  });

  factory AdditionModel.fromJson(Map<String, dynamic> json) {
    return AdditionModel(
      id: json['id'],
      additionType: json['addition_type'],
      subAdditions: (json['sub_additions'] as List)
          .map((i) => SubAdditionModel.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addition_type': additionType,
      'sub_additions': subAdditions.map((e) => e.toJson()).toList(),
    };
  }
}

class SubAdditionModel {
  final int id;
  final String subAdditionType;
  final List<OptionModel> options;

  SubAdditionModel({
    required this.id,
    required this.subAdditionType,
    required this.options,
  });

  factory SubAdditionModel.fromJson(Map<String, dynamic> json) {
    return SubAdditionModel(
      id: json['id'],
      subAdditionType: json['sub_addition_type'],
      options: (json['options'] as List)
          .map((i) => OptionModel.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_addition_type': subAdditionType,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

