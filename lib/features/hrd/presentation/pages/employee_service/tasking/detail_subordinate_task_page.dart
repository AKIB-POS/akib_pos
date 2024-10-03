import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/tasking/subordinate_task_detail.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/tasking/detail_subordinate_task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailSubordinateTaskPage extends StatefulWidget {
  final int taskingId;

  const DetailSubordinateTaskPage({Key? key, required this.taskingId}) : super(key: key);

  @override
  State<DetailSubordinateTaskPage> createState() => _DetailSubordinateTaskPageState();
}

class _DetailSubordinateTaskPageState extends State<DetailSubordinateTaskPage> {
  @override
  void initState() {
    super.initState();
    // Panggil fetch data saat initState
    context.read<DetailSubordinateTaskCubit>().fetchDetailSubordinateTask(widget.taskingId);
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
      body: BlocConsumer<DetailSubordinateTaskCubit, DetailSubordinateTaskState>(
        listener: (context, state) {
          if (state is DetailSubordinateTaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DetailSubordinateTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailSubordinateTaskLoaded) {
            return _buildTaskDetail(context, state.detail);
          } else {
            return const Center(child: Text('Tidak ada data tasking'));
          }
        },
      ),
    );
  }

  Widget _buildTaskDetail(BuildContext context, SubordinateTaskDetail taskDetail) {
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
            if (taskDetail.attachment != null) _buildAttachmentButton(taskDetail.attachment!),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInfo(SubordinateTaskDetail taskDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Waktu Pemberian', taskDetail.submissionDatetime),
        const SizedBox(height: 12),
        _buildInfoRow('Uraian Tugas', taskDetail.taskName),
        const SizedBox(height: 12),
        _buildInfoRow('Waktu Selesai', taskDetail.endDatetime),
        const SizedBox(height: 12),
        _buildInfoRow('Keterangan', taskDetail.description),
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

  Widget _buildAttachmentButton(String attachmentUrl) {
    return ElevatedButton(
      onPressed: () {
        // Logika untuk membuka lampiran atau mendownloadnya
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryMain,
        side: const BorderSide(color: AppColors.primaryMain, width: 1.2),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        "Lihat Lampiran",
        style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
