import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/unfinished_subordinate_task_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/tasking/subordinate_task_content.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
class UnfinishedSubOrdinateEmployeeTasking extends StatelessWidget {
  UnfinishedSubOrdinateEmployeeTasking({super.key});
  final int branchId = GetIt.instance<AuthSharedPref>().getBranchId() ?? 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnfinishedSubordinateTaskCubit, UnfinishedSubordinateTaskState>(
      builder: (context, state) {
        if (state is UnfinishedSubordinateTaskLoading) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
        } else if (state is UnfinishedSubordinateTaskError) {
          return Utils.buildErrorState(
            title: 'Gagal Memuat Data',
            message: state.message,
            onRetry: () {
              context.read<UnfinishedSubordinateTaskCubit>().fetchUnfinishedSubordinateTasks(
                  branchId: branchId);
            },
          );
        } else if (state is UnfinishedSubordinateTaskLoaded) {
          if (state.tasks.isEmpty) {
            return Utils.buildEmptyState("Belum Ada Tasking", null);
          } else {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return SubordinateTaskContent(task: task, status: 'UNFINISHED');
              },
            );
          }
        } else {
          return const Center(child: Text('Tidak ada data'));
        }
      },
    );
  }
}
