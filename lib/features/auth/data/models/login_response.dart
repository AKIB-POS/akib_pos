class LoginResponse {
  final String token;
  final int id;
  final int companyId;
  final String companyName;
  final int branchId;
  final String? email;
  final String? role;
  final String employeeName;
  final List<String> permissions;

  LoginResponse({
    required this.token,
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.branchId,
    this.email,
    this.role,
    required this.employeeName,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      companyId: json['company_id'],
      companyName: json['company_name'],
      branchId: json['branch_id'],
      role: json['role'],
      employeeName: json['employee_name'],
      permissions: List.from(json['permissions']),
      email: json['email'] ?? "",
      token: json['token'],
    );
  }
}
