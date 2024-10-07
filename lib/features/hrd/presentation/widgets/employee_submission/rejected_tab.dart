import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_submission/employee_submission_list_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RejectedTab extends StatelessWidget {
   RejectedTab({Key? key}) : super(key: key);
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RejectedSubmissionsCubit, RejectedSubmissionsState>(
      builder: (context, state) {
        if (state is RejectedSubmissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RejectedSubmissionsError) {
          return Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            context.read<RejectedSubmissionsCubit>().fetchRejectedSubmissions(branchId: _authSharedPref.getBranchId() ?? 0);
          },
        );
        } else if (state is RejectedSubmissionsLoaded) {
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
                  return EmployeeSubmissionListContent(submission: submission);
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
