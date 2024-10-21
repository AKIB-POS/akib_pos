import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/administration/employee_warning.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/employee_warning_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class EmployeeWarningPage extends StatefulWidget {
  const EmployeeWarningPage({Key? key}) : super(key: key);

  @override
  _EmployeeWarningPageState createState() => _EmployeeWarningPageState();
}

class _EmployeeWarningPageState extends State<EmployeeWarningPage> {
  @override
  void initState() {
    super.initState();
    // Memanggil fetchEmployeeWarnings saat halaman diinisialisasi
    _fetchEmployeeWarnings();
  }

  void _fetchEmployeeWarnings() {
    // Panggil fetchEmployeeWarnings dari cubit
    context.read<EmployeeWarningCubit>().fetchEmployeeWarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: const Text('Surat Peringatan',style: AppTextStyle.headline5,),
      ),
      body: BlocBuilder<EmployeeWarningCubit, EmployeeWarningState>(
        builder: (context, state) {
          if (state is EmployeeWarningLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeWarningError) {
            return  Utils.buildErrorState(
          title: 'Gagal Memuat Data',
          message: state.message,
          onRetry: () {
            _fetchEmployeeWarnings();
          },);
          } else if (state is EmployeeWarningLoaded) {
            if(state.employeeWarnings.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Utils.buildEmptyStatePlain("Belum Ada Surat Peringatan", "")),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.employeeWarnings.length,
              itemBuilder: (context, index) {
                final warning = state.employeeWarnings[index];
                return _buildWarningCard(warning);
              },
            );
          }
          return  Utils.buildEmptyState(
              "Belum ada Data",null
            );
        },
      ),
    );
  }

  Widget _buildWarningCard(EmployeeWarning warning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
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
          Text(
            warning.warningTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nomor: ${warning.warningNumber}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _buildActionContainer(warning),
        ],
      ),
    );
  }

  Widget _buildActionContainer(EmployeeWarning warning) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border(
        left: BorderSide(
          color: AppColors.primaryMain, // Warna garis oranye
          width: 4, // Lebar garis
        ),
      ), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16,top: 16,),
            child: const Text(
              'Tindakan Anda',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Pastikan bahwa warning.action tidak null
          Padding(
            padding: const EdgeInsets.only(bottom: 16,right: 16,left: 16),
            child: HtmlWidget(
              '''
            <style>
              ol, ul {
                padding-left: 0; /* Atur padding kiri */
                margin-left: 0; /* Atur margin kiri */
              }
              li {
                padding: 0; /* Hapus padding */
                margin: 0; /* Hapus margin */
              }
            </style>
            ${warning.action.isNotEmpty ? warning.action : "<p>No actions provided.</p>"}
              ''',
            ),
          ),
        ],
      ),
    );
  }
}
