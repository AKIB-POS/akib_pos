// import 'package:akib_pos/common/app_colors.dart';
// import 'package:akib_pos/common/app_text_styles.dart';
// import 'package:akib_pos/features/accounting/presentation/pages/accounting_page.dart';
// import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
// import 'package:akib_pos/features/hrd/data/models/attendance_summary.dart';
// import 'package:akib_pos/features/hrd/presentation/bloc/attendance_summary_cubit.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shimmer/shimmer.dart';

// class SummaryAttendance extends StatelessWidget {
//   final String? role;
//   final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

//   SummaryAttendance({required this.role});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AttendanceSummaryCubit, AttendanceSummaryState>(
//       builder: (context, state) {
//         if (state is AttendanceSummaryLoading) {
//           return _buildLoadingShimmer();
//         } else if (state is AttendanceSummaryError) {
//           return Center(
//             child: Text(state.message, style: AppTextStyle.caption),
//           );
//         } else if (state is AttendanceSummaryLoaded) {
//           final data = state.attendanceSummary.data;
//           return _buildAttendanceContent(data);
//         } else {
//           return _buildLoadingShimmer();
//         }
//       },
//     );
//   }

//   Widget _buildLoadingShimmer() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   children: [
//                     Text('Absen Masuk', style: AppTextStyle.caption),
//                     const SizedBox(height: 8),
//                     Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: Container(
//                         width: 80,
//                         height: 24,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   width: 2,
//                   height: 40,
//                   color: AppColors.textGrey300,
//                 ),
//                 Column(
//                   children: [
//                     Text('Absen Pulang', style: AppTextStyle.caption),
//                     const SizedBox(height: 8),
//                     Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: Container(
//                         width: 80,
//                         height: 24,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           _buildMiddleSectionShimmer(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMiddleSectionShimmer() {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(12),
//         bottomRight: Radius.circular(12),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // SVG Background
//             Positioned.fill(
//               child: SvgPicture.asset(
//                 'assets/images/hrd/bg_card_summary.svg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildInfoColumnShimmer(),
//                   _buildInfoColumnShimmer(),
//                   if (role != "employee") _buildInfoColumnShimmer(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoColumnShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         children: [
//           Container(
//             width: 40,
//             height: 20,
//             color: Colors.white,
//           ),
//           const SizedBox(height: 4),
//           Container(
//             width: 60,
//             height: 16,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAttendanceContent(AttendanceSummaryData data) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   children: [
//                     Text('Absen Masuk', style: AppTextStyle.caption),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: AppColors.successMain.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         data.clockInTime ?? '-- : --',
//                         style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.successMain),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   width: 2,
//                   height: 40,
//                   color: AppColors.textGrey300,
//                 ),
//                 Column(
//                   children: [
//                     Text('Absen Pulang', style: AppTextStyle.caption),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: AppColors.errorMain.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         data.clockOutTime ?? '-- : --',
//                         style: AppTextStyle.bigCaptionBold.copyWith(color: AppColors.errorMain),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           _buildMiddleSection(data),
//         ],
//       ),
//     );
//   }

//   Widget _buildMiddleSection(Attendance data) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(12),
//         bottomRight: Radius.circular(12),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // SVG Background
//             Positioned.fill(
//               child: SvgPicture.asset(
//                 'assets/images/hrd/bg_card_summary.svg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // Content
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildInfoColumn(data.leaveBalance.toString(), 'Saldo Cuti'),
//                       _buildInfoColumn(data.permissionBalance.toString(), 'Saldo Izin'),
//                       if (role != "employee")
//                         _buildInfoColumn((data.requestBalance ?? 0).toString(), 'Pengajuan'),
//                     ],
//                   ),
//                   if (role != "employee") _buildEmployeeSubmissionSection(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmployeeSubmissionSection() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   SvgPicture.asset(
//                     'assets/icons/hrd/ic_employee_submission.svg',
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Cek Pengajuan Karyawan',
//                     style: AppTextStyle.caption.copyWith(color: AppColors.primaryMain),
//                   ),
//                 ],
//               ),
//               const Icon(Icons.arrow_forward, color: AppColors.primaryMain),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoColumn(String value, String label) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: AppTextStyle.bigCaptionBold.copyWith(color: Colors.white),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
