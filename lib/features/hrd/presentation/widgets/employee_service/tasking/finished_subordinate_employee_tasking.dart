import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_tasking_model.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/subordinate_tasking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class FinishedSubOrdinateEmployeeTasking extends StatelessWidget {
  FinishedSubOrdinateEmployeeTasking({super.key});
  final int branchId = GetIt.instance<AuthSharedPref>().getBranchId() ?? 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubordinateTaskCubit, SubordinateTaskState>(
      builder: (context, state) {
        if (state is SubordinateTaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SubordinateTaskError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Gagal Memuat Data: ${state.message}'),
                ElevatedButton(
                  onPressed: () {
                    context.read<SubordinateTaskCubit>().fetchSubordinateTasks(
                        branchId: branchId, status: 'FINISHED');
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        } else if (state is SubordinateTaskLoaded) {
          if (state.tasks.isEmpty) {
            return const Center(child: Text('Belum Ada Tasking yang Selesai'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return _buildTaskCard(task, context, 'Selesai Dikerjakan');
              },
            );
          }
        } else {
          return const Center(child: Text('Tidak ada data'));
        }
      },
    );
  }

  Widget _buildTaskCard(SubordinateTaskModel task, BuildContext context, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskHeader(task.taskSubmissionDate),
            const SizedBox(height: 8),
            Text(task.taskingEmployeeName, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(task.taskingName, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Tenggat Waktu: ${task.taskEndDatetime}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: status == 'Selesai Dikerjakan' ? Colors.green.shade100 : Colors.orange.shade100,
              ),
              child: Text(
                status,
                style: TextStyle(color: status == 'Selesai Dikerjakan' ? Colors.green : Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskHeader(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        date,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}