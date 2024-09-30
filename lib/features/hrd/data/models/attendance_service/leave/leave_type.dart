class LeaveType {
  final int id;
  final String name;
  final int quota;
  final String type;

  LeaveType({
    required this.id,
    required this.name,
    required this.quota,
    required this.type,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json['name'],
      quota: json['quota'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quota': quota,
      'type': type,
    };
  }
}
