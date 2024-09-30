import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/employee_submission.dart';
import 'package:akib_pos/features/hrd/data/models/submission/employee/verify_employee_submission_request.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_submission/verify_employee_submission_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EmployeeSubmissionDetailPage extends StatelessWidget {
  final EmployeeSubmission submission;

  const EmployeeSubmissionDetailPage({super.key, required this.submission});

  void _verifySubmission(BuildContext context, String status, String? reason,String submissionType) {
    final request = VerifyEmployeeSubmissionRequest(
        employeeSubmissionId: submission.employeeSubmissionId,
        status: status,
        reason: reason,
        submissionType: submissionType
        );
    context
        .read<VerifyEmployeeSubmissionCubit>()
        .verifyEmployeeSubmission(request);
  }

  @override
  Widget build(BuildContext context) {
    final role = GetIt.instance<AuthSharedPref>().getEmployeeRole();
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
      body: BlocConsumer<VerifyEmployeeSubmissionCubit,
          VerifyEmployeeSubmissionState>(
        listener: (context, state) {
          if (state is VerifyEmployeeSubmissionLoading) {
            // Tampilkan loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is VerifyEmployeeSubmissionSuccess) {
            // Tutup loading dialog dan tampilkan pesan sukses
            Navigator.of(context).pop(); // Tutup dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
            Navigator.of(context).pop(true);
          } else if (state is VerifyEmployeeSubmissionError) {
            Navigator.of(context).pop(); 
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (submission.reason != null) ...[
                          const SizedBox(height: 16),
                          _buildStatusInfo(),
                        ],
                        const SizedBox(height: 16),
                        _buildSubmissionInfo(),
                        const SizedBox(height: 16),
                        _buildEmployeeInfo(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),              
              if (submission.approvalStatus == 'pending' && role == "owner")
                _buildActionButtons(context),
            ],
          );
        },
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
              _buildColumn('Waktu Pengajuan', submission.submissionDate ?? ""),
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
        const Text('Informasi Pegawai', style: AppTextStyle.headline5),
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
        Text(label, style: AppTextStyle.caption),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAttachmentButton() {
    if (submission.attachment != null) {
      return ElevatedButton(
        onPressed: () {
          // Tambahkan logika unduh lampiran
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
        child: Text("Lihat Lampiran",
            style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
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
            style: AppThemes.outlineButtonPrimaryStyle,
            onPressed: () {
              Utils.showInputTextVerificationDialog(
                context,
                buttonText: 'Ya, Tolak',
                onConfirm: (String reason) {
                  // Kondisi submissionType sesuai submission.type
                  final submissionType = _mapSubmissionType(submission.type);
                  // Kirim status "rejected"
                  _verifySubmission(context, 'REJECTED', reason, submissionType);
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              );
            },
            child: Text('Tolak',
                style: AppTextStyle.headline5
                    .copyWith(color: AppColors.primaryMain)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Utils.showInputTextVerificationDialog(
                context,
                buttonText: 'Ya, Terima',
                onConfirm: (String reason) {
                  // Kondisi submissionType sesuai submission.type
                  final submissionType = _mapSubmissionType(submission.type);
                  _verifySubmission(context, 'APPROVED', reason, submissionType);
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              );
            },
            style: AppThemes.elevatedBUttonPrimaryStyle,
            child: Text('Verifikasi',
                style: AppTextStyle.headline5.copyWith(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

// Fungsi untuk mapping submission.type ke submissionType yang sesuai
String _mapSubmissionType(String submissionType) {
  switch (submissionType) {
    case 'cuti':
      return 'LEAVE';
    case 'izin':
      return 'PERMISSION';
    case 'lembur':
      return 'OVERTIME';
    default:
      return 'UNKNOWN'; // Handle default case jika type tidak dikenal
  }
}



}
