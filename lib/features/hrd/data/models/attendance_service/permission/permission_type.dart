class PermissionType {
  final int id;
  final String name;

  PermissionType({
    required this.id,
    required this.name,
  });

  factory PermissionType.fromJson(Map<String, dynamic> json) {
    return PermissionType(
      id: json['permission_type_id'],
      name: json['permission_type_name'],
    );
  }
}
