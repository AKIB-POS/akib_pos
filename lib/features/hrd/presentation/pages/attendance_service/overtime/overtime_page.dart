import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/submit_overtime.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_request_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_service/overtime/submit_overtime_request_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/overtime/overtime_history.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/overtime/overtime_request_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class OvertimePage extends StatefulWidget {
  const OvertimePage({super.key});

  @override
  _OvertimePageState createState() => _OvertimePageState();
}

class _OvertimePageState extends State<OvertimePage> {
  @override
  void initState() {
    super.initState();
    _fetchOvertimeRequests();
    _fetchOvertimeHistory();
  }

  void _fetchOvertimeRequests() {
    context.read<OvertimeRequestCubit>().fetchOvertimeRequests();
  }

  void _fetchOvertimeHistory() {
    context.read<OvertimeHistoryCubit>().fetchOvertimeHistory();
  }

  Future<void> _refreshOvertimeData() async {
    _fetchOvertimeRequests();
    _fetchOvertimeHistory(); // Refresh overtime history
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Lembur', style: AppTextStyle.headline5),
          backgroundColor: Colors.white,
          titleSpacing: 0,
          elevation: 0,
          actions: [
            IconButton(
              icon:
                  const Icon(Icons.info_outline, color: AppColors.primaryMain),
              onPressed: () {
                // Handle info button press
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshOvertimeData,
          color: AppColors.primaryMain,
          child: ListView(
            children: [
              Container(
                color: AppColors.backgroundGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Text('Pengajuan Lembur',
                          style: AppTextStyle.bigCaptionBold),
                    ),
                    const OvertimeRequestWidget(),
                    const SizedBox(
                      height: 12,
                    ), // Display overtime requests
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add OvertimeHistoryWidget
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text('Riwayat Lembur',
                        style: AppTextStyle.bigCaptionBold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: OvertimeHistoryWidget(),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: Utils.buildFloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SubmitOvertimeRequestPage(),
              ),
            );

            // Jika result true, refresh data cuti
            if (result == true) {
              _refreshOvertimeData(); // Panggil fungsi untuk refresh data
            }
          },
        ));
  }
}
