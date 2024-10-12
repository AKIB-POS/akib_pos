class Branch {
  final int id;
  final String branchName;
  final String address;
  final String phone;
  final String email;

  Branch({
    required this.id,
    required this.branchName,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      branchName: json['branch_name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_name': branchName,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}

class BranchesResponse {
  final List<Branch> branches;

  BranchesResponse({required this.branches});

  factory BranchesResponse.fromJson(Map<String, dynamic> json) {
    return BranchesResponse(
      branches: (json['data'] as List)
          .map((branch) => Branch.fromJson(branch))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': branches.map((branch) => branch.toJson()).toList(),
    };
  }
}
