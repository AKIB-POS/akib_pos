import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/candidate_submission.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/submission/candidate/candidate_submission_detail_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class CandidateSubmissionListContent extends StatelessWidget {
  final CandidateSubmission submission;

  const CandidateSubmissionListContent({Key? key, required this.submission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Submission Date and Type
          _buildHeader(submission.submissionDate),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Submission Type
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        _buildType(submission.submissionType),
                        const SizedBox(height: 6),
                        Text(submission.candidateName, style: AppTextStyle.headline5),
                        const SizedBox(height: 8),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () async{
                        // Handle detail button press
                       final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CandidateSubmissionDetailPage(
                              candidateId: submission.candidateSubmissionId,
                              submissionType: submission.submissionType,
                              approvalStatus: submission.approvalStatus,
                            ),
                          ),
                        );

                        // Jika hasilnya true, berarti verifikasi berhasil dan kita perlu fetch ulang data
                        if (result == true) {
                          final branchId = GetIt.instance<AuthSharedPref>().getBranchId() ?? 0;
                          context.read<CandidatePendingSubmissionsCubit>().fetchPendingSubmissions(branchId: branchId);
                          context.read<CandidateApprovedSubmissionsCubit>().fetchApprovedSubmissions(branchId: branchId);
                          context.read<CandidateRejectedSubmissionsCubit>().fetchRejectedSubmissions(branchId: branchId);
                        }
                      },
                      style: AppThemes.outlineButtonPrimaryStyle,
                      child: Text('Detail', style: AppTextStyle.caption.copyWith(color : AppColors.primaryMain)),
                    ),
                  ],
                ),
                _buildApprovalStatus(submission.approverName, submission.approvalStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildType(String submissionType) {
    Color textColor, backgroundColor;
    if (submissionType == 'Calon Pegawai Kontrak') {
      textColor = AppColors.secondaryMain;
      backgroundColor = AppColors.secondaryMain.withOpacity(0.1);
    } else {
      textColor = AppColors.successMain;
      backgroundColor = AppColors.successMain.withOpacity(0.1);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: Text(submission.submissionType, style: AppTextStyle.caption.copyWith(color: textColor)),
    );
  }

  Widget _buildHeader(String submissionDate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Text(
        'Pengajuan: $submissionDate',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildApprovalStatus(String approverName, String approvalStatus) {
    String assetPath;
    if (approvalStatus == 'approved') {
      assetPath = 'assets/icons/hrd/ic_approved.svg';
    } else if (approvalStatus == 'pending') {
      assetPath = 'assets/icons/hrd/ic_clock_pending.svg';
    } else {
      assetPath = 'assets/icons/hrd/ic_rejected.svg';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textGrey100
                  ),
      child: Column(

      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Persetujuan', style: AppTextStyle.caption.copyWith(color: AppColors.textGrey600)),
          const SizedBox(height: 4,),
          Row(
            children: [
              Text(
                '$approverName : ',
                style: AppTextStyle.caption.copyWith(color: Colors.black),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset(assetPath),
            ],
          ),
        ],
      ),
    );
  }
}
