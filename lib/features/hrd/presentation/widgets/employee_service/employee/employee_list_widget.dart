import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/hrd_all_employee.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/hrd_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/pages/employee_service/employee/employee_detail_page.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HRDEmployeeListWidget extends StatelessWidget {
  const HRDEmployeeListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HRDAllEmployeesCubit, HRDAllEmployeesState>(
      builder: (context, state) {
        if (state is HRDAllEmployeesLoading) {
          return ListView.builder(
            itemCount: 5, // Jumlah shimmer loading card
            itemBuilder: (context, index) => Utils.buildLoadingCardShimmer(),
          );
        } else if (state is HRDAllEmployeesError) {
          return Utils.buildEmptyState('Error', state.message);
        } else if (state is HRDAllEmployeesLoaded) {
          if (state.employeeList.isEmpty) {
            // Tampilkan jika tidak ada data
            return Utils.buildEmptyState('Tidak ada pegawai', 'Belum ada pegawai yang ditemukan');
          } else {
            // Tampilkan daftar pegawai
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.employeeList.length,
              itemBuilder: (context, index) {
                final employee = state.employeeList[index];
                return _buildEmployeeCard(employee,context); // Panggil fungsi untuk menampilkan kartu pegawai
              },
            );
          }
        }
        return const Center(child: Text('Tidak ada data tersedia.'));
      },
    );
  }

  // Widget untuk menampilkan setiap kartu pegawai
  Widget _buildEmployeeCard(HRDAllEmployee employee,BuildContext context) {
    // Tentukan warna berdasarkan jenis pegawai
    Color backgroundColor;
    Color textColor;
    if (employee.employeeType == 'Pegawai Kontrak') {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Informasi pegawai
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jenis Pegawai
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  employee.employeeType,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              // Nama pegawai
              Text(
                employee.employeeName,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Jabatan pegawai
              Text(
                employee.role ?? "Belum Ada Role",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          // Tombol detail
          OutlinedButton(
            onPressed: () {
              Utils.navigateToPage(context, EmployeeDetailPage(employeeId: employee.employeeId, employeeType: employee.employeeType));
            },
            style: AppThemes.outlineButtonPrimaryStyle,
            child: const Text('Detail', style: TextStyle(color: AppColors.primaryMain)),
          ),
        ],
      ),
    );
  }
}
