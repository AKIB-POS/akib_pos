import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/attendance_service/check_in_out_request.dart';
import 'package:akib_pos/features/hrd/data/models/attenddance_recap.dart';
import 'package:akib_pos/features/hrd/data/models/hrd_summary.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/attendance_history_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_in_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_service/check_out_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_service/attendance_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  final HRDSummaryResponse data;

  AttendancePage({required this.data});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchAttendanceHistory();
  }

  void _fetchAttendanceHistory() {
    context.read<AttendanceHistoryCubit>().fetchAttendanceHistory(); // No parameters needed
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _performCheckIn(BuildContext context) async {
    final time = DateFormat('HH:mm').format(DateTime.now());
    final position = await _getCurrentLocation(); // Get the user's location
    final lat = position.latitude;
    final long = position.longitude;

    final request = CheckInOutRequest(
      time: time,
      lat: lat,
      long: long,
    );

    context.read<CheckInCubit>().checkIn(request);
  }

  void _performCheckOut(BuildContext context) async {
    final time = DateFormat('HH:mm').format(DateTime.now());

    final position = await _getCurrentLocation(); // Get the user's location
    final lat = position.latitude;
    final long = position.longitude;

    final request = CheckInOutRequest(
      time: time,
      lat: lat,
      long: long,
    );

    context.read<CheckOutCubit>().checkOut(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Absensi', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: BlocListener<CheckInCubit, CheckInState>(
        listener: (context, state) {
          if (state is CheckInLoading) {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is CheckInSuccess) {
            // Close loading dialog
            Navigator.of(context).pop();

            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            // Refresh attendance history data
            _fetchAttendanceHistory();
          } else if (state is CheckInError) {
            // Close loading dialog
            Navigator.of(context).pop();

            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocListener<CheckOutCubit, CheckOutState>(
          listener: (context, state) {
            if (state is CheckOutLoading) {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
            } else if (state is CheckOutSuccess) {
              // Close loading dialog
              Navigator.of(context).pop();

              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              // Refresh attendance history data
              _fetchAttendanceHistory();
            } else if (state is CheckOutError) {
              // Close loading dialog
              Navigator.of(context).pop();

              // Show error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              _fetchAttendanceHistory(); // Refresh the attendance history
            },
            color: AppColors.primaryMain,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: AppColors.backgroundGrey,
                    child: Column(
                      children: [
                        _buildAttendanceBody(context),
                        Container(
                        width: double.infinity,
                        height: 20,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                      ),
                      ],
                    )),
                  AttendanceHistoryWidget(), 
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceBody(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'ID').format(now);

    // Parse expectedClockInTime to a DateTime object
    DateTime? expectedClockInDateTime;
    if (widget.data.expectedClockInTime != null) {
      expectedClockInDateTime = DateFormat('HH:mm').parse(widget.data.expectedClockInTime!);
    }

    // Determine button colors
    bool isClockInEnabled = widget.data.clockInTime == null &&
                            (expectedClockInDateTime != null && now.isAfter(expectedClockInDateTime));
    bool isClockOutEnabled = widget.data.clockInTime != null && widget.data.clockOutTime == null;

    return Container(
      margin: EdgeInsets.all(21),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.textGrey300,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Text(
                  formattedDate,
                  style: AppTextStyle.body2,
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.data.expectedClockInTime} - ${widget.data.expectedClockOutTime}",
                  style: AppTextStyle.headline5.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Absen Masuk', style: AppTextStyle.caption),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.data.clockInTime != null
                          ? AppColors.successMain.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.data.clockInTime ?? '-- : --',
                      style: AppTextStyle.bigCaptionBold.copyWith(
                        color: widget.data.clockInTime != null
                            ? AppColors.successMain
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.textGrey300,
              ),
              Column(
                children: [
                  const Text('Absen Pulang', style: AppTextStyle.caption),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.data.clockOutTime != null
                          ? AppColors.errorMain.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.data.clockOutTime ?? '-- : --',
                      style: AppTextStyle.bigCaptionBold.copyWith(
                        color: widget.data.clockOutTime != null
                            ? AppColors.errorMain
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              _buildActionButton(
                context,
                'Masuk',
                isClockInEnabled ? AppColors.successMain : Colors.grey,
                isClockInEnabled ? () => _performCheckIn(context) : null,
              ),
              const SizedBox(width: 10),
              _buildActionButton(
                context,
                'Keluar',
                isClockOutEnabled ? AppColors.errorMain : Colors.grey,
                isClockOutEnabled ? () => _performCheckOut(context) : null,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      
    );
  }

  Widget _buildActionButton(BuildContext context, String text, Color color, VoidCallback? onPressed) {
    return Expanded(
      child: SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}