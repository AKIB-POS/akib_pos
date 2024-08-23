import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/data/models/open_cashier_model.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/open_cashier/open_cashier_cubit.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class OpenCashierDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenCashierCubit, OpenCashierState>(
      builder: (context, state) {
        bool isLoading = state is OpenCashierLoading;

        if (state is OpenCashierSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<OpenCashierCubit>().resetState(); // Reset the state
            Navigator.of(context).pop(); // Close the dialog
          });
        }

        return PopScope(
          canPop: false, // Disable closing the dialog by back button
          child: Dialog(
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
                      "assets/icons/ic_open_cashier.svg", // Replace with your image path
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
                      onChanged: (value) {
                        context.read<OpenCashierCubit>().emit(
                          value.isNotEmpty
                              ? OpenCashierInitial()
                              : OpenCashierLoading(), // Adjust the state as needed
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (state is OpenCashierInitial && !isLoading)
                            ? () {
                                final request = OpenCashierRequest(
                                  idUser: '12345',
                                  datetime: DateTime.now().toIso8601String(),
                                  jumlah: double.parse(
                                    _controller.text.replaceAll(RegExp(r'[^0-9]'), ''),
                                  ),
                                  branchId: '6789',
                                );
                                context.read<OpenCashierCubit>().openCashier(request);
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: (state is OpenCashierInitial && !isLoading)
                              ? const WidgetStatePropertyAll<Color>(AppColors.primaryMain)
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
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
                      Text(state.message, style: const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
