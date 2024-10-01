import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/overtime/overtime_request.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/overtime/overtime_request)cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class OvertimeRequestWidget extends StatelessWidget {
  const OvertimeRequestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OvertimeRequestCubit, OvertimeRequestState>(
      builder: (context, state) {
        if (state is OvertimeRequestLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Utils.buildLoadingCardShimmer()],
          );
        } else if (state is OvertimeRequestLoaded) {
          if (state.overtimeRequests.data.isEmpty) {
            return Utils.buildEmptyStatePlain("Belum Ada Pengajuan", "tatus Pengajuan akan tampil setelah anda\nmengisi form pengajuan lembur");
          } else {
            return _buildRequestList(state.overtimeRequests.data);
          }
        } else if (state is OvertimeRequestError) {
          return Utils.buildEmptyStatePlain("Ada Kesalahan", state.message);
        } else {
          return Container();
        }
      },
    );
  }


  Widget _buildRequestList(List<OvertimeRequest> requests) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16, left: 16),
      child: Column(
        children: requests.map((request) => _buildRequestItem(request)).toList(),
      ),
    );
  }

  Widget _buildRequestItem(OvertimeRequest request) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(request.requestDate),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.overtimeDescription,
                        style: AppTextStyle.headline5,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        // Handle detail button press
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryMain),
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                      ),
                      child: Text('Detail', style: TextStyle(color: AppColors.primaryMain)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Mulai Lembur: ${request.startDatetime}',
                  style: AppTextStyle.caption.copyWith(color: AppColors.textGrey800),
                ),
                Text(
                  'Selesai Lembur: ${request.endDatetime}',
                  style: AppTextStyle.caption.copyWith(color: AppColors.textGrey800),
                ),
                const SizedBox(height: 12),
                _buildApprovalStatusRow('Status Persetujuan', request.approverName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the date header
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

  // Widget for displaying approval status
  Widget _buildApprovalStatusRow(String title, String approverName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.backgroundGrey,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.caption,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "$approverName : ",
                style: AppTextStyle.caption,
              ),
              const SizedBox(width: 2),
              SvgPicture.asset(
                'assets/icons/hrd/ic_clock_pending.svg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}