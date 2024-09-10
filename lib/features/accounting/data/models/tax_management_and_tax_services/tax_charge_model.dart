class TaxChargeModel {
  final double taxChargePercentage;

  TaxChargeModel({required this.taxChargePercentage});

  factory TaxChargeModel.fromJson(Map<String, dynamic> json) {
    return TaxChargeModel(
      taxChargePercentage: json['tax_charge_percentage'] ?? 0,
    );
  }
}
