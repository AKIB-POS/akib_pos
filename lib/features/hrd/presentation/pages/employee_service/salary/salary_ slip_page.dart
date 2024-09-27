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
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchSalarySlips();
  }

  void _fetchSalarySlips() {
    context.read<SalarySlipCubit>().fetchSalarySlips(year: selectedYear);
  }

  Future<void> _selectYear() async {
    int? year = await showYearPickerDialog(context, selectedYear, currentYear);
    if (year != null && year != selectedYear) {
      setState(() {
        selectedYear = year;
      });
      _fetchSalarySlips();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          // AppBar is outside the scrollable content
          SalarySlipTop(
            selectedYear: selectedYear,
            onYearTap: _selectYear,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _fetchSalarySlips();
              },
              color: AppColors.primaryMain,
              child: BlocBuilder<SalarySlipCubit, SalarySlipState>(
                builder: (context, state) {
                  if (state is SalarySlipLoading) {
                    return _buildShimmerLoading();
                  } else if (state is SalarySlipError) {
                    return Center(child: Text(state.message));
                  } else if (state is SalarySlipLoaded) {
                    return _buildSalarySlipList(state.salarySlips.salarySlips);
                  } else {
                    return Container();
                  }
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
      shrinkWrap: true,
      itemCount: 6,
      padding: const EdgeInsets.symmetric(vertical: 16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSalarySlipList(List<SalarySlip> slips) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: slips.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final slip = slips[index];
        return GestureDetector(
          onTap: () {
            // Navigate to SalarySlipDetails page with parameters
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalarySlipDetails(
                  monthName: slip.monthName,
                  year: selectedYear,
                  slipId: slip.slipId,
                  
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
                    '${slip.monthName} $selectedYear',
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
                        // Close the dialog and return the selected year
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
