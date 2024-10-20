import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/presentation/pages/auth_page.dart';
import 'package:akib_pos/features/cashier/data/models/close_cashier_response.dart';
import 'package:akib_pos/features/cashier/data/models/open_cashier_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/close_cashier/close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/post_close_cashier/post_close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/open_cashier_dialog.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CloseCashierDialog extends StatelessWidget {
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  Widget build(BuildContext context) {
    final closeCashierCubit = context.read<CloseCashierCubit>();
    closeCashierCubit
        .closeCashier(); // Trigger fetching data when the dialog opens

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: BlocBuilder<CloseCashierCubit, CloseCashierState>(
        builder: (context, state) {
          if (state is CloseCashierLoading) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.95,
              padding: const EdgeInsets.all(16),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is CloseCashierError) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text(state.message)),
            );
          } else if (state is CloseCashierLoaded) {
            return _buildDialog(context, state.response);
          }

          // Default return loading state
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildDialog(BuildContext context, CloseCashierResponse response) {
    return BlocBuilder<PostCloseCashierCubit, PostCloseCashierState>(
      builder: (context, postState) {
        if (postState is PostCloseCashierLoading) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.95,
            padding: const EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (postState is PostCloseCashierSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Set shared preference bahwa kasir sudah ditutup dan clear login response
            final authSharedPref = GetIt.instance<AuthSharedPref>();
            await authSharedPref.closeCashier();

            // Tutup dialog terlebih dahulu
            Navigator.of(context).pop();

            // Setelah dialog ditutup, arahkan ke halaman login
           
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
                (Route<dynamic> route) => false,
              );

              // Reset state setelah navigasi
              context.read<PostCloseCashierCubit>().resetState();
            
          });
        } else if (postState is PostCloseCashierError) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Center(child: Text(postState.message)),
          );
        }

        return _buildDialogContent(context, response);
      },
    );
  }

  Widget _buildDialogContent(
      BuildContext context, CloseCashierResponse response) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 200.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
            decoration: AppThemes.topBoxDecorationDialog,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Tutup Kasir",
                  style: AppTextStyle.headline6,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: AppColors.backgroundGrey,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryColumn("Nama Kasir", response.data.cashierName),
                _buildSummaryColumn(
                    "Mulai Buka Kasir", response.data.cashierOpenTime),
                _buildSummaryColumn(
                    "Waktu Tutup Kasir", response.data.cashierCloseTime),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryColumnBorder("Kas Awal",
                    Utils.formatCurrencyDouble(response.data.initialCash)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryColumnBorder(
                    "Pengeluaran Outlet",
                    Utils.formatCurrencyDouble(
                        response.data.outletExpenditure)),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryColumnBorder("Pembayaran Tunai",
                    Utils.formatCurrencyDouble(response.data.cashPayment)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryColumnBorder("Pembayaran Non Tunai",
                    Utils.formatCurrencyDouble(response.data.nonCashPayment)),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    ExtendedAssetImageProvider("assets/images/bg_payment.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Total Uang Tunai',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  Utils.formatCurrencyDouble(response.data.totalCash),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Spacer(),
          Container(
            decoration: AppThemes.bottomBoxDecorationDialog,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final request = OpenCashierRequest(
                        idUser: _authSharedPref.getUserId().toString(),
                        datetime:
                            DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        jumlah: response.data.totalCash,
                        branchId: _authSharedPref.getBranchId().toString(),
                        status: "close",
                      );

                      final closeCashierCubit =
                          context.read<PostCloseCashierCubit>();
                      closeCashierCubit.postCloseCashier(request);
                    },
                    child: BlocBuilder<PostCloseCashierCubit,
                        PostCloseCashierState>(
                      builder: (context, state) {
                        if (state is PostCloseCashierLoading) {
                          return const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          );
                        } else {
                          return const Text("Tutup Kasir");
                        }
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMain,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSummaryColumnBorder(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.backgroundGrey, width: 1),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
