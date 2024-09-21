import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/submission/submission_list_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RejectedTab extends StatelessWidget {
  const RejectedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RejectedSubmissionsCubit, RejectedSubmissionsState>(
      builder: (context, state) {
        if (state is RejectedSubmissionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RejectedSubmissionsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is RejectedSubmissionsLoaded) {
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
