import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/submission/employee/employee_submission_detail.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_submission/employee_submission_list_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class PendingApprovalTab extends StatelessWidget {
  
   PendingApprovalTab({super.key});
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingSubmissionsCubit, PendingSubmissionsState>(
      builder: (context, state) {
        if (state is PendingSubmissionsLoading) {
          return Container(width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
        } else if (state is PendingSubmissionsError) {
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            context.read<PendingSubmissionsCubit>().fetchPendingSubmissions(branchId: _authSharedPref.getBranchId() ?? 0);
          },
        );
        } else if (state is PendingSubmissionsLoaded) {
          if (state.submissions.isEmpty) {
            return Utils.buildEmptyState("Belum Ada Pengajuan", null);
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: ListView.builder(
                itemCount: state.submissions.length,
                itemBuilder: (context, index) {
                  final submission = state.submissions[index];
                  return EmployeeSubmissionListContent(submission: submission
                  );
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
