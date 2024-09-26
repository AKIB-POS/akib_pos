import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/contract_employee_detail.dart';
import 'package:akib_pos/features/hrd/data/models/employee_service/employee/permanent_employee_detail.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/contract_employee_cubit.dart';
import 'package:akib_pos/features/hrd/presentation/bloc/employee_service/employee/permanent_employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeDetailPage extends StatefulWidget {
  final int employeeId;
  final String employeeType;

  const EmployeeDetailPage({
    Key? key,
    required this.employeeId,
    required this.employeeType,
  }) : super(key: key);

  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  ContractEmployeeDetail? contractEmployeeDetail;
  PermanentEmployeeDetail? permanentEmployeeDetail;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (widget.employeeType == 'Pegawai Kontrak') {
        await context.read<ContractEmployeeCubit>().fetchContractEmployeeDetail(widget.employeeId);
        final state = context.read<ContractEmployeeCubit>().state;
        if (state is ContractEmployeeLoaded) {
          setState(() {
            contractEmployeeDetail = state.contractEmployeeDetail;
          });
        }
      } else if (widget.employeeType == 'Pegawai Tetap') {
        await context.read<PermanentEmployeeCubit>().fetchPermanentEmployeeDetail(widget.employeeId);
        final state = context.read<PermanentEmployeeCubit>().state;
        if (state is PermanentEmployeeLoaded) {
          setState(() {
            permanentEmployeeDetail = state.permanentEmployeeDetail;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        titleSpacing: 0,
        title: const Text('Detail Pegawai', style: AppTextStyle.headline5),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.employeeType == 'Pegawai Kontrak'
                    ? contractEmployeeDetail != null
                        ? _buildContractDetail(contractEmployeeDetail!)
                        : const Center(child: Text('Invalid employee type'))
                    : permanentEmployeeDetail != null
                        ? _buildPermanentDetail(permanentEmployeeDetail!)
                        : const Center(child: Text('Invalid employee type')),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Contract Employee details
  Widget _buildContractDetail(ContractEmployeeDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildEmployeeInfo(detail.employeeInfo.position, detail.employeeInfo.branch,
            detail.employeeInfo.contractStart, detail.employeeInfo.contractEnd),
        const SizedBox(height: 16),
        _buildPersonalInfo(detail.personalInfo),
      ],
    );
  }

  // Permanent Employee details
  Widget _buildPermanentDetail(PermanentEmployeeDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildPermanentEmployeeInfo(detail.employeeInfo.position, detail.employeeInfo.branch,
            detail.employeeInfo.confirmationDate, detail.employeeInfo.confirmationLetterNumber),
        const SizedBox(height: 16),
        _buildPersonalInfo(detail.personalInfo),
      ],
    );
  }

  // Employee info for contract employee
  Widget _buildEmployeeInfo(String jabatan, String cabang, String kontrakMulai, String kontrakAkhir) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pegawai',
          style: AppTextStyle.headline5,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn('Jabatan', jabatan),
              const SizedBox(height: 12),
              _buildColumn('Outlet', cabang),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn('Kontrak Mulai', kontrakMulai),
                  _buildColumn('Kontrak Akhir', kontrakAkhir),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Employee info for permanent employee
  Widget _buildPermanentEmployeeInfo(String jabatan, String cabang, String tanggalPenetapan, String noSkPenetapan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Pegawai',
          style: AppTextStyle.headline5,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn('Jabatan', jabatan),
              const SizedBox(height: 12),
              _buildColumn('Outlet', cabang),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn('Tanggal Penetapan', tanggalPenetapan),
                  _buildColumn('No. SK Penetapan', noSkPenetapan),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Personal info
  Widget _buildPersonalInfo(PersonalInfo info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Personal',
          style: AppTextStyle.headline5,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn('Nama', info.name),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildColumn('Jenis Kelamin', info.gender),
                  ),
                  Expanded(
                    flex: 5,
                    child: _buildColumn('Tanggal Lahir', info.birthDate),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildColumn('No. Telepon', info.phoneNumber),
                  ),
                  Expanded(
                    flex: 5,
                    child: _buildColumn('Email', info.email),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildColumn('Alamat', info.address),
            ],
          ),
        ),
      ],
    );
  }

  // Membuat baris informasi
  Widget _buildColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.caption,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}