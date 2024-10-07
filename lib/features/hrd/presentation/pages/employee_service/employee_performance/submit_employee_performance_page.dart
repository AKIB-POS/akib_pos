import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/performance_metric_model.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/submit_employee_request.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/performance_metric_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/submit_employee_performance_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SubmitEmployeePerformancePage extends StatefulWidget {
  final int employeeId;
  final String employeeName;
  final String role;
  final int month;
  final int year;

  const SubmitEmployeePerformancePage({
    Key? key,
    required this.employeeId,
    required this.employeeName,
    required this.role,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  _SubmitEmployeePerformancePageState createState() =>
      _SubmitEmployeePerformancePageState();
}

class _SubmitEmployeePerformancePageState
    extends State<SubmitEmployeePerformancePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> _scoreControllers = {};
  final Map<int, TextEditingController> _remarksControllers = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch performance metrics dynamically
    context.read<PerformanceMetricCubit>().fetchPerformanceMetrics();
  }

  @override
  void dispose() {
    // Dispose all controllers when page is destroyed
    for (var controller in _scoreControllers.values) {
      controller.dispose();
    }
    for (var controller in _remarksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isFormValid() {
    // Check if all score and remarks fields are filled
    for (var controller in _scoreControllers.values) {
      if (controller.text.isEmpty) return false;
    }
    for (var controller in _remarksControllers.values) {
      if (controller.text.isEmpty) return false;
    }
    return true;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final Map<int, PerformanceScore> performanceMetrics = {};

      _scoreControllers.forEach((metricsId, controller) {
        performanceMetrics[metricsId] = PerformanceScore(
          score: int.parse(controller.text),
          remarks: _remarksControllers[metricsId]!.text,
        );
      });

      final request = SubmitEmployeePerformanceRequest(
        employeeId: widget.employeeId,
        month: widget.month,
        year: widget.year,
        performanceMetrics: performanceMetrics,
      );

      context.read<SubmitEmployeePerformanceCubit>().submitPerformance(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text('Beri Nilai', style: AppTextStyle.headline5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<SubmitEmployeePerformanceCubit, SubmitEmployeePerformanceState>(
        listener: (context, state) {
          if (state is SubmitEmployeePerformanceLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is SubmitEmployeePerformanceSuccess) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.successMain,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is SubmitEmployeePerformanceError) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorMain,
              ),
            );
          }
        },
        child: BlocBuilder<PerformanceMetricCubit, PerformanceMetricState>(
          builder: (context, state) {
            if (state is PerformanceMetricLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PerformanceMetricLoaded) {
              return _buildForm(state.metrics);
            } else if (state is PerformanceMetricError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Tidak ada data'));
          },
        ),
      ),
    );
  }

  Widget _buildForm(List<PerformanceMetricModel> metrics) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildEmployeeInfo(),
                  const SizedBox(height: 16),
                  for (var metric in metrics)
                    Column(
                      children: [
                        _buildPerformanceSection(
                          metric.metricsName,
                          _getController(metric.metricsId, true),
                          _getController(metric.metricsId, false),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama',
                  style: AppTextStyle.bigCaptionBold
                      .copyWith(color: AppColors.textGrey600)),
              const SizedBox(height: 8),
              Text(widget.employeeName, style: AppTextStyle.bigCaptionBold),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jabatan',
                  style: AppTextStyle.bigCaptionBold
                      .copyWith(color: AppColors.textGrey600)),
              const SizedBox(height: 8),
              Text(widget.role, style: AppTextStyle.bigCaptionBold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection(
    String title,
    TextEditingController scoreController,
    TextEditingController remarksController,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(title,
              style: AppTextStyle.headline5.copyWith(color: Colors.red)),
          const SizedBox(height: 8),
          TextFormField(
            controller: scoreController,
            keyboardType: TextInputType.number,
            decoration: AppThemes.inputDecorationStyle.copyWith(
              hintText: 'Masukkan Nilai',
            ),
            onChanged: (_) => setState(() {}), // Trigger validation
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nilai tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: remarksController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: AppThemes.inputDecorationStyle.copyWith(
              hintText: 'Masukkan keterangan',
            ),
            onChanged: (_) => setState(() {}), // Trigger validation
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Keterangan tidak boleh kosong';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppThemes.bottomBoxDecorationDialog,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isFormValid() && !isLoading ? AppColors.primaryMain : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: _isFormValid() && !isLoading ? _submit : null,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Kirim',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  TextEditingController _getController(int metricId, bool isScore) {
    if (isScore) {
      _scoreControllers.putIfAbsent(
          metricId, () => TextEditingController());
      return _scoreControllers[metricId]!;
    } else {
      _remarksControllers.putIfAbsent(
          metricId, () => TextEditingController());
      return _remarksControllers[metricId]!;
    }
  }
}
