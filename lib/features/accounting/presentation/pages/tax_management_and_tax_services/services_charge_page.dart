import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/service_charge_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/pages/tax_management_and_tax_services/service_charge_setting_page.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
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
          'Manajemen Biaya Layanan',
          style: AppTextStyle.headline5,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Utils.showCustomInfoDialog(
                  context,
                  'Informasi Biaya Layanan',
                  'Jika Anda menetapkan biaya layanan, biaya tersebut akan muncul secara terpisah pada struk. Jika tidak diatur atau nilainya 0, maka biaya layanan sudah termasuk dalam harga produk.',
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Info Biaya Layanan",
                    style: TextStyle(color: AppColors.primaryMain),
                  ),
                  SvgPicture.asset("assets/icons/accounting/ic_info.svg")
                ],
              ),
            ),
            BlocBuilder<ServiceChargeCubit, ServiceChargeState>(
              builder: (context, state) {
                if (state is ServiceChargeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServiceChargeLoaded) {
                  final serviceChargePercentage =
                      state.serviceCharge.serviceChargePercentage;
                  if (serviceChargePercentage == null ||
                      serviceChargePercentage == 0) {
                    return _buildEmptyServiceCharge(
                        context); // Jika nilai serviceChargePercentage null
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _buildServiceChargeInfo(
                          context, serviceChargePercentage),
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
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.only(top: 16),
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
          Text(
            'Biaya Pelayanan Belum Diatur',
            style: AppTextStyle.subtitle3,
          ),
          const SizedBox(height: 8),
          Text(
            'Biaya Pelayanan akan aktif ketika\nanda mengaturnya',
            textAlign: TextAlign.center,
            style: AppTextStyle.caption,
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
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Warna latar belakang
              backgroundColor: AppColors.primaryMain, // Warna teks dan ikon
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // Mengatur radius sudut
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8, // Padding vertikal
                horizontal:
                    14, // Padding horizontal, atur lebih kecil sesuai kebutuhan
              ),
            ),
            child: const Text("Atur Biaya Layanan"),
          ),
        ],
      ),
    );
  }

  // Jika service charge sudah diatur
  Widget _buildServiceChargeInfo(
      BuildContext context, double serviceChargePercentage) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successMain.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(color: AppColors.successMain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Biaya Pelayanan',
                style: AppTextStyle.subtitle3,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Presentase Pelayanan:',
                    style: AppTextStyle.caption,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    '${serviceChargePercentage.toStringAsFixed(0)}%',
                    style: AppTextStyle.caption
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Warna latar belakang
              foregroundColor: AppColors.primaryMain, // Warna teks dan ikon
              side: const BorderSide(
                // Menambahkan stroke/border
                color: AppColors.primaryMain,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // Mengatur radius sudut
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8, // Padding vertikal
                horizontal:
                    14, // Padding horizontal, atur lebih kecil sesuai kebutuhan
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min, // Membuat tombol sesuai konten
              children: [
                Text("Edit"),
                SizedBox(width: 2), // Memberi jarak antara teks dan ikon
                Icon(Icons.edit),
              ],
            ),
          )
        ],
      ),
    );
  }
}
