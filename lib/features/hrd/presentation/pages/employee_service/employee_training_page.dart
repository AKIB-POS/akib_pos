import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_training.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_training_cubit.dart';
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeTrainingError) {
            return _buildErrorState(state.message);
          } else if (state is EmployeeTrainingLoaded) {
            return state.trainingData.trainings.isEmpty
                ? const Center(child: Text('Tidak ada data pelatihan.'))
                : _buildTrainingList(state.trainingData.trainings);
          }
          return const Center(child: Text('Tidak ada data.'));
        },
      ),
    );
  }

  Widget _buildTrainingList(List<EmployeeTraining> trainings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        final training = trainings[index];
        return _buildTrainingCard(training);
      },
    );
  }

  Widget _buildTrainingCard(EmployeeTraining training) {
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
          Text(
            training.trainingTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            training.trainingDescription,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            training.trainingDateTime,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
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