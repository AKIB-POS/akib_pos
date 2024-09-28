import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_submission_list_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CandidateApprovedSubmissionTab extends StatelessWidget {
   CandidateApprovedSubmissionTab({super.key});
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateApprovedSubmissionsCubit, CandidateApprovedSubmissionsState>(
      builder: (context, state) {
        if (state is CandidateApprovedSubmissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CandidateApprovedSubmissionsError) {
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            context.read<CandidateApprovedSubmissionsCubit>().fetchApprovedSubmissions(branchId: _authSharedPref.getBranchId() ?? 0);
          },);
        } else if (state is CandidateApprovedSubmissionsLoaded) {
          if (state.approvedSubmissions.isEmpty) {
            return Utils.buildEmptyState("Belum Ada Pengajuan", null);
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
