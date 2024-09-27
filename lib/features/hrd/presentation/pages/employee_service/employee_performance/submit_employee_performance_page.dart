import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee_performance/submit_employee_request.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee_performance/submit_employee_performance_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitEmployeePerformancePage extends StatefulWidget {
  final int employeePerformanceId;
  final String employeeName;
  final String role;

  const SubmitEmployeePerformancePage({
    Key? key,
    required this.employeePerformanceId,
    required this.employeeName,
    required this.role,
  }) : super(key: key);

  @override
  _SubmitEmployeePerformancePageState createState() =>
      _SubmitEmployeePerformancePageState();
}

class _SubmitEmployeePerformancePageState
    extends State<SubmitEmployeePerformancePage> {
  final _formKey = GlobalKey<FormState>();
  final _attendanceScoreController = TextEditingController();
  final _attendanceRemarksController = TextEditingController();
  final _collaborationScoreController = TextEditingController();
  final _collaborationRemarksController = TextEditingController();
  final _innovationScoreController = TextEditingController();
  final _innovationRemarksController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to controllers
    _attendanceScoreController.addListener(_updateFormState);
    _attendanceRemarksController.addListener(_updateFormState);
    _collaborationScoreController.addListener(_updateFormState);
    _collaborationRemarksController.addListener(_updateFormState);
    _innovationScoreController.addListener(_updateFormState);
    _innovationRemarksController.addListener(_updateFormState);
  }

  @override
  void dispose() {
    _attendanceScoreController.dispose();
    _attendanceRemarksController.dispose();
    _collaborationScoreController.dispose();
    _collaborationRemarksController.dispose();
    _innovationScoreController.dispose();
    _innovationRemarksController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    setState(() {});
  }

  bool _isFormValid() {
    return _attendanceScoreController.text.isNotEmpty &&
        _attendanceRemarksController.text.isNotEmpty &&
        _collaborationScoreController.text.isNotEmpty &&
        _collaborationRemarksController.text.isNotEmpty &&
        _innovationScoreController.text.isNotEmpty &&
        _innovationRemarksController.text.isNotEmpty;
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
      body: BlocListener<SubmitEmployeePerformanceCubit,
          SubmitEmployeePerformanceState>(
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
        child: Form(
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
                      _buildPerformanceSection(
                        'Tingkat Kehadiran',
                        _attendanceScoreController,
                        _attendanceRemarksController,
                      ),
                      const SizedBox(height: 16),
                      _buildPerformanceSection(
                        'Kerjasama',
                        _collaborationScoreController,
                        _collaborationRemarksController,
                      ),
                      const SizedBox(height: 16),
                      _buildPerformanceSection(
                        'Inovasi Kerja',
                        _innovationScoreController,
                        _innovationRemarksController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
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
          backgroundColor: _isFormValid() && !isLoading
              ? AppColors.primaryMain
              : Colors.grey,
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = SubmitEmployeePerformanceRequest(
        employeePerformanceId: widget.employeePerformanceId,
        attendance: PerformanceScore(
          score: int.parse(_attendanceScoreController.text),
          remarks: _attendanceRemarksController.text,
        ),
        collaboration: PerformanceScore(
          score: int.parse(_collaborationScoreController.text),
          remarks: _collaborationRemarksController.text,
        ),
        workInnovation: PerformanceScore(
          score: int.parse(_innovationScoreController.text),
          remarks: _innovationRemarksController.text,
        ),
      );

      context.read<SubmitEmployeePerformanceCubit>().submitPerformance(request);
    }
  }
}
