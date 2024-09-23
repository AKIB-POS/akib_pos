import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_approved_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_pending_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/candidate_submission/candidate_rejected_submission_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_approved_submission_tab.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_pending_submission_tab.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/candidate_submission/candidate_rejected_submission_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CandidateSubmissionPage extends StatefulWidget {
  const CandidateSubmissionPage({Key? key}) : super(key: key);

  @override
  _CandidateSubmissionPageState createState() => _CandidateSubmissionPageState();
}

class _CandidateSubmissionPageState extends State<CandidateSubmissionPage>
    with SingleTickerProviderStateMixin {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final branchId = _authSharedPref.getBranchId() ?? 0;

    // Fetch data for all three tabs
    context.read<CandidatePendingSubmissionsCubit>().fetchPendingSubmissions(branchId: branchId);
    context.read<CandidateApprovedSubmissionsCubit>().fetchApprovedSubmissions(branchId: branchId);
    context.read<CandidateRejectedSubmissionsCubit>().fetchRejectedSubmissions(branchId: branchId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Calon Pegawai',
          style: AppTextStyle.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryMain
                  .withOpacity(0.1); // Warna saat di-tap
            }
            if (states.contains(WidgetState.focused)) {
              return AppColors.primaryMain
                  .withOpacity(0.2); // Warna saat focused
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryMain
                  .withOpacity(0.05); // Warna saat di-hover
            }
            return null; // Tidak ada warna jika tidak ada aksi
          }),
          controller: _tabController,
          labelColor: AppColors.primaryMain,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryMain,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          tabs: const [
            Tab(child: Align(child: Text('Belum\nDisetujui', textAlign: TextAlign.center))),
            Tab(child: Align(child: Text('Telah\nDisetujui', textAlign: TextAlign.center))),
            Tab(child: Align(child: Text('Ditolak'))),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CandidatePendingSubmissionTab(),
          CandidateApprovedSubmissionTab(),
          CandidateRejectedSubmissionTab(),
        ],
      ),
    );
  }
}
