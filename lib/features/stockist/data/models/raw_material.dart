class RawMaterial {
  final int rawMaterialId; // Added raw_material_id field
  final String rawMaterialName;

  RawMaterial({
    required this.rawMaterialId, // Added rawMaterialId in constructor
    required this.rawMaterialName,
  });

  // Factory method for creating an instance from JSON
  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
      rawMaterialId: json['raw_material_id'] ?? 0, // Handling raw_material_id
      rawMaterialName: json['raw_material_name'] ?? '',
    );
  }

  // Method for converting the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'raw_material_id': rawMaterialId, // Added raw_material_id to JSON
      'raw_material_name': rawMaterialName,
    };
  }
}

class RawMaterialListResponse {
  final List<RawMaterial> rawMaterials;

  RawMaterialListResponse({required this.rawMaterials});

  factory RawMaterialListResponse.fromJson(Map<String, dynamic> json) {
    return RawMaterialListResponse(
      rawMaterials: (json['data'] as List)
          .map((item) => RawMaterial.fromJson(item))
          .toList(),
    );
  }

  // Method for converting the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': rawMaterials.map((material) => material.toJson()).toList(),
    };
  }
}
