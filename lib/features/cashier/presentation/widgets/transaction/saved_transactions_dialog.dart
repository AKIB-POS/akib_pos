import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_models.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class SavedTransactionsDialog extends StatefulWidget {
  @override
  _SavedTransactionsDialogState createState() =>
      _SavedTransactionsDialogState();
}

class _SavedTransactionsDialogState extends State<SavedTransactionsDialog> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<FullTransactionModel> _filteredTransactions = [];
  bool _isListEmpty = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadTransactions();
  }

  void _onSearchChanged() {
    if (!_isListEmpty) {
      _filterTransactions(_searchController.text);
    }
  }

  void _loadTransactions() async {
    List<FullTransactionModel> transactions =
        await context.read<TransactionCubit>().getFullTransactions();
    setState(() {
      _filteredTransactions = transactions;
      _isListEmpty = transactions.isEmpty;
    });
  }

  void _filterTransactions(String query) async {
    List<FullTransactionModel> transactions =
        await context.read<TransactionCubit>().getFullTransactions();
    if (query.isEmpty) {
      setState(() {
        _filteredTransactions = transactions;
      });
    } else {
      setState(() {
        _filteredTransactions = transactions
            .where(
                (t) => t.savedNotes.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _unfocusSearchField() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusSearchField,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Container(
            decoration: AppThemes.allBoxDecorationDialog,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  decoration: AppThemes.topBoxDecorationDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pesanan Tersimpan', style: AppTextStyle.headline6),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                if (!_isListEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: AppThemes.inputDecorationStyle.copyWith(
                        hintText: "Masukkan Keterangan Pesanan",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            _onSearchChanged();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                ],
                Expanded(
                  child: _isListEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/images/empty_saved.svg",
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada pesanan tersimpan',
                              style: AppTextStyle.headline5,
                            ),
                            Text(
                              'Silahkan tambahkan pesanan di keranjang',
                              style: AppTextStyle.body2,
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _filteredTransactions[index];
                            return ListTile(
                              leading: SvgPicture.asset(
                                "assets/icons/ic_item_saved.svg",
                                height: 24,
                                width: 24,
                              ),
                              title: Text(
                                  '${transaction.savedNotes} - ${transaction.transactions.length} Item ',
                                  style: AppTextStyle.headline6),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${DateFormat('HH:mm').format(transaction.time)}',
                                  style: AppTextStyle.body3,
                                ),
                              ),
                              trailing: Text(
                                'Rp ${transaction.transactions.fold(0, (total, t) => total + t.product.totalPrice!)}',
                                style: AppTextStyle.headline6
                                    .copyWith(color: AppColors.black),
                              ),
                              onTap: () {
                                _showTransactionDetailDialog(
                                    context, transaction);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showTransactionDetailDialog(
    BuildContext context, FullTransactionModel fullTransaction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                decoration: AppThemes.topBoxDecorationDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Detail Pesanan",
                      style: AppTextStyle.headline6,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2,bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Keterangan"),
                              Text("Total Pembayaran"),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fullTransaction.savedNotes,
                                style: AppTextStyle.headline6,
                              ),
                              Text(
                                "Rp ${fullTransaction.transactions.fold(0, (total, t) => total + t.product.totalPrice!)}",
                                style: AppTextStyle.headline6,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.fillColorInput,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [                               
                                Text("Rincian Pesanan",style: AppTextStyle.headline6),
                                SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      fullTransaction.transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction =
                                        fullTransaction.transactions[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${transaction.quantity} x ${transaction.product.name}",
                                          ),
                                          Text(
                                            Utils.formatCurrency((transaction.product.price * transaction.quantity).toString()),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: AppThemes.bottomBoxDecorationDialog,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          // Implement print receipt functionality here
                        },
                        child: Text(
                          'Cetak Struk',
                          style: AppTextStyle.headline5
                              .copyWith(color: AppColors.primaryMain),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context, rootNavigator: true).pop();

                          await context
                              .read<TransactionCubit>()
                              .removeFullTransaction(fullTransaction);
                          context.read<BadgeCubit>().updateBadgeCount();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryMain,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: Text(
                          'Lanjutkan Transaksi',
                          style: AppTextStyle.headline5
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
