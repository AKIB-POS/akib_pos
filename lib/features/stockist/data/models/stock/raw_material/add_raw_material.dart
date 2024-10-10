class AddRawMaterialRequest {
  final int branchId;
  final String name;
  final String category;

  AddRawMaterialRequest({
    required this.branchId,
    required this.name,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branchId,
      'name': name,
      'category': category,
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
