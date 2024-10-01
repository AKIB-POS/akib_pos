import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/salary/salary_slip.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/salary/salary_slip_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/salary/salary_slips_details.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/salary/salary_slip_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class SalarySlipPage extends StatefulWidget {
  const SalarySlipPage({Key? key}) : super(key: key);

  @override
  _SalarySlipPageState createState() => _SalarySlipPageState();
}

class _SalarySlipPageState extends State<SalarySlipPage> {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // List of months
  final List<String> months = [
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
    'Desember',
  ];

  // Get the list of months up to the current month if the selected year is the current year
  List<String> _getAvailableMonths() {
    if (selectedYear == currentYear) {
      return months.sublist(0, currentMonth); // Limit months to the current month
    }
    return months; // Otherwise, show all months
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          SalarySlipTop(
            selectedYear: selectedYear,
            onYearTap: _selectYear,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // No data fetch, just refresh the UI
                setState(() {});
              },
              color: AppColors.primaryMain,
              child: _buildSalarySlipList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalarySlipList() {
    List<String> availableMonths = _getAvailableMonths();
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: availableMonths.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final monthName = availableMonths[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalarySlipDetails(
                  month: index+1,
                  year: selectedYear,
                  monthName: monthName,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$monthName $selectedYear',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectYear() async {
    int? year = await showYearPickerDialog(context, selectedYear, currentYear);
    if (year != null && year != selectedYear) {
      setState(() {
        selectedYear = year;
      });
    }
  }

  Future<int?> showYearPickerDialog(
      BuildContext context, int initialYear, int maxYear) async {
    int? selectedYear = initialYear;

    return showDialog<int>(
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
              'Pilih Tahun',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: YearPicker(
                      selectedDate: DateTime(selectedYear!),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(maxYear),
                      onChanged: (DateTime dateTime) {
                        setState(() {
                          selectedYear = dateTime.year;
                        });
                        Navigator.of(context).pop(dateTime.year);
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
                  Navigator.of(context).pop(selectedYear);
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
