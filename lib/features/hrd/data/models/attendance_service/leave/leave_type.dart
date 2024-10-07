class LeaveType {
  final int id;
  final String name;

  LeaveType({
    required this.id,
    required this.name,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: (json['leave_type_id'] as num?)?.toInt() ?? 0,  // Safely cast to int and default to 0 if null
      name: json['leave_type_name'] ?? '',  // Default to an empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type_id': id,
      'leave_type_name': name,
    };
  }
}
