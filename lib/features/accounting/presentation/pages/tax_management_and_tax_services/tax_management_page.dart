import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/tax_management_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/pages/tax_management_and_tax_services/tax_management_setting_page.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class TaxManagementPage extends StatefulWidget {
  const TaxManagementPage({Key? key}) : super(key: key);

  @override
  _TaxManagementPageState createState() => _TaxManagementPageState();
}

class _TaxManagementPageState extends State<TaxManagementPage> {
  late final AuthSharedPref _authSharedPref;
  late final int branchId;
  late final int companyId;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;
    context.read<TaxManagementCubit>().fetchTaxCharge(branchId, companyId);
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
          'Manajemen Pajak',
          style: AppTextStyle.headline5,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchData();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Utils.showCustomInfoDialog(
                    context,
                    'Informasi Pajak',
                    'Jika Anda menetapkan nilai pajak, pajak akan dicantumkan secara terpisah pada struk pembelian. Jika tidak diatur atau nilainya 0, maka harga produk yang tercantum di struk sudah termasuk pajak.',
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Info Pajak",
                      style: TextStyle(color: AppColors.primaryMain),
                    ),
                    SvgPicture.asset("assets/icons/accounting/ic_info.svg")
                  ],
                ),
              ),
              BlocBuilder<TaxManagementCubit, TaxManagementState>(
                builder: (context, state) {
                  if (state is TaxManagementLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaxManagementLoaded) {
                    final taxChargePercentage =
                        state.taxCharge.taxChargePercentage;
                    if (taxChargePercentage == null ||
                        taxChargePercentage == 0) {
                      return _buildEmptyTaxCharge(
                          context); // Jika nilai taxCharge null
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child:
                            _buildTaxChargeInfo(context, taxChargePercentage),
                      ); // Jika ada nilai
                    }
                  } else if (state is TaxManagementError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }
                  return const SizedBox.shrink(); // Default state
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTaxCharge(BuildContext context) {
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
          SvgPicture.asset('assets/images/empty_product.svg', height: 100),
          const SizedBox(height: 16),
          Text('Pajak Belum Diatur', style: AppTextStyle.subtitle3),
          const SizedBox(height: 8),
          Text(
            'Pajak akan aktif ketika\nanda mengaturnya',
            textAlign: TextAlign.center,
            style: AppTextStyle.caption,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaxManagementSettingPage(),
                ),
              );
            },
            child: const Text("Atur Pajak"),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxChargeInfo(BuildContext context, double taxChargePercentage) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
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
              Text('Pajak', style: AppTextStyle.subtitle3),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Presentase Pajak:', style: AppTextStyle.caption),
                  const SizedBox(width: 2),
                  Text(
                    '${taxChargePercentage.toStringAsFixed(0)}%',
                    style: AppTextStyle.caption
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaxManagementSettingPage(
                    initialPercentage: taxChargePercentage,
                  ),
                ),
              );
            },
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
