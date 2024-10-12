class EquipmentDetail {
  final String equipmentName;
  final String equipmentCode;
  final String quantity;
  final double averagePrice;

  EquipmentDetail({
    required this.equipmentName,
    required this.equipmentCode,
    required this.quantity,
    required this.averagePrice,
  });

  factory EquipmentDetail.fromJson(Map<String, dynamic> json) {
    return EquipmentDetail(
      equipmentName: json['equipment_name'] ?? '',
      equipmentCode: json['equipment_code'] ?? '',
      quantity: json['quantity'] ?? '',
      averagePrice: (json['average_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipment_name': equipmentName,
      'equipment_code': equipmentCode,
      'quantity': quantity,
      'average_price': averagePrice,
    };
  }
}
class EquipmentDetailResponse {
  final EquipmentDetail equipmentDetail;

  EquipmentDetailResponse({required this.equipmentDetail});

  factory EquipmentDetailResponse.fromJson(Map<String, dynamic> json) {
    return EquipmentDetailResponse(
      equipmentDetail: EquipmentDetail.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': equipmentDetail.toJson(),
    };
  }
}
