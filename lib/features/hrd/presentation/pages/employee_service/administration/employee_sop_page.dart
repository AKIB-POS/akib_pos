import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/administration/employee_sop_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class EmployeeSOPPage extends StatefulWidget {
  const EmployeeSOPPage({Key? key}) : super(key: key);

  @override
  _EmployeeSOPPageState createState() => _EmployeeSOPPageState();
}

class _EmployeeSOPPageState extends State<EmployeeSOPPage> {
  @override
  void initState() {
    super.initState();
    _fetchEmployeeSOP();
  }

  void _fetchEmployeeSOP() {
    context.read<EmployeeSOPCubit>().fetchEmployeeSOP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('SOP Pegawai',style: AppTextStyle.headline5,),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<EmployeeSOPCubit, EmployeeSOPState>(
        builder: (context, state) {
          if (state is EmployeeSOPLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeSOPError) {
            return _buildErrorState(state.message);
          } else if (state is EmployeeSOPLoaded) {
            return _buildSOPContent(state.sopResponse.sopContent);
          }
          return const Center(child: Text('Tidak ada data.'));
        },
      ),
    );
  }

  // Method untuk menampilkan konten SOP
  Widget _buildSOPContent(String sopContent) {
    return RefreshIndicator(
      color: AppColors.primaryMain,
      backgroundColor: Colors.white,
      onRefresh: () async {
        _fetchEmployeeSOP();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HtmlWidget(
            sopContent,
            textStyle: const TextStyle(fontSize: 16),
            customStylesBuilder: (element) {
              if (element.localName == 'li') {
                return {'margin-bottom': '8px'};
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Method untuk menampilkan error state dengan tombol refresh
  Widget _buildErrorState(String errorMessage) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchEmployeeSOP();
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchEmployeeSOP,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}