import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/submission/submission_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class ApprovedTab extends StatelessWidget {
  const ApprovedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovedSubmissionsCubit, ApprovedSubmissionsState>(
      builder: (context, state) {
        if (state is ApprovedSubmissionsLoading) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
        } else if (state is ApprovedSubmissionsError) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(child: Text('Error: ${state.message}')));
        } else if (state is ApprovedSubmissionsLoaded) {
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
                  return SubmissionListContent(submission: submission);
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

