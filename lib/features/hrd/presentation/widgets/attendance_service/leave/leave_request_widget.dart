import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/leave/leave_request_data.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/leave/leave_request_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class LeaveRequestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveRequestCubit, LeaveRequestState>(
      builder: (context, state) {
        if (state is LeaveRequestLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 16),
              //   child: const Text('Pengajuan Cuti', style: AppTextStyle.bigCaptionBold),
              // ),
              Utils.buildLoadingCardShimmer()
            ],
          );
        } else if (state is LeaveRequestLoaded) {
          if (state.leaveRequests.data.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildRequestList(state.leaveRequests.data);
          }
        } else if (state is LeaveRequestError) {
          return _buildEmptyState(); // Using the empty state for errors as well
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/accounting/empty_report.svg',
            height: 150,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada Pengajuan',
            style: AppTextStyle.bigCaptionBold,
          ),
          const SizedBox(height: 8),
          const Text(
            'Status Pengajuan akan tampil setelah anda\nmengisi form pengajuan cuti',
            textAlign: TextAlign.center,
            style: AppTextStyle.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<LeaveRequestData> requests) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16,left: 16),
      child: Column(
        children:
            requests.map((request) => _buildRequestItem(request)).toList(),
      ),
    );
  }

  Widget _buildRequestItem(LeaveRequestData request) {
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
                Text(
                  request.leaveType,
                  style: AppTextStyle.headline5,
                ),
                const SizedBox(height: 8),
                Text(
                  "${request.startDate} - ${request.endDate}",
                  style: AppTextStyle.caption
                      .copyWith(color: AppColors.textGrey800),
                ),
                const SizedBox(height: 12),
                _buildApprovalStatusRow(
                    'Status Persetujuan', request.approverName),
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
        date, // Assuming the date is already formatted as needed
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
