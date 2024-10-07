import 'package:akib_pos/features/hrd/data/models/submission/candidate/contract_submission_detail_model.dart.dart';

class PermanentSubmissionDetail {
  final int candidateSubmissionId;
  final String submissionDate;
  final String jobPosition;
  final PersonalInfo personalInfo;

  PermanentSubmissionDetail({
    required this.candidateSubmissionId,
    required this.submissionDate,
    required this.jobPosition,
    required this.personalInfo,
  });

  factory PermanentSubmissionDetail.fromJson(Map<String, dynamic> json) {
    return PermanentSubmissionDetail(
      candidateSubmissionId: json['candidate_submission_id'],
      submissionDate: json['submission_date'],
      jobPosition: json['job_position'],
      personalInfo: PersonalInfo.fromJson(json['personal_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate_submission_id': candidateSubmissionId,
      'submission_date': submissionDate,
      'job_position': jobPosition,
      'personal_info': personalInfo.toJson(),
    };
  }
}
