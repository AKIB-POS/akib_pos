class Unit {
  final int unitId;
  final String unitName;

  Unit({required this.unitId, required this.unitName});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unitId: json['unit_id'] ?? 0,
      unitName: json['unit_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit_id': unitId,
      'unit_name': unitName,
    };
  }
}

class GetUnitsResponse {
  final List<Unit> units;

  GetUnitsResponse({required this.units});

  factory GetUnitsResponse.fromJson(Map<String, dynamic> json) {
    var units = (json['data'] as List)
        .map((unit) => Unit.fromJson(unit))
        .toList();
    return GetUnitsResponse(units: units);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': units.map((unit) => unit.toJson()).toList(),
    };
  }
}
