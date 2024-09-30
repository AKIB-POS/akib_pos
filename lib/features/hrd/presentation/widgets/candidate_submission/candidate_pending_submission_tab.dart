import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_submission_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidatePendingSubmissionTab extends StatelessWidget {
  const CandidatePendingSubmissionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatePendingSubmissionsCubit, CandidatePendingSubmissionsState>(
      builder: (context, state) {
        if (state is CandidatePendingSubmissionsLoading) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
        } else if (state is CandidatePendingSubmissionsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CandidatePendingSubmissionsLoaded) {
          if (state.pendingSubmissions.isEmpty) {
            return const Center(child: Text('Tidak ada pengajuan yang belum disetujui'));
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: ListView.builder(
                itemCount: state.pendingSubmissions.length,
                itemBuilder: (context, index) {
                  final submission = state.pendingSubmissions[index];
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
