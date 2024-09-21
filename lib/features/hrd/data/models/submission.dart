class Submission {
  final String type;
  final String submissionType;
  final String name;
  final String role;
  final String submissionDate;
  final List<Detail> details;  // Menggunakan 'Detail' sebagai nama untuk submission_details
  final String approverName;
  final String approvalStatus;

  Submission({
    required this.type,
    required this.submissionType,
    required this.name,
    required this.role,
    required this.submissionDate,
    required this.details,
    required this.approverName,
    required this.approvalStatus,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    var details = (json['submission_details'] as List)
        .map((detail) => Detail.fromJson(detail))
        .toList();
    return Submission(
      type: json['type'],
      submissionType: json['submission_type'],
      name: json['name'],
      role: json['role'],
      submissionDate: json['submission_date'],
      details: details,
      approverName: json['approver_name'],
      approvalStatus: json['approval_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'submission_type': submissionType,
      'name': name,
      'role': role,
      'submission_date': submissionDate,
      'submission_details': details.map((e) => e.toJson()).toList(),
      'approver_name': approverName,
      'approval_status': approvalStatus,
    };
  }
}

class Detail {  // Menggunakan nama 'Detail' untuk objek submission_details
  final String key;
  final String value;

  Detail({required this.key, required this.value});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
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
