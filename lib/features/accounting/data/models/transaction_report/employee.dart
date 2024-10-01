class EmployeeModel {
  final int employeeId;
  final String employeeName;

  EmployeeModel({
    required this.employeeId,
    required this.employeeName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeName: json['employee_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
    };
  }
}

class EmployeeListResponse {
  final String message;
  final List<EmployeeModel> data;

  EmployeeListResponse({
    required this.message,
    required this.data,
  });

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    var employeeList = (json['data'] as List?)
        ?.map((employee) => EmployeeModel.fromJson(employee))
        .toList() ?? [];

    return EmployeeListResponse(
      message: json['message'] ?? '',
      data: employeeList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
