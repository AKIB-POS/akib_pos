import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/settings/data/models/personal_information.dart';
import 'package:akib_pos/features/settings/presentation/bloc/get_personal_information_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({Key? key}) : super(key: key);

  @override
  _PersonalInformationPageState createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    context.read<GetPersonalInformationCubit>().fetchPersonalInformation();
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
        title: const Text('Informasi Akun', style: AppTextStyle.headline5),
      ),
      body: BlocBuilder<GetPersonalInformationCubit, GetPersonalInformationState>(
        builder: (context, state) {
          if (state is GetPersonalInformationLoading) {
            return _buildLoading();
          } else if (state is GetPersonalInformationError) {
            return Utils.buildErrorState(title: "Ada Kesalahan", message: state.message, onRetry: _fetchData);
          } else if (state is GetPersonalInformationLoaded) {
            return _buildBodyContent(state.personalInfo);
          } else {
            return const Center(child: Text('No Data Available'));
          }
        },
      ),
    );
  }

  // Loading state with shimmer effect
  Widget _buildLoading() {
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildShimmerBox(), // Personal Info
            const SizedBox(height: 16),
            _buildShimmerBox(), // Employee Info (If available)
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

 

  // Success state - Display the personal and employee information
  Widget _buildBodyContent(PersonalInformationResponse personalInfo) {
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildPersonalInfoSection(personalInfo.personalInformation),
              const SizedBox(height: 16),
              if (personalInfo.employeeInformation != null)
                _buildEmployeeInfoSection(personalInfo.employeeInformation!),
            ],
          ),
        ),
      ),
    );
  }

  // Personal Information Section
  Widget _buildPersonalInfoSection(PersonalInformation personalInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Personal',
          style: AppTextStyle.headline5,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow('Nama', personalInfo.name),
              const SizedBox(height: 12),
              _buildRow('No. Telepon', personalInfo.phoneNumber ?? 'Tidak Ada'),
              const SizedBox(height: 12),
              _buildRow('Email', personalInfo.email),
            ],
          ),
        ),
      ],
    );
  }

  // Employee Information Section (If available)
  Widget _buildEmployeeInfoSection(EmployeeInformation employeeInfo) {
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
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow('Jabatan', employeeInfo.position),
              const SizedBox(height: 12),
              _buildRow('Outlet', employeeInfo.outlet),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRow(employeeInfo.startContract != null ?'Kontrak Mulai' : "Tanggal Penetapan", employeeInfo.startContract ?? employeeInfo.determinationDate ?? ""),
                  _buildRow(employeeInfo.startContract != null ? 'Kontrak Akhir' : "No Sk", employeeInfo.endContract ?? employeeInfo.skNumber ?? ""),
                ],
              ),
              const SizedBox(height: 12),
              _buildRow('Alamat', employeeInfo.address),
            ],
          ),
        ),
      ],
    );
  }

  // Row builder for displaying key-value pairs
  Widget _buildRow(String label, String value) {
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
