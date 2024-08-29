import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/models/open_cashier_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/open_cashier/open_cashier_cubit.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class OpenCashierDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenCashierCubit, OpenCashierState>(
      builder: (context, state) {
        bool isLoading = state is OpenCashierLoading;


        if (state is OpenCashierSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Reset state, close the dialog, and reload the data
            context.read<OpenCashierCubit>().resetState(); 
            Navigator.of(context).pop(); // Close the dialog

            // Trigger reload data after closing the dialog
            context.read<CashierCubit>().loadData();
          });
        }

        if (state is OpenCashierError) {
            context.read<OpenCashierCubit>().resetState(); 
        }

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: 60.w,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16.0),
                  SvgPicture.asset(
                    "assets/icons/ic_open_cashier.svg",
                    height: 80.0,
                    width: 80.0,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Halo, Syafii Qurani",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Sudah siap menerima pesanan?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Kas Awal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      CurrencyTextInputFormatter.currency(
                        locale: 'id',
                        decimalDigits: 0,
                        symbol: 'Rp.  ',
                      ),
                    ],
                    decoration: AppThemes.inputDecorationStyle
                        .copyWith(hintText: "Masukkan Kas Awal"),
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final request = OpenCashierRequest(
                                idUser:
                                    _authSharedPref.getUserId().toString(),
                                datetime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(DateTime.now()),
                                jumlah: double.parse(_controller.text
                                    .replaceAll(RegExp(r'[^0-9]'), '')),
                                branchId:
                                    _authSharedPref.getBranchId().toString(),
                                status: "open",
                              );
                              context
                                  .read<OpenCashierCubit>()
                                  .openCashier(request);
                            },
                      style: ButtonStyle(
                        backgroundColor: isLoading
                            ? const WidgetStatePropertyAll<Color>(Colors.grey)
                            : const WidgetStatePropertyAll<Color>(
                                AppColors.primaryMain),
                        padding:
                            const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 16),
                        ),
                        shape:
                            WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  if (state is OpenCashierError) ...[
                    const SizedBox(height: 16.0),
                    Text(state.message,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
