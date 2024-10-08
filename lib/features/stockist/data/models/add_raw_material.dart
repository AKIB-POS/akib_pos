class AddRawMaterialRequest {
  final int branchId;
  final String rawMaterialName;

  AddRawMaterialRequest({required this.branchId, required this.rawMaterialName});

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'raw_material_name': rawMaterialName,
    };
  }
}

class AddRawMaterialResponse {
  final String message;

  AddRawMaterialResponse({required this.message});

  factory AddRawMaterialResponse.fromJson(Map<String, dynamic> json) {
    return AddRawMaterialResponse(
      message: json['message'] ?? '',
    );
  }
}
