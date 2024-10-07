class EmployeeSubmission {
  final int employeeSubmissionId;
  final String type;
  final String submissionType;
  final String name;
  final String role;
  final String? submissionDate;
  final List<SubmissionInfo> submissionDetails;
  final String? approverName;
  final String approvalStatus;
  final String? description;  // Nullable because it may not always have a description
  final String? attachment;   // Nullable because it may not always have an attachment
  final String? reason;       // Nullable because pending submissions won't have a reason

  EmployeeSubmission({
    required this.employeeSubmissionId,
    required this.type,
    required this.submissionType,
    required this.name,
    required this.role,
    required this.submissionDate,
    required this.submissionDetails,
    required this.approverName,
    required this.approvalStatus,
    this.description,
    this.attachment,
    this.reason,
  });

  // JSON Factory with null safety handling
  factory EmployeeSubmission.fromJson(Map<String, dynamic> json) {
    var submissionDetails = (json['submission_details'] as List)
        .map((detail) => SubmissionInfo.fromJson(detail))
        .toList();
    return EmployeeSubmission(
      employeeSubmissionId: json['employee_submission_id'],
      type: json['type'] ?? '', // Default value if null
      submissionType: json['submission_type'] ?? '', // Default value if null
      name: json['name'] ?? '', // Default value if null
      role: json['role'] ?? '', // Default value if null
      submissionDate: json['submission_date'], // Nullable
      submissionDetails: submissionDetails,
      approverName: json['approver_name'], // Nullable
      approvalStatus: json['approval_status'] ?? '', // Default value if null
      description: json['description'], // Nullable
      attachment: json['attachment'], // Nullable
      reason: json['reason'], // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_submission_id': employeeSubmissionId,
      'type': type,
      'submission_type': submissionType,
      'name': name,
      'role': role,
      'submission_date': submissionDate,
      'submission_details': submissionDetails.map((e) => e.toJson()).toList(),
      'approver_name': approverName,
      'approval_status': approvalStatus,
      'description': description,
      'attachment': attachment,
      'reason': reason,
    };
  }
}

class SubmissionInfo {
  final String key;
  final String value;

  SubmissionInfo({required this.key, required this.value});

  factory SubmissionInfo.fromJson(Map<String, dynamic> json) {
    return SubmissionInfo(
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}
