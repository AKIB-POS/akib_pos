class CheckInOutRequest {
  final int branchId;
  final int companyId;
  final int employeeId;
  final String time;

  CheckInOutRequest({
    required this.branchId,
    required this.companyId,
    required this.employeeId,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'branch_id': branchId,
      // 'company_id': companyId,
      // 'employee_id': employeeId,
      'time': time,
    };
  }
}

class CheckInOutResponse {
  final String message;

  CheckInOutResponse({required this.message});

  factory CheckInOutResponse.fromJson(Map<String, dynamic> json) {
    return CheckInOutResponse(
      message: json['message'],
    );
  }
}
