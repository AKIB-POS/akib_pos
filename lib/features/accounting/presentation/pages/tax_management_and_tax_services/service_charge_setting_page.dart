import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/service_charge_setting_cubit.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ServiceChargeSettingPage extends StatefulWidget {
  final double? initialPercentage;

  const ServiceChargeSettingPage({Key? key, this.initialPercentage}) : super(key: key);

  @override
  _ServiceChargeSettingPageState createState() => _ServiceChargeSettingPageState();
}

class _ServiceChargeSettingPageState extends State<ServiceChargeSettingPage> {
  late TextEditingController _percentageController;
  late final int branchId;
  late final int companyId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _percentageController = TextEditingController(
      text: widget.initialPercentage?.toString() ?? '', // Inisialisasi nilai jika ada
    );
    final _authSharedPref = GetIt.instance<AuthSharedPref>();
    branchId = _authSharedPref.getBranchId() ?? 0;
    companyId = _authSharedPref.getCompanyId() ?? 0;
  }

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
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
          'Atur Biaya Pelayanan',
          style: AppTextStyle.headline5,
        ),
      ),
      body: BlocListener<ServiceChargeSettingCubit, ServiceChargeSettingState>(
        listener: (context, state) {
          if (state is ServiceChargeSettingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              
              SnackBar(content: Text(state.message),backgroundColor: AppColors.successMain,),
            );
            Navigator.of(context).pop();
          } else if (state is ServiceChargeSettingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message),backgroundColor: AppColors.errorMain,),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Persentase Pelayanan",
                  style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _percentageController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {}); // Panggil setState agar tombol diperbarui
                  },
                  decoration: AppThemes.inputDecorationStyle.copyWith(
                    hintText: 'Masukkan Persentase',
                    suffixText: "%",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Spacer(),
              BlocBuilder<ServiceChargeSettingCubit, ServiceChargeSettingState>(
                builder: (context, state) {
                  if (state is ServiceChargeSettingLoading) {
                    // Ganti teks tombol dengan CircularProgressIndicator saat loading
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: AppThemes.bottomBoxDecorationDialog,
                      child: ElevatedButton(
                        onPressed: null, // Disabled saat loading
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll<Color>(Colors.grey),
                          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 16),
                          ),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                    );
                  }
                  // Normal button saat tidak loading
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: AppThemes.bottomBoxDecorationDialog,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: _isFormValid() && !isLoading
                            ? const WidgetStatePropertyAll<Color>(
                                AppColors.primaryMain)
                            : const WidgetStatePropertyAll<Color>(Colors.grey),
                        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 16),
                        ),
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: _isFormValid() && !isLoading ? _submit : null,
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    return _percentageController.text.isNotEmpty; // Form valid jika ada teks
  }

  void _submit() {
  // Ganti koma dengan titik pada inputan pengguna
  final inputText = _percentageController.text.replaceAll(',', '.');
  
  // Lakukan parsing ke double
  final amount = double.tryParse(inputText);
  
  if (amount != null) {
    // Jika parsing berhasil, lanjutkan pemanggilan API
    context.read<ServiceChargeSettingCubit>().setServiceCharge(
          branchId: branchId,
          companyId: companyId,
          amount: amount,
        );
  } else {
    // Tampilkan pesan error jika input tidak valid
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Masukkan persentase yang valid")),
    );
  }
}

}

