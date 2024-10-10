class AddEquipmentTypeRequest {
  final int branchId;
  final String name;
  final String category;

  AddEquipmentTypeRequest({
    required this.branchId,
    required this.name,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId.toString(),
      'name': name,
      'category': category,
    };
  }
}

class AddEquipmentTypeResponse {
  final String message;

  AddEquipmentTypeResponse({
    required this.message,
  });

  factory AddEquipmentTypeResponse.fromJson(Map<String, dynamic> json) {
    return AddEquipmentTypeResponse(
      message: json['message'],
    );
  }
}
