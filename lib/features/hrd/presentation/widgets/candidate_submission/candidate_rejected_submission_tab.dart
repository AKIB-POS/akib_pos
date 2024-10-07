import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_submission_list_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CandidateRejectedSubmissionTab extends StatelessWidget {
   CandidateRejectedSubmissionTab({Key? key}) : super(key: key);
 final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateRejectedSubmissionsCubit, CandidateRejectedSubmissionsState>(
      builder: (context, state) {
        if (state is CandidateRejectedSubmissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CandidateRejectedSubmissionsError) {
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            context.read<CandidateRejectedSubmissionsCubit>().fetchRejectedSubmissions(branchId: _authSharedPref.getBranchId() ?? 0);
          },
        );
        } else if (state is CandidateRejectedSubmissionsLoaded) {
          if (state.rejectedSubmissions.isEmpty) {
            return Utils.buildEmptyState("Belum Ada Pengajuan", null);
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
