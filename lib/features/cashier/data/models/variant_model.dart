import 'package:akib_pos/features/cashier/data/models/addition_model.dart';
import 'package:akib_pos/features/cashier/data/models/option_model.dart';

class VariantModel {
  final int id;
  final String variantType;
  final List<SubVariantModel> subVariants;

  VariantModel({
    required this.id,
    required this.variantType,
    required this.subVariants,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'],
      variantType: json['variant_type'],
      subVariants: (json['sub_variants'] as List)
          .map((i) => SubVariantModel.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_type': variantType,
      'sub_variants': subVariants.map((e) => e.toJson()).toList(),
    };
  }
}

class SubVariantModel {
  final int id;
  final String subVariantType;
  final List<OptionModel> options;

  SubVariantModel({
    required this.id,
    required this.subVariantType,
    required this.options,
  });

  factory SubVariantModel.fromJson(Map<String, dynamic> json) {
    return SubVariantModel(
      id: json['id'],
      subVariantType: json['sub_variant_type'],
      options: (json['options'] as List)
          .map((i) => OptionModel.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_variant_type': subVariantType,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}
