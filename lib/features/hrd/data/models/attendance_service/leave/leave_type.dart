class LeaveType {
  final int id;
  final String name;

  LeaveType({
    required this.id,
    required this.name
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['leave_type_id'],
      name: json['leave_type_name']
    );
  }

}
