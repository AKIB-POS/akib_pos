import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/service_charge_subit.dart';
import 'package:akib_pos/features/accounting/presentation/pages/tax_management_and_tax_services/service_charge_setting_page.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

class ServiceChargePage extends StatefulWidget {


  const ServiceChargePage({super.key});

  @override
  _ServiceChargePageState createState() => _ServiceChargePageState();
}

class _ServiceChargePageState extends State<ServiceChargePage> {
   late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;
  @override
  void initState() {
    super.initState();
    // Panggil cubit untuk fetch data saat initState
     _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;
    context.read<ServiceChargeCubit>().fetchServiceCharge(branchId, companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Manajemen Pelayanan',
          style: AppTextStyle.headline5,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Info Pajak",style: TextStyle(color: AppColors.primaryMain),),
                SvgPicture.asset("assets/icons/accounting/ic_info.svg")
              ],
            ),
            BlocBuilder<ServiceChargeCubit, ServiceChargeState>(
              builder: (context, state) {
                if (state is ServiceChargeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServiceChargeLoaded) {
                  final serviceChargePercentage = state.serviceCharge.serviceChargePercentage;
                  if (serviceChargePercentage == null || serviceChargePercentage == 0) {
                    return _buildEmptyServiceCharge(context); // Jika nilai serviceChargePercentage null
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildServiceChargeInfo(context, serviceChargePercentage),
                    ); // Jika ada nilai serviceChargePercentage
                  }
                } else if (state is ServiceChargeError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return const SizedBox.shrink(); // Default state
              },
            ),
          ],
        ),
      ),
    );
  }

  // Jika service charge null
  Widget _buildEmptyServiceCharge(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/empty_product.svg',
            height: 100,
          ),
          const SizedBox(height: 16),
          const Text(
            'Biaya Pelayanan Belum Diatur',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Biaya Pelayanan akan aktif ketika anda mengaturnya',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Arahkan ke halaman pengaturan layanan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceChargeSettingPage(),
                ),
              );
            },
            child: const Text("Atur Biaya Layanan"),
          ),
        ],
      ),
    );
  }

  // Jika service charge sudah diatur
  Widget _buildServiceChargeInfo(BuildContext context, double serviceChargePercentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Arahkan ke halaman pengaturan untuk mengedit
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceChargeSettingPage(
                        initialPercentage: serviceChargePercentage,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label:  Text("Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: AppColors.primaryMain,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Biaya Pelayanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Presentase Pelayanan: ${serviceChargePercentage.toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
