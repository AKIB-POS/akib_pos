class ServiceChargeModel {
  final double serviceChargePercentage;

  ServiceChargeModel({
    required this.serviceChargePercentage,
  });

  factory ServiceChargeModel.fromJson(Map<String, dynamic> json) {
    return ServiceChargeModel(
      serviceChargePercentage: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': serviceChargePercentage,
    };
  }
}
