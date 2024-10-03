class OvertimeType {
  final int id;
  final String name;

  OvertimeType({
    required this.id,
    required this.name,
  });

  factory OvertimeType.fromJson(Map<String, dynamic> json) {
    return OvertimeType(
      id: json['overtime_type_id'] ?? 0,
      name: json['overtime_type_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overtime_type_id': id,
      'overtime_type_name': name,
    };
  }
}
