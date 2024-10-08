class RawMaterial {
  final String rawMaterialName;

  RawMaterial({required this.rawMaterialName});

  // Factory method for creating an instance from JSON
  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
      rawMaterialName: json['raw_material_name'] ?? '',
    );
  }

  // Method for converting the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'raw_material_name': rawMaterialName,
    };
  }
}

class RawMaterialListResponse {
  final List<RawMaterial> rawMaterials;

  RawMaterialListResponse({required this.rawMaterials});

  // Factory method for creating an instance from JSON
  factory RawMaterialListResponse.fromJson(Map<String, dynamic> json) {
    var rawMaterials = (json['data'] as List)
        .map((material) => RawMaterial.fromJson(material))
        .toList();
    return RawMaterialListResponse(rawMaterials: rawMaterials);
  }

  // Method for converting the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': rawMaterials.map((material) => material.toJson()).toList(),
    };
  }
}
