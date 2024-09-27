import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_submission_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateRejectedSubmissionTab extends StatelessWidget {
  const CandidateRejectedSubmissionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateRejectedSubmissionsCubit, CandidateRejectedSubmissionsState>(
      builder: (context, state) {
        if (state is CandidateRejectedSubmissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CandidateRejectedSubmissionsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CandidateRejectedSubmissionsLoaded) {
          if (state.rejectedSubmissions.isEmpty) {
            return const Center(child: Text('Tidak ada pengajuan yang ditolak'));
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: ListView.builder(
                itemCount: state.rejectedSubmissions.length,
                itemBuilder: (context, index) {
                  final submission = state.rejectedSubmissions[index];
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
