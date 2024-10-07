import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/detail_employee_task_response.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/detail_employee_tasking_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/employee_task_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/tasking/submit_employee_tasking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailEmployeeTaskPage extends StatefulWidget {
  final int taskingId;

  const DetailEmployeeTaskPage({Key? key, required this.taskingId}) : super(key: key);

  @override
  State<DetailEmployeeTaskPage> createState() => _DetailEmployeeTaskPageState();
}

class _DetailEmployeeTaskPageState extends State<DetailEmployeeTaskPage> {
  @override
  void initState() {
    super.initState();
    // Fetch task detail saat initState
    _fetchData();
  }

  void _fetchData(){
    context.read<DetailEmployeeTaskCubit>().fetchDetailEmployeeTask(widget.taskingId);
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text('Detail Tasking', style: AppTextStyle.headline5),
      ),
      body: BlocConsumer<DetailEmployeeTaskCubit, DetailEmployeeTaskState>(
        listener: (context, state) {
          if (state is DetailEmployeeTaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DetailEmployeeTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailEmployeeTaskLoaded) {
            return _buildTaskDetail(context, state.detailEmployeeTask);
          } else {
            return const Center(child: Text('Tidak ada data tasking'));
          }
        },
      ),
      bottomNavigationBar: _buildUploadButton(context,widget.taskingId),
    );
  }

  Widget _buildTaskDetail(BuildContext context, DetailEmployeeTaskResponse taskDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskInfo(taskDetail),
            const SizedBox(height: 16),
            // Uncomment and add attachment logic when needed
            // if (taskDetail.attachment != null) _buildAttachmentButton(taskDetail.attachment!),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInfo(DetailEmployeeTaskResponse taskDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Waktu Pemberian', taskDetail.taskingSubmissionDatetime),
        const SizedBox(height: 12),
        _buildInfoRow('Uraian Tugas', taskDetail.taskingName),
        const SizedBox(height: 12),
        _buildInfoRow('Waktu Selesai', taskDetail.taskingEndDatetime),
        const SizedBox(height: 12),
        _buildInfoRow('Pemberi Tugas', taskDetail.taskingAssignerName),
        const SizedBox(height: 12),
        _buildInfoRow('Jabatan', taskDetail.taskingAssignerRole),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context,int taskId) {
    return Container(
      decoration: AppThemes.bottomBoxDecorationDialog,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMain,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed:()  async{
          final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>  SubmitEmployeeTaskingPage(taskId: taskId,),
              ),
            );

            // Jika result true, refresh data cuti
            if (result == true) {
              _fetchEmployeeTasks(); // Panggil fungsi untuk refresh data
            }
        },
        child: const Text('Upload Tugas', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}