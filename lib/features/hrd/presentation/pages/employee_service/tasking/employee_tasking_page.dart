import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/employee_tasking.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/employee_task_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/detail_employee_task_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeTaskingPage extends StatefulWidget {
  const EmployeeTaskingPage({Key? key}) : super(key: key);

  @override
  _EmployeeTaskingPageState createState() => _EmployeeTaskingPageState();
}

class _EmployeeTaskingPageState extends State<EmployeeTaskingPage> {
  @override
  void initState() {
    super.initState();
    // Fetch employee tasks on init
    _fetchEmployeeTasks();
  }

  void _fetchEmployeeTasks() {
    context.read<EmployeeTaskCubit>().fetchEmployeeTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        titleSpacing: 0,
        title: const Text('Tasking Anda', style: AppTextStyle.headline5),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchEmployeeTasks(); // Trigger refresh of the task list
        },
        color: AppColors.primaryMain,
        child: BlocBuilder<EmployeeTaskCubit, EmployeeTaskState>(
          builder: (context, state) {
            if (state is EmployeeTaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployeeTaskLoaded) {
              if (state.tasks.isEmpty) {
                return Utils.buildEmptyStatePlain(
                  "Belum ada Tasking",
                  "Tidak ada tasking yang tersedia saat ini.",
                );
              } else {
                return _buildTaskList(state.tasks);
              }
            } else if (state is EmployeeTaskError) {
              return Utils.buildErrorState(
                title: "Ada Kesalahan",
                message: state.message,
                onRetry: _fetchEmployeeTasks,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTaskList(List<EmployeeTask> tasks) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16, left: 16),
      child: Column(
        children: tasks.map((task) => _buildTaskItem(task)).toList(),
      ),
    );
  }

  Widget _buildTaskItem(EmployeeTask task) {
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    final formattedSubmissionDate =
        dateFormat.format(DateTime.parse(task.taskSubmissionDate));

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateHeader(formattedSubmissionDate),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      task.taskingName,
                      style: AppTextStyle.headline5,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Tenggat Waktu: ",
                          style: AppTextStyle.caption
                              .copyWith(color: AppColors.textGrey800),
                        ),
                        Text(
                          task.taskEndDatetime,
                          style: AppTextStyle.caption
                              .copyWith(color: AppColors.primaryMain),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton(
              onPressed: () {
                Utils.navigateToPage(context, DetailEmployeeTaskPage(taskingId: task.taskingId));
              },
              style: AppThemes.outlineButtonPrimaryStylePadding,
              child: Text(
                'Detail',
                style:
                    AppTextStyle.caption.copyWith(color: AppColors.primaryMain),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: AppColors.primaryMain,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Text(
        date,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
