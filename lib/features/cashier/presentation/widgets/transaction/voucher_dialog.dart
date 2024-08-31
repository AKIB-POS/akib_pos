import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/data/models/redeem_voucher_response.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoucherDialog extends StatefulWidget {
  @override
  _VoucherDialogState createState() => _VoucherDialogState();
}

class _VoucherDialogState extends State<VoucherDialog> {
  final TextEditingController _voucherController = TextEditingController();
  final TextEditingController _manualDiscountController = TextEditingController();
  bool _isButtonDisabled = true; // Initially, the button is disabled
  String? _discountType;

  @override
  void initState() {
    super.initState();
    _voucherController.addListener(_validateInput);
    _manualDiscountController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _voucherController.removeListener(_validateInput);
    _manualDiscountController.removeListener(_validateInput);
    _voucherController.dispose();
    _manualDiscountController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      if (_voucherController.text.trim().isNotEmpty) {
        _isButtonDisabled = false;
      } else if (_manualDiscountController.text.trim().isNotEmpty && _discountType != null) {
        _isButtonDisabled = false;
      } else {
        _isButtonDisabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              decoration: AppThemes.topBoxDecorationDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Detail Diskon', style: AppTextStyle.headline5),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocListener<VoucherCubit, VoucherState>(
                listener: (context, state) {
                  if (state is VoucherLoaded) {
                    BlocProvider.of<TransactionCubit>(context).updateVoucher(state.voucher.data);

                    // Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Berhasil Menerapkan Diskon',
                        ),
                        backgroundColor: AppColors.successMain,
                        duration: Duration(milliseconds:1000),
                      ),
                    );
                    setState(() {
                      _isButtonDisabled = true;
                    });

                    Navigator.of(context).pop(); // Close the dialog
                  } else if (state is VoucherError) {
                    DInfo.snackBarError(context, "Gagal Menerapkan Diskon");
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Redeem Voucher', style: AppTextStyle.headline6.copyWith(color: AppColors.primaryMain)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _voucherController,
                        decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Masukkan Kode Voucher'),
                      ),
                      const SizedBox(height: 24),
                      Text('Diskon Lainnya', style: AppTextStyle.headline6.copyWith(color: AppColors.primaryMain)),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio<String>(
                                  value: 'percentage',
                                  toggleable: true,
                                  groupValue: _discountType,
                                  onChanged: (value) {
                                    setState(() {
                                      _discountType = value;
                                    });
                                    _validateInput();
                                  },
                                  activeColor: AppColors.primaryMain,
                                ),
                                const Text('Persentase%'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'nominal',
                                  toggleable: true,
                                  groupValue: _discountType,
                                  onChanged: (value) {
                                    setState(() {
                                      _discountType = value;
                                    });
                                    _validateInput();
                                  },
                                  activeColor: AppColors.primaryMain,
                                ),
                                const Text('Rupiah'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _manualDiscountController,
                        decoration: AppThemes.inputDecorationStyle.copyWith(hintText: 'Masukkan Nominal'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<VoucherCubit, VoucherState>(
              builder: (context, state) {
                bool isLoading = state is VoucherLoading;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: AppThemes.bottomBoxDecorationDialog,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: _isButtonDisabled || isLoading
                          ? WidgetStatePropertyAll<Color>(Colors.grey)
                          : const WidgetStatePropertyAll<Color>(AppColors.primaryMain),
                      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: _isButtonDisabled || isLoading
                        ? null
                        : () {
                            if (_discountType != null && _manualDiscountController.text.isNotEmpty) {
                              double discountAmount = double.parse(_manualDiscountController.text);
                              VoucherData voucher = VoucherData(
                                type: _discountType!,
                                amount: discountAmount,
                              );
                              BlocProvider.of<TransactionCubit>(context).updateVoucher(voucher);

                               ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Berhasil Menerapkan Diskon',
                        ),
                        backgroundColor: AppColors.successMain,
                        duration: Duration(milliseconds: 1000),
                      ),
                    );
                              Navigator.of(context).pop(); // Close the dialog
                            } else {
                              BlocProvider.of<VoucherCubit>(context).redeemVoucher(_voucherController.text);
                            }
                          },
                    child: isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Gunakan',
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
    );
  }
}
