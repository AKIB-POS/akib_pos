import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_training.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_training_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/widgets/employee_service/employee_training_card_widget.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class EmployeeTrainingPage extends StatefulWidget {
  const EmployeeTrainingPage({Key? key}) : super(key: key);

  @override
  _EmployeeTrainingPageState createState() => _EmployeeTrainingPageState();
}

class _EmployeeTrainingPageState extends State<EmployeeTrainingPage> {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  void initState() {
    super.initState();
    _fetchEmployeeTrainings();
  }

  void _fetchEmployeeTrainings() {
    final branchId = _authSharedPref.getBranchId() ?? 0;
    context.read<EmployeeTrainingCubit>().fetchEmployeeTrainings(branchId: branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Pelatihan Karyawan', style: AppTextStyle.headline5),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocBuilder<EmployeeTrainingCubit, EmployeeTrainingState>(
        builder: (context, state) {
          if (state is EmployeeTrainingLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3, // Number of shimmer loading cards
              itemBuilder: (context, index) => Utils.buildLoadingCardShimmer(),
            );
          } else if (state is EmployeeTrainingError) {
            return _buildErrorState(state.message);
          } else if (state is EmployeeTrainingLoaded && state.trainingData.trainings.isNotEmpty) {
            return EmployeeTrainingCardWidget(trainings: state.trainingData.trainings);
          } else {
            return const Center(child: Text('Tidak ada data pelatihan.'));
          }
        },
      ),
    );
  }

  // Method untuk menampilkan error state dengan tombol refresh
  Widget _buildErrorState(String errorMessage) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchEmployeeTrainings();
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
                onPressed: _fetchEmployeeTrainings,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
