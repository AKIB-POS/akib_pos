class ServiceChargeModel {
  final double serviceChargePercentage;

  ServiceChargeModel({
    required this.serviceChargePercentage,
  });

  factory ServiceChargeModel.fromJson(Map<String, dynamic> json) {
    return ServiceChargeModel(
      serviceChargePercentage: json['service_charge_percentage'],
    );
  }
}
