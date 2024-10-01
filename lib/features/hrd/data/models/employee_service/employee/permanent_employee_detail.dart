import 'package:akib_pos/features/hrd/data/models/employee_service/employee/contract_employee_detail.dart';

class PermanentEmployeeDetail {
  final String employeeType;
  final EmployeeInfoPermanent employeeInfo;
  final PersonalInfo personalInfo;

  PermanentEmployeeDetail({
    required this.employeeType,
    required this.employeeInfo,
    required this.personalInfo,
  });

  factory PermanentEmployeeDetail.fromJson(Map<String, dynamic> json) {
    return PermanentEmployeeDetail(
      employeeType: json['employee_type'] ?? '',  // Default to empty string if missing
      employeeInfo: EmployeeInfoPermanent.fromJson(json['employee_info'] ?? {}),  // Safe handling of nested objects
      personalInfo: PersonalInfo.fromJson(json['personal_info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_type': employeeType,
      'employee_info': employeeInfo.toJson(),
      'personal_info': personalInfo.toJson(),
    };
  }
}

class EmployeeInfoPermanent {
  final String position;
  final String branch;
  final String? confirmationDate;
  final String? confirmationLetterNumber;

  EmployeeInfoPermanent({
    required this.position,
    required this.branch,
    this.confirmationDate,  // Nullable
    this.confirmationLetterNumber,  // Nullable
  });

  factory EmployeeInfoPermanent.fromJson(Map<String, dynamic> json) {
    return EmployeeInfoPermanent(
      position: json['position'] ?? '',  // Default to empty string if missing
      branch: json['branch'] ?? '',  // Default to empty string if missing
      confirmationDate: json['confirmation_date'],  // Nullable
      confirmationLetterNumber: json['confirmation_letter_number'],  // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'branch': branch,
      'confirmation_date': confirmationDate,
      'confirmation_letter_number': confirmationLetterNumber,
    };
  }
}
