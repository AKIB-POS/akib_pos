class RawMaterialType {
  final int rawMaterialId;
  final String rawMaterialName;

  RawMaterialType({
    required this.rawMaterialId,
    required this.rawMaterialName,
  });

  // Factory constructor for creating an instance from JSON
  factory RawMaterialType.fromJson(Map<String, dynamic> json) {
    return RawMaterialType(
      rawMaterialId: json['raw_material_id'],
      rawMaterialName: json['raw_material_name'],
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'raw_material_id': rawMaterialId,
      'raw_material_name': rawMaterialName,
    };
  }
}

class RawMaterialTypeResponse {
  final List<RawMaterialType> rawMaterials;

  RawMaterialTypeResponse({required this.rawMaterials});

  // Factory constructor for creating an instance from JSON
  factory RawMaterialTypeResponse.fromJson(Map<String, dynamic> json) {
    var materials = (json['data'] as List)
        .map((material) => RawMaterialType.fromJson(material))
        .toList();
    return RawMaterialTypeResponse(rawMaterials: materials);
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': rawMaterials.map((material) => material.toJson()).toList(),
    };
  }
}
