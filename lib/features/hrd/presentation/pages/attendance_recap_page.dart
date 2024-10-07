import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/attenddance_recap.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/attendance_recap_interaction_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/attendance_recap/date_range_attendance_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/attendance_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_recap/attendance_recap_content_widget.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/attendance_recap/attendance_recap_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AttendanceRecapPage extends StatefulWidget {
  const AttendanceRecapPage({super.key});

  @override
  _AttendanceRecapPageState createState() => _AttendanceRecapPageState();
}

class _AttendanceRecapPageState extends State<AttendanceRecapPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();
  late final int branchId;
  late final int companyId;
  DateTime? customStartDate = DateTime.now();
  DateTime? customEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;

    _fetchAttendanceRecap();
  }


 void _fetchAttendanceRecap() {
  final dateRangeCubit = context.read<DateRangeAttendanceCubit>();
  final dateRange = dateRangeCubit.state;

  // Ambil employeeId dari AttendanceRecapInteractionCubit
  final interactionCubit = context.read<AttendanceRecapInteractionCubit>();
  final employeeId = interactionCubit.state.employeeId;

  final cubit = context.read<AttendanceRecapCubit>();

  cubit.fetchAttendanceRecap(
    branchId: branchId,
    employeeId: employeeId,  // Ambil employeeId dari state cubit
    date: dateRange, 
  );
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchAttendanceRecap();
        },
        color: AppColors.primaryMain,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              AttendanceRecapTop(
                onDateTap: () => _selectDate(context),
                onEmployeeTap: () => _showEmployeePicker(context),
              ),
               AttendanceRecapContentWidget(),
            ],
          ),
        ),
      ),
    );
  }
  


  void _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final cubit = context.read<DateRangeAttendanceCubit>();
            DateRangeOption tempSelectedOption = cubit.selectedOption;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 8,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.textGrey300,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Tanggal',
                          style: AppTextStyle.headline5,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (var option in DateRangeOption.values)
                    RadioListTile<DateRangeOption>(
                      title: Text(_getOptionTitle(option)),
                      value: option,
                      groupValue: tempSelectedOption,
                      activeColor: AppColors.primaryMain,
                      contentPadding: const EdgeInsets.only(left: 0),
                      onChanged: (DateRangeOption? value) async {
                        setState(() {
                          tempSelectedOption = value!;
                          cubit.selectedOption = value;
                        });

                        if (value == DateRangeOption.custom) {
                          setState(() {
                            customStartDate = DateTime.now();
                            customEndDate = DateTime.now();
                          });
                        }
                      },
                    ),
                  if (tempSelectedOption == DateRangeOption.custom)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: GestureDetector(
                              onTap: () async {
                                final selectedDate = await _selectCustomDate(
                                  context,
                                  customStartDate!,
                                  DateTime(2000),
                                  DateTime.now(),
                                );

                                if (selectedDate != null) {
                                  setState(() {
                                    customStartDate = selectedDate;
                                    customEndDate = selectedDate;
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Mulai Dari"),
                                  Text(_formatDate(customStartDate!)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 5,
                            child: GestureDetector(
                              onTap: () async {
                                final selectedDate = await _selectCustomDate(
                                  context,
                                  customEndDate!,
                                  customStartDate!,
                                  customStartDate!
                                      .add(const Duration(days: 30)),
                                );

                                if (selectedDate != null) {
                                  setState(() {
                                    customEndDate = selectedDate;
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Sampai"),
                                  Text(_formatDate(customEndDate!)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (tempSelectedOption != DateRangeOption.custom ||
                      customStartDate != null && customEndDate != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryMain,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          if (tempSelectedOption == DateRangeOption.today) {
                            cubit.selectToday();
                          } else if (tempSelectedOption ==
                              DateRangeOption.last7Days) {
                            cubit.selectLast7Days();
                          } else if (tempSelectedOption ==
                              DateRangeOption.last30Days) {
                            cubit.selectLast30Days();
                          } else if (tempSelectedOption ==
                              DateRangeOption.custom) {
                            if (customStartDate != null &&
                                customEndDate != null) {
                              cubit.selectCustomRange(
                                  customStartDate!, customEndDate!);
                            }
                          }

                          // After selecting date range, reload data
                          _fetchAttendanceRecap();
                        },
                        child: const Text(
                          'Terapkan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<DateTime?> _selectCustomDate(BuildContext context,
      DateTime initialDate, DateTime firstDate, DateTime lastDate) async {
    DateTime selectedDate = initialDate;

    await showDialog<DateTime?>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain,
            ),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Pilih Tanggal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: firstDate,
                lastDate: lastDate,
                onDateChanged: (DateTime date) {
                  selectedDate = date;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMain,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(selectedDate);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );

    return selectedDate;
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _getOptionTitle(DateRangeOption option) {
    switch (option) {
      case DateRangeOption.today:
        return 'Hari Ini';
      case DateRangeOption.last7Days:
        return '7 Hari Terakhir';
      case DateRangeOption.last30Days:
        return '30 Hari Terakhir';
      case DateRangeOption.custom:
        return 'Pilih Tanggal Sendiri';
    }
  }

  void _showEmployeePicker(BuildContext context) async {
    final cubit = context.read<AttendanceRecapInteractionCubit>();
    final employees = cubit.getEmployeeList();
    String? tempSelectedEmployee = cubit.state.employeeName;

    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 8,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.textGrey300,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Karyawan',
                          style: AppTextStyle.headline5,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Make the list scrollable
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        return RadioListTile<String>(
                          title: Text(employee.employeeName),
                          value: employee.employeeName,
                          groupValue: tempSelectedEmployee,
                          dense: true,
                          activeColor: AppColors.primaryMain,
                          toggleable: true,
                          contentPadding: const EdgeInsets.only(left: 0),
                          visualDensity: VisualDensity.compact,
                          onChanged: (String? value) {
                            setState(() {
                              tempSelectedEmployee =
                                  value ?? tempSelectedEmployee;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll<Color>(
                            AppColors.primaryMain),
                        padding:
                            const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 16),
                        ),
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (tempSelectedEmployee != null) {
                          cubit.selectEmployee(tempSelectedEmployee!);
                          _fetchAttendanceRecap();
                        }
                      },
                      child: const Text(
                        'Terapkan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
