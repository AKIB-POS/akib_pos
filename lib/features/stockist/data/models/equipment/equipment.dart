class Equipment {
  final int id;
  final String name;

  Equipment({required this.id, required this.name});

  // Factory method to create an instance from JSON
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['equipment_id'],
      name: json['equipment_name'],
    );
  }
}

class EquipmentTypeResponse {
  final List<Equipment> equipmentList;

  EquipmentTypeResponse({required this.equipmentList});

  // Factory method to create an instance from JSON
  factory EquipmentTypeResponse.fromJson(Map<String, dynamic> json) {
    var list = (json['data'] as List)
        .map((equipment) => Equipment.fromJson(equipment))
        .toList();
    return EquipmentTypeResponse(equipmentList: list);
  }
}
