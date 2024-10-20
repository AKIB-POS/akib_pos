import 'dart:ffi';

import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/data/models/login_response.dart';
import 'package:akib_pos/features/hrd/data/models/hrd_summary.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/hrd_summary_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/submission/candidate/candidate_submission_page.dart';
import 'package:akib_pos/features/hrd/presentation/pages/submission/employee/employee_submission_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;

import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';

class SummaryHRD extends StatelessWidget {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  Widget build(BuildContext context) {
    // Ambil mobile permissions dari AuthSharedPref
    final MobilePermissions? permissions = _authSharedPref.getMobilePermissions();

    return BlocBuilder<HRDSummaryCubit, HRDSummaryState>(
      builder: (context, state) {
        if (state is HRDSummaryLoading) {
          return _buildShimmerLoading();
        } else if (state is HRDSummaryError) {
          return Center(
              child: Text(state.message, style: AppTextStyle.caption));
        } else if (state is HRDSummaryLoaded) {
          final data = state.hrdSummary;

          // Cek apakah user punya akses untuk fitur "employee-candidate" dan "employee-submission-request"
          final bool hasCandidateAccess = permissions?.hrd.contains('employee-candidate') ?? false;
          final bool hasSubmissionAccess = permissions?.hrd.contains('employee-submission-request') ?? false;

          // Tampilkan teks dan card jika salah satu atau keduanya punya akses
          final bool showVerificationSection = hasCandidateAccess || hasSubmissionAccess;

          return Container(
            width: double.infinity,
            child: Column(
              children: [
                // Tampilkan konten berdasarkan peran (role) dari user
                if (_authSharedPref.getEmployeeRole() == "owner")
                  _buildUiTotalEmployee(data.totalEmployee),
                if (_authSharedPref.getEmployeeRole() != "owner")
                  _buildSummaryContent(data),

                // Tampilkan bagian "Layanan Verifikasi" hanya jika salah satu fitur diakses
                if (showVerificationSection)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Layanan Verifikasi",
                          style: AppTextStyle.headline5,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Tampilkan "Candidate Verification" hanya jika punya akses
                            if (hasCandidateAccess)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Utils.navigateToPage(context, const CandidateSubmissionPage());
                                  },
                                  child: _buildCandidateVerificationCard(
                                      data.totalCandidateVerifications),
                                ),
                              ),

                            // Tampilkan "Submission Verification" hanya jika punya akses
                            if (hasSubmissionAccess)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Utils.navigateToPage(context, const EmployeeSubmissionPage());
                                  },
                                  child: _buildSubmissionVerificationCard(
                                      data.totalSubmissionVerifications),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        } else {
          return _buildShimmerLoading();
        }
      },
    );
  }

  Widget _buildShimmerLoading() {
    // Shimmer effect for dynamic values (not static labels)
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          if(_authSharedPref.getEmployeeRole() != "owner")
            _buildShimmerSummaryContent(),
          if (_authSharedPref.getEmployeeRole() != "employee")
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildShimmerVerificationCard("Calon\nPegawai")),
                  Expanded(child: _buildShimmerVerificationCard("Pengajuan\nKaryawan")),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerSummaryContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShimmerClockInOutColumn('Absen Masuk'),
                Container(width: 2, height: 40, color: AppColors.textGrey300),
                _buildShimmerClockInOutColumn('Absen Pulang'),
              ],
            ),
          ),
          _buildShimmerMiddleSection(),
        ],
      ),
    );
  }

  Widget _buildShimmerClockInOutColumn(String label) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.caption), // Static label
        const SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 80,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerMiddleSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/hrd/bg_card_summary.svg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShimmerInfoColumn("Saldo Cuti"),
                  _buildShimmerInfoColumn("Alpa"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerInfoColumn(String label) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 50,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 4),
         Text(label, style: const TextStyle(color: Colors.white)), // Static label
      ],
    );
  }

  Widget _buildShimmerVerificationCard(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 30,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                 Text(label, style: AppTextStyle.bigCaptionBold), // Static label
              ]
            ),
            SvgPicture.asset('assets/icons/hrd/ic_employee_candidate.svg',
                height: 40, width: 40),
          ],
        ),
      ),
    );
  }

  // Summary content once data is loaded
  Widget _buildSummaryContent(HRDSummaryResponse data) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildClockInOutColumn(
                  'Absen Masuk',
                  data.clockInTime ?? '-- : --',
                  AppColors.successMain,
                ),
                Container(
                    width: 2, height: 40, color: AppColors.textGrey300),
                _buildClockInOutColumn(
                  'Absen Pulang',
                  data.clockOutTime ?? '-- : --',
                  AppColors.errorMain,
                ),
              ],
            ),
          ),
          _buildMiddleSection(data),
        ],
      ),
    );
  }

  Widget _buildClockInOutColumn(String label, String time, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.caption),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time,
            style: AppTextStyle.bigCaptionBold.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildMiddleSection(HRDSummaryResponse data) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/hrd/bg_card_summary.svg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn(data.leaveBalance ?? 0, 'Saldo Cuti'),
                  _buildInfoColumn(data.totalAbsences ?? 0, 'Alpha'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(int value, String label) {
    return Column(
      children: [
        Text(
          "$value",
          style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildCandidateVerificationCard(int? totalCandidateVerifications) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: _buildVerificationCard(
        totalCandidateVerifications ?? 0,
        'Calon\nPegawai',
        'assets/icons/hrd/ic_employee_candidate.svg',
      ),
    );
  }

  Widget _buildSubmissionVerificationCard(int? totalSubmissionVerifications) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: _buildVerificationCard(
        totalSubmissionVerifications ?? 0,
        'Pengajuan\nKaryawan',
        'assets/icons/hrd/ic_application_verification.svg',
      ),
    );
  }

  Widget _buildVerificationCard(int total, String label, String assetPath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.primaryBackgorund,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  total.toString(),
                  style: AppTextStyle.bigCaptionBold
                      .copyWith(color: AppColors.primaryMain),
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyle.bigCaptionBold),
            ],
          ),
          SvgPicture.asset(assetPath, height: 40, width: 40),
        ],
      ),
    );
  }
  
  Widget _buildUiTotalEmployee(int? totalEmployee) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 16,left: 16,top: 21,bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image:  const DecorationImage(
          image: svgProvider.Svg('assets/images/hrd/bg_total_employee.svg'),
          fit: BoxFit.cover
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Pegawai",style: AppTextStyle.caption.copyWith(color: Colors.white),),
          SizedBox(height: 10,),
          Text("$totalEmployee Orang",style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),)
        ],
      ),
    );
  }
}
