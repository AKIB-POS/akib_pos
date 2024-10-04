import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_submission_list_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CandidatePendingSubmissionTab extends StatelessWidget {
   CandidatePendingSubmissionTab({super.key});
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

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
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            context.read<CandidatePendingSubmissionsCubit>().fetchPendingSubmissions(branchId: _authSharedPref.getBranchId() ?? 0);
          },
        );
        } else if (state is CandidatePendingSubmissionsLoaded) {
          if (state.pendingSubmissions.isEmpty) {
            return Utils.buildEmptyState("Belum Ada Pengajuan", null);
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
