import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/submission.dart';
import 'package:flutter/material.dart';

class EmployeeSubmissionDetailPage extends StatelessWidget {
  final EmployeeSubmission submission;

  const EmployeeSubmissionDetailPage({super.key, required this.submission});

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
        title: const Text(
          'Detail Pengajuan Bawahan',
          style: AppTextStyle.headline5,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSubmissionInfo(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildEmployeeInfo(),
          ),
          const Spacer(),
          if (submission.approvalStatus == 'pending')
            _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSubmissionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pengajuan',
          style: AppTextStyle.headline5,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn('Waktu Pengajuan', submission.submissionDate),
              const SizedBox(height: 12),
              _buildColumn(' Cuti', submission.submissionType),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn(submission.submissionDetails[0].key,
                      submission.submissionDetails[0].value),
                  _buildColumn(submission.submissionDetails[1].key,
                      submission.submissionDetails[1].value),
                ],
              ),
              const SizedBox(height: 12),
              _buildColumn('Keterangan',
                  submission.description ?? 'Tidak ada keterangan'),
              const SizedBox(height: 8),
              _buildAttachmentButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Informasi Pegawai',
            style: AppTextStyle.headline5,
          ),

        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn('Nama', submission.name),

              const SizedBox(height: 12),
              _buildColumn('Jabatan', submission.role),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.caption,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAttachmentButton() {
    if (submission.attachment != null) {
      return ElevatedButton.icon(
        onPressed: () {
          // Add download logic here
        },
        icon: const Icon(Icons.download),
        label: const Text('Unduh'),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryMain,
          side: const BorderSide(color: AppColors.primaryMain),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
      decoration: AppThemes.bottomBoxDecorationDialog,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12)
              ),
              onPressed: () {
                // Tambahkan aksi untuk tolak
              },
              child: Text(
                'Tolak',
                style: AppTextStyle.headline5
                    .copyWith(color: AppColors.primaryMain),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan aksi untuk verifikasi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12)
                ),
                child: Text(
                  'Verifikasi',
                  style: AppTextStyle.headline5.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }




}
