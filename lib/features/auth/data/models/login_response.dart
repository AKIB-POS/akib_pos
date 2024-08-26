class LoginResponse {
  final String token;
  final int id;
  final int companyId;
  final int branchId;
  final String? email;
  final String? role;
  final List<String> permissions;

  LoginResponse({
    required this.token,
    required this.id,
    required this.companyId,
    required this.branchId,
    this.email,
    this.role,
    required this.permissions
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      companyId: json['company_id'],
      branchId: json['branch_id'],
      role: json['role'],
      permissions: List.from(json['permissions']),
      email: json['email'] ?? "",
      token: json['token']
    );
  }
}