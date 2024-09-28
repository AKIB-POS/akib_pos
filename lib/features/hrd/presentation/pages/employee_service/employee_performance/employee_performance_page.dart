import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/employee_performance.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/employee_performance_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/employee_performance/submit_employee_performance_page.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/employee_performance/employee_performance_top.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

class EmployeePerformancePage extends StatefulWidget {
  const EmployeePerformancePage({super.key});

  @override
  _EmployeePerformancePageState createState() =>
      _EmployeePerformancePageState();
}

class _EmployeePerformancePageState extends State<EmployeePerformancePage> {
  final int currentYear = DateTime.now().year;
  final String currentMonth = Utils.getMonthString(DateTime.now().month);
  String selectedMonth = Utils.getMonthString(DateTime.now().month);
  int selectedYear = DateTime.now().year;
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchEmployeePerformanceData();
  }

  Future<void> _fetchEmployeePerformanceData() async {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<EmployeePerformanceCubit>().fetchEmployeePerformance(
          branchId: branchId,
          month: Utils.getMonthNumber(selectedMonth).toString(),
          year: selectedYear.toString(),
        );
  }

  Future<void> _selectMonthYear() async {
    final result = await showMonthYearPickerDialog(
      context,
      2024,
      currentYear,
      currentMonth,
    );

    if (result != null) {
      setState(() {
        selectedMonth = result['month'];
        selectedYear = result['year'];
      });
      _fetchEmployeePerformanceData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          // Top section for selecting Month & Year
          EmployeePerformanceTop(
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            onMonthYearTap: _selectMonthYear,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchEmployeePerformanceData,
              child: BlocBuilder<EmployeePerformanceCubit,
                  EmployeePerformanceState>(
                builder: (context, state) {
                  if (state is EmployeePerformanceLoading) {
                    return _buildShimmerLoading();
                  } else if (state is EmployeePerformanceError) {
                    return Utils.buildErrorState(
                      title: 'Gagal Memuat Data',
                      message: state.message,
                      onRetry: () {
                        _fetchEmployeePerformanceData();
                      },
                    );
                  } else if (state is EmployeePerformanceLoaded) {
                    return state.employeePerformances.isEmpty
                        ? Utils.buildEmptyState("Belum ada Riwayat",
                            "Riwayat akan tampil setelah\nizin anda telah selesai")
                        : _buildEmployeePerformanceList(
                            state.employeePerformances);
                  }
                  return const Center(child: Text('Tidak ada data.'));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) => Utils.buildLoadingCardShimmer(),
    );
  }

  Widget _buildEmployeePerformanceList(List<EmployeePerformance> performances) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: performances.length,
      itemBuilder: (context, index) {
        final employee = performances[index];
        return _buildEmployeeCard(employee);
      },
    );
  }

  Widget _buildEmployeeCard(EmployeePerformance employee) {
    Color backgroundColor;
    Color textColor;
    if (employee.employeeType == 'Contract Employee') {
      backgroundColor = AppColors.secondaryMain.withOpacity(0.1);
      textColor = AppColors.secondaryMain;
    } else {
      backgroundColor = AppColors.successMain.withOpacity(0.1);
      textColor = AppColors.successMain;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      employee.employeeType,
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    employee.employeeName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.role,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              if (employee.performanceScore == null)
                OutlinedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubmitEmployeePerformancePage(
                          employeePerformanceId: employee.employeePerformanceId,
                          employeeName: employee.employeeName,
                          role: employee.role,
                        ),
                      ),
                    );

                    // If the result is true, refresh the employee data
                    if (result == true) {
                      _fetchEmployeePerformanceData();
                    }
                  },
                  style: AppThemes.outlineButtonPrimaryStyle,
                  child: const Text('Nilai',
                      style: TextStyle(color: AppColors.primaryMain)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          employee.performanceScore != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Total Nilai: ${employee.performanceScore}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : const Text(
                  'Belum ada nilai pegawai',
                  style: TextStyle(color: Colors.red),
                ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> showMonthYearPickerDialog(BuildContext context,
      int initialYear, int maxYear, String initialMonth) async {
    // Daftar bulan
    final List<String> allMonths = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    // Dapatkan bulan dan tahun saat ini
    final int currentYear = DateTime.now().year;
    final int currentMonth = DateTime.now().month;

    // Inisialisasi bulan dan tahun yang dipilih
    String selectedMonth = initialMonth;
    int selectedYear = initialYear;

    // Filter bulan berdasarkan tahun yang dipilih
    List<String> getAvailableMonths(int selectedYear) {
      if (selectedYear == currentYear) {
        // Jika tahun yang dipilih adalah tahun ini, tampilkan bulan hingga bulan saat ini
        return allMonths.sublist(
            0, currentMonth); // Hanya sampai bulan saat ini
      } else {
        // Jika bukan tahun ini, tampilkan semua bulan
        return allMonths;
      }
    }

    List<String> availableMonths = getAvailableMonths(initialYear);

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMain, // Warna tombol
            ),
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Pilih Bulan & Tahun',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                children: [
                  // Dropdown untuk memilih bulan
                  DropdownButtonFormField2<String>(
                    value: selectedMonth,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    isExpanded: true,
                    items: availableMonths.map((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedMonth = newValue!;
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8), // Padding pada button dropdown
                      height: 48, // Atur tinggi dropdown button
                      width: double.infinity, // Atur lebar button dropdown
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24, // Ukuran ikon dropdown
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            8), // Radius untuk dropdown menu
                      ),
                      maxHeight: 200, // Maksimum tinggi dropdown
                    ),
                  ),
                  // YearPicker untuk memilih tahun
                  Expanded(
                    child: YearPicker(
                      selectedDate: DateTime(selectedYear),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(maxYear),
                      onChanged: (DateTime dateTime) {
                        setState(() {
                          selectedYear = dateTime.year;
                          availableMonths = getAvailableMonths(
                              selectedYear); // Update bulan yang tersedia
                        });
                      },
                    ),
                  ),
                ],
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
                  Navigator.of(context)
                      .pop({'month': selectedMonth, 'year': selectedYear});
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
