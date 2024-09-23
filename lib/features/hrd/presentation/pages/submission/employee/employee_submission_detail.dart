import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/submission.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';

class EmployeeSubmissionDetailPage extends StatelessWidget {
  final EmployeeSubmission submission;

  const EmployeeSubmissionDetailPage({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      resizeToAvoidBottomInset: true, // Hindari overflow saat keyboard muncul
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
      body: Column( // Menggunakan Column untuk layout utama
        children: [
          Expanded( // Gunakan Expanded untuk memastikan tombol tetap di bawah
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80), // Tambahkan padding di bawah agar konten tidak tertutupi tombol
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (submission.reason != null) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildStatusInfo(),
                    ),
                  ],
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (submission.approvalStatus == 'pending') 
            _buildActionButtons(context),
        ],
      ),
    );

  }

  Widget _buildStatusInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          submission.approvalStatus == "approved"
              ? "Pengajuan Disetujui"
              : "Pengajuan Ditolak",
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
              _buildColumn('Alasan', submission.reason ?? "-"),
            ],
          ),
        )
      ],
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
      return ElevatedButton(
        onPressed: () {
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryMain,
          side: const BorderSide(color: AppColors.primaryMain,width: 1.2),
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),

        ),
        child: Text("Lihat Lampiran",style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold),),
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
                  padding: const EdgeInsets.symmetric(vertical: 12)),
              onPressed: () {
                // Tambahkan aksi untuk tolak
                Utils.showInputTextVerificationDialog(
                  context,
                  buttonText: 'Ya, Tolak',
                  onConfirm: (String reason) {
                    // Gunakan nilai alasan  
                    print('Alasan Tolak: $reason');
                    // Tambahkan aksi untuk tolak berdasarkan alasan
                  },
                  onCancel: () {
                    Navigator.of(context).pop(); // Untuk menutup dialog
                  },
                );
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
                Utils.showInputTextVerificationDialog(
                  context,
                  buttonText: 'Ya, Terima',
                  onConfirm: (String reason) {
                    // Gunakan nilai alasan  
                    print('Alasan Tolak: $reason');
                    // Tambahkan aksi untuk tolak berdasarkan alasan
                  },
                  onCancel: () {
                    Navigator.of(context).pop(); // Untuk menutup dialog
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12)),
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
