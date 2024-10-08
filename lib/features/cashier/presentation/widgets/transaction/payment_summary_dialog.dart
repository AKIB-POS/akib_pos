import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/common/util.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/features/cashier/presentation/finished_transaction_print.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PaymentSummaryDialog extends StatelessWidget {
  final String paymentMethod;
  final double totalAmount;
  final double receivedAmount;
  final FullTransactionModel transaction;

  PaymentSummaryDialog({
    required this.paymentMethod,
    required this.totalAmount,
    required this.receivedAmount,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    double change = receivedAmount - totalAmount;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.backgroundGrey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    SvgPicture.asset(
                      "assets/icons/ic_check.svg",
                      height: 8.h,
                      width: 8.h,
                    ),
                    const SizedBox(height: 16),
                    const Text('Pembayaran Berhasil',
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('d MMMM yyyy, HH:mm').format(DateTime.now())}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4.h),
                    if(isLandscape(context)) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSummaryItem('Jenis Pembayaran', paymentMethod),
                          const SizedBox(
                            width: 12,
                          ),
                          _buildSummaryItem('Total Tagihan', Utils.formatCurrencyDouble(totalAmount)),
                          const SizedBox(
                            width: 12,
                          ),
                          _buildSummaryItem('Diterima', Utils.formatCurrencyDouble(receivedAmount)),
                          const SizedBox(
                            width: 12,
                          ),
                          _buildSummaryItem('Kembalian', Utils.formatCurrencyDouble(change)),
                        ],
                      ),
                    ),
                    if(!isLandscape(context)) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSummaryItem('Jenis Pembayaran', paymentMethod),
                          const SizedBox(
                            width: 12,
                          ),
              
                          _buildSummaryItem('Total Tagihan', Utils.formatCurrencyDouble(totalAmount)),
                        ],
                      ),
                    ),
                    if(!isLandscape(context)) SizedBox(height: 12),
                    if(!isLandscape(context)) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSummaryItem('Diterima', Utils.formatCurrencyDouble(receivedAmount)),
                          const SizedBox(
                            width: 12,
                          ),
                          _buildSummaryItem('Kembalian', Utils.formatCurrencyDouble(change)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12,),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      decoration: AppThemes.bottomBoxDecorationDialog,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                FinishedTransactionPrint testPrint = FinishedTransactionPrint();
                testPrint.printTransaction(
                    transaction,
                    Utils.formatCurrencyDouble(receivedAmount),
                    Utils.formatCurrencyDouble(receivedAmount - totalAmount));
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryMain), // Warna border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // Radius border
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16), // Padding vertikal
                shadowColor: Colors.black.withOpacity(0.25), // Warna bayangan
                elevation: 5, // Tingkat bayangan (elevasi)
                backgroundColor: Colors.white, // Warna latar belakang
              ),
              child: Text(
                'Cetak',
                style: AppTextStyle.headline5
                    .copyWith(color: AppColors.primaryMain), // Warna teks
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally, redirect to a new transaction or reset page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMain, // Warna latar belakang
                foregroundColor: Colors.white, // Warna teks
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // Radius border
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16), // Padding vertikal
                shadowColor: Colors.black.withOpacity(0.25), // Warna bayangan
                elevation: 5, // Tingkat bayangan (elevasi)
              ),
              child: Text(
                '+ Buat Transaksi Baru',
                style: AppTextStyle.headline5.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
