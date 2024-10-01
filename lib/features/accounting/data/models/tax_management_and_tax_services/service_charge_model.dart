class ServiceChargeModel {
  final double serviceChargePercentage;

  ServiceChargeModel({
    required this.serviceChargePercentage,
  });

  factory ServiceChargeModel.fromJson(Map<String, dynamic> json) {
    return ServiceChargeModel(
      serviceChargePercentage: (json['service_charge_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_charge_percentage': serviceChargePercentage,
    };
  }
}
