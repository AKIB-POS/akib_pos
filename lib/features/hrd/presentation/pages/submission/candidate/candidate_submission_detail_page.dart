// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/verify_candidate_submission_cubit.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/verify_candidate_submission_request.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/contract_submission_detail_model.dart.dart';
import 'package:akib_pos/features/hrd/data/models/submission/candidate/permanent_submission_detail_model.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/contract_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/permanent_submission_cubit.dart';

class CandidateSubmissionDetailPage extends StatefulWidget {
  final int candidateId;
  final String submissionType;
  final String approvalStatus;

  const CandidateSubmissionDetailPage({
    Key? key,
    required this.candidateId,
    required this.submissionType,
    required this.approvalStatus,
  }) : super(key: key);

  @override
  _CandidateSubmissionDetailPageState createState() => _CandidateSubmissionDetailPageState();
}

class _CandidateSubmissionDetailPageState extends State<CandidateSubmissionDetailPage> {
  ContractSubmissionDetail? contractSubmission;
  PermanentSubmissionDetail? permanentSubmission;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (widget.submissionType == 'Calon Pegawai Kontrak') {
        await context.read<ContractSubmissionCubit>().fetchContractSubmissionDetail(widget.candidateId);
        final submission = context.read<ContractSubmissionCubit>().state;
        if (submission is ContractSubmissionLoaded) {
          setState(() {
            contractSubmission = submission.contractSubmissionDetail;
          });
        }
      } else if (widget.submissionType == 'Calon Pegawai Tetap') {
        await context.read<PermanentSubmissionCubit>().fetchPermanentSubmissionDetail(widget.candidateId);
        final submission = context.read<PermanentSubmissionCubit>().state;
        if (submission is PermanentSubmissionLoaded) {
          setState(() {
            permanentSubmission = submission.permanentSubmissionDetail;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        title: const Text('Detail Pengajuan Bawahan', style: AppTextStyle.headline5),
      ),
      body: BlocListener<VerifyCandidateSubmissionCubit, VerifyCandidateSubmissionState>(
        listener: (context, state) {
          if (state is VerifyCandidateSubmissionLoading) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is VerifyCandidateSubmissionSuccess) {
            // Close loading indicator and show success snackbar
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); 
          } else if (state is VerifyCandidateSubmissionError) {
            // Close loading indicator and show error snackbar
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text('Error: $errorMessage'))
                : _buildBodyContent(),
      ),
    );
  }

  Widget _buildBodyContent() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.submissionType == 'Calon Pegawai Kontrak'
                    ? contractSubmission != null
                        ? _buildContractDetail(contractSubmission!)
                        : const Center(child: Text('Invalid submission type'))
                    : permanentSubmission != null
                        ? _buildPermanentDetail(permanentSubmission!)
                        : const Center(child: Text('Invalid submission type')),
              ),
            ),
          ),
        ),
        if (widget.approvalStatus == "pending") _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: AppThemes.outlineButtonPrimaryStyle,
              onPressed: () {
                Utils.showConfirmationDialog(
                  context,
                  buttonText: 'Ya, Tolak',
                  message: 'Apakah Anda Yakin\nTolak Verifikasi Pengajuan?',
                  onConfirm: () {
                    context.read<VerifyCandidateSubmissionCubit>().verifySubmission(
                      VerifyCandidateSubmissionRequest(
                        candidateSubmissionId: widget.candidateId,
                        status: 'REJECTED',
                      ),
                    );
                    Navigator.of(context).pop(); // Close dialog
                  },
                  onCancel: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                );
              },
              child: Text(
                'Tolak',
                style: AppTextStyle.headline5.copyWith(color: AppColors.primaryMain),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Utils.showConfirmationDialog(
                  context,
                  buttonText: 'Ya, Verifikasi',
                  message: 'Apakah Anda Yakin\nTerima Verifikasi Pengajuan?',
                  onConfirm: () {
                    context.read<VerifyCandidateSubmissionCubit>().verifySubmission(
                      VerifyCandidateSubmissionRequest(
                        candidateSubmissionId: widget.candidateId,
                        status: 'ACCEPTED',
                      ),
                    );
                    Navigator.of(context).pop(); // Close dialog
                  },
                  onCancel: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                );
              },
              style: AppThemes.elevatedBUttonPrimaryStyle,
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

  // Contract Submission details
  Widget _buildContractDetail(ContractSubmissionDetail submission) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSubmissionInfo(submission),
        const SizedBox(height: 16),
        _buildPersonalInfo(submission.personalInfo),
      ],
    );
  }

  // Permanent Submission details
  Widget _buildPermanentDetail(PermanentSubmissionDetail submission) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildPermanentSubmissionInfo(submission),
        const SizedBox(height: 16),
        _buildPersonalInfo(submission.personalInfo),
      ],
    );
  }

  // Informasi pengajuan untuk Contract Submission
  Widget _buildSubmissionInfo(ContractSubmissionDetail submission) {
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
              _buildColumn('Jabatan Sebagai', submission.jobPosition),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn('Kontrak Mulai', submission.contractStartDate),
                  _buildColumn('Kontrak Akhir', submission.contractEndDate),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Informasi pengajuan untuk Permanent Submission
  Widget _buildPermanentSubmissionInfo(PermanentSubmissionDetail submission) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pengajuan',
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
              _buildColumn('Waktu Pengajuan', submission.submissionDate),
              const SizedBox(height: 12),
              _buildColumn('Jabatan Sebagai', submission.jobPosition),
            ],
          ),
        ),
      ],
    );
  }

  // Informasi personal
  Widget _buildPersonalInfo(PersonalInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Personal',
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
              _buildColumn('Nama', info.name),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: _buildColumn('Jenis Kelamin', info.gender)),
                  Expanded(
                      flex: 5,
                      child: _buildColumn('Tanggal Lahir', info.dateOfBirth)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: _buildColumn('No. Telepon', info.phoneNumber)),
                  Expanded(flex: 5, child: _buildColumn('Email', info.email)),
                ],
              ),
              const SizedBox(height: 12),
              _buildColumn('Alamat', info.address),
            ],
          ),
        ),
      ],
    );
  }

  // Membuat baris informasi
  Widget _buildColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.caption,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
