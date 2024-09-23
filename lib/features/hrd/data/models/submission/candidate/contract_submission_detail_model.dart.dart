class ContractSubmissionDetail {
  final int candidateSubmissionId;
  final String submissionDate;
  final String jobPosition;
  final String contractStartDate;
  final String contractEndDate;
  final PersonalInfo personalInfo;

  ContractSubmissionDetail({
    required this.candidateSubmissionId,
    required this.submissionDate,
    required this.jobPosition,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.personalInfo,
  });

  factory ContractSubmissionDetail.fromJson(Map<String, dynamic> json) {
    return ContractSubmissionDetail(
      candidateSubmissionId: json['candidate_submission_id'],
      submissionDate: json['submission_date'],
      jobPosition: json['job_position'],
      contractStartDate: json['contract_start_date'],
      contractEndDate: json['contract_end_date'],
      personalInfo: PersonalInfo.fromJson(json['personal_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate_submission_id': candidateSubmissionId,
      'submission_date': submissionDate,
      'job_position': jobPosition,
      'contract_start_date': contractStartDate,
      'contract_end_date': contractEndDate,
      'personal_info': personalInfo.toJson(),
    };
  }
}

class PersonalInfo {
  final String name;
  final String gender;
  final String dateOfBirth;
  final String phoneNumber;
  final String email;
  final String address;

  PersonalInfo({
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'phone_number': phoneNumber,
      'email': email,
      'address': address,
    };
  }
}
