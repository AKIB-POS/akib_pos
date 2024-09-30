import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_submission_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateApprovedSubmissionTab extends StatelessWidget {
  const CandidateApprovedSubmissionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateApprovedSubmissionsCubit, CandidateApprovedSubmissionsState>(
      builder: (context, state) {
        if (state is CandidateApprovedSubmissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CandidateApprovedSubmissionsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CandidateApprovedSubmissionsLoaded) {
          if (state.approvedSubmissions.isEmpty) {
            return const Center(child: Text('Tidak ada pengajuan yang disetujui'));
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: ListView.builder(
                itemCount: state.approvedSubmissions.length,
                itemBuilder: (context, index) {
                  final submission = state.approvedSubmissions[index];
                  return CandidateSubmissionListContent(submission: submission);
                },
              ),
            );
          }
        } else {
          return const Center(child: Text('Tidak ada data'));
        }
      },
    );
  }
}
