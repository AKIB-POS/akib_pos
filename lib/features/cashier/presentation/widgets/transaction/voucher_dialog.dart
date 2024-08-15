import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
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
  bool _isButtonDisabled = false;
  String? _discountType;

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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocListener<VoucherCubit, VoucherState>(
                listener: (context, state) {
                  if (state is VoucherLoading) {
                    // Do nothing specific for loading state in listener
                  } else if (state is VoucherLoaded) {
                    // Update the TransactionCubit with the redeemed voucher
                    BlocProvider.of<TransactionCubit>(context).updateVoucher(state.voucher.data);

                    // Show snackbar
                    DInfo.snackBarSuccess(context, "Berhasil Menerapkan Diskon");
                    setState(() {
                      _isButtonDisabled = true;
                    });

                    Navigator.of(context).pop(); // Close the dialog
                  } else if (state is VoucherError) {
                    DInfo.snackBarError(context, "Gagal Menerapkan Diskon");
                  } else {
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
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kode Diskon',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: AppColors.primaryMain,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
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
                        decoration: InputDecoration(
                          hintText: 'Masukkan Total Diskon',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: AppColors.primaryMain,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll<Color>(AppColors.primaryMain),
                      padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16),
                      ),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
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

                              DInfo.snackBarSuccess(context, "Berhasil Menerapkan Diskon");
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
