class PermissionType {
  final int id;
  final String name;

  PermissionType({
    required this.id,
    required this.name,
  });

  factory PermissionType.fromJson(Map<String, dynamic> json) {
    return PermissionType(
      id: json['id'],
      name: json['name'],
    );
  }
}
