class TaxChargeModel {
  final double taxChargePercentage;

  TaxChargeModel({
    required this.taxChargePercentage,
  });

  factory TaxChargeModel.fromJson(Map<String, dynamic> json) {
    return TaxChargeModel(
      taxChargePercentage: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': taxChargePercentage,
    };
  }
}
