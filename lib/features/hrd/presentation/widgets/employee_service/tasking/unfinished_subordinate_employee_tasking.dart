import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/subordinate_tasking_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class UnfinishedSubOrdinateEmployeeTasking extends StatelessWidget {
  UnfinishedSubOrdinateEmployeeTasking({super.key});
  final int branchId = GetIt.instance<AuthSharedPref>().getBranchId() ?? 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubordinateTaskCubit, SubordinateTaskState>(
      builder: (context, state) {
        if (state is SubordinateTaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SubordinateTaskError) {
          return Utils.buildErrorState(
            title: 'Gagal Memuat Data',
            message: state.message,
            onRetry: () {
              context.read<SubordinateTaskCubit>().fetchSubordinateTasks(
                  branchId: branchId, status: 'UNFINISHED');
            },
          );
        } else if (state is SubordinateTaskLoaded) {
          if (state.tasks.isEmpty) {
            return Utils.buildEmptyState("Belum Ada Tasking", null);
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return _buildTaskContent(task, context, 'Belum Dikerjakan');
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

  Widget _buildTaskContent(SubordinateTaskModel task, BuildContext context, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskHeader(task.taskSubmissionDate),
          const SizedBox(height: 8),
          Text(task.taskingEmployeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(task.taskingName, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Tenggat Waktu: ${task.taskEndDatetime}'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: status == 'Belum Dikerjakan' ? Colors.orange.shade100 : Colors.green.shade100,
            ),
            child: Text(
              status,
              style: TextStyle(color: status == 'Belum Dikerjakan' ? Colors.orange : Colors.green),
            ),
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }

  Widget _buildTaskHeader(String date) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            date,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.task_alt, color: Colors.red),
      ],
    );
  }
}
