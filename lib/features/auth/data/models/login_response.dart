class LoginResponse {
  final String token;
  final int id;
  final int companyId;
  final String companyName;
  final int branchId;
  final String? email;
  final String? role;
  final String employeeName;
  final String? employeeRole;
  final List<String> permissions;
  final MobilePermissions mobilePermissions; // Field untuk mobile_permissions

  LoginResponse({
    required this.token,
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.branchId,
    this.email,
    this.role,
    required this.employeeName,
    required this.employeeRole,
    required this.permissions,
    required this.mobilePermissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      companyId: json['company_id'],
      companyName: json['company_name'],
      branchId: json['branch_id'],
      role: json['role'],
      employeeName: json['employee_name'],
      employeeRole: json['employee_role'] ,
      permissions: List<String>.from(json['permissions']),
      email: json['email'] ?? "",
      token: json['token'],
      
      // Memastikan mobilePermissions diterima baik sebagai Map atau String
      mobilePermissions: MobilePermissions.fromJson(json['mobile_permissions']),
    );
  }
}

class MobilePermissions {
  final List<String> dashboard;
  final List<String> accounting;
  final List<String> hrd;
  final List<String> stockist;
  final String? cashier; // Add cashier as a string type, since it can appear as a string

  MobilePermissions({
    required this.dashboard,
    required this.accounting,
    required this.hrd,
    required this.stockist,
    this.cashier, // Nullable cashier field
  });

  // Default factory constructor untuk menangani kondisi kosong
  factory MobilePermissions.empty() {
    return MobilePermissions(
      dashboard: [],
      accounting: [],
      hrd: [],
      stockist: [],
      cashier: null,
    );
  }

  // Menangani format mobile_permissions sebagai Map atau String
  factory MobilePermissions.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      // Handling the Map structure case
      return MobilePermissions(
        dashboard: List<String>.from(json['dashboard'] ?? []),
        accounting: List<String>.from(json['accounting'] ?? []),
        hrd: List<String>.from(json['hrd'] ?? []),
        stockist: List<String>.from(json['stockist'] ?? []),
        cashier: json['cashier'], // Handle cashier as a string
      );
    } else if (json is String) {
      // Jika mobile_permissions hanya string seperti "cashier"
      return MobilePermissions.empty().copyWith(cashier: json);
    } else {
      return MobilePermissions.empty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'dashboard': dashboard,
      'accounting': accounting,
      'hrd': hrd,
      'stockist': stockist,
      'cashier': cashier,
    };
  }

  // Method untuk membuat salinan objek dengan perubahan pada field tertentu
  MobilePermissions copyWith({
    List<String>? dashboard,
    List<String>? accounting,
    List<String>? hrd,
    List<String>? stockist,
    String? cashier,
  }) {
    return MobilePermissions(
      dashboard: dashboard ?? this.dashboard,
      accounting: accounting ?? this.accounting,
      hrd: hrd ?? this.hrd,
      stockist: stockist ?? this.stockist,
      cashier: cashier ?? this.cashier,
    );
  }
}
