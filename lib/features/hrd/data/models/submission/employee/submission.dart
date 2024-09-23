class EmployeeSubmission {
  final int employeeSubmissionId;
  final String type;
  final String submissionType;
  final String name;
  final String role;
  final String submissionDate;
  final List<SubmissionInfo> submissionDetails;
  final String approverName;
  final String approvalStatus;
  final String? description;  // Nullable karena bisa tidak ada keterangan
  final String? attachment;   // Nullable karena bisa tidak ada lampiran

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
  });

  factory EmployeeSubmission.fromJson(Map<String, dynamic> json) {
    var submissionDetails = (json['submission_details'] as List)
        .map((detail) => SubmissionInfo.fromJson(detail))
        .toList();
    return EmployeeSubmission(
      employeeSubmissionId: json['employee_submission_id'],
      type: json['type'],
      submissionType: json['submission_type'],
      name: json['name'],
      role: json['role'],
      submissionDate: json['submission_date'],
      submissionDetails: submissionDetails,
      approverName: json['approver_name'],
      approvalStatus: json['approval_status'],
      description: json['description'],
      attachment: json['attachment'],
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
