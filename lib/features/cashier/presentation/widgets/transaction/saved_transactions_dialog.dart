import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_models.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SavedTransactionsDialog extends StatefulWidget {
  @override
  _SavedTransactionsDialogState createState() =>
      _SavedTransactionsDialogState();
}

class _SavedTransactionsDialogState extends State<SavedTransactionsDialog> {
  TextEditingController _searchController = TextEditingController();
  List<FullTransactionModel> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadTransactions();
  }

  void _onSearchChanged() {
    _filterTransactions(_searchController.text);
  }

  void _loadTransactions() async {
    List<FullTransactionModel> transactions =
        await context.read<TransactionCubit>().getFullTransactions();
    setState(() {
      _filteredTransactions = transactions;
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pesanan Tersimpan', style: AppTextStyle.headline6),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Pesanan',
                hintText: 'Masukkan kata kunci',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = _filteredTransactions[index];
                  return ListTile(
                    title:
                        Text(transaction.savedNotes, style: AppTextStyle.body2),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
         
                        '${transaction.transactions.length} Item • ${DateFormat('HH:mm').format(transaction.time)}',
                      ),
                    ),
                    trailing: Text(
                        'Rp ${transaction.transactions.fold(0, (total, t) => total + t.product.totalPrice!)}'),
                    onTap: () {
                      _showTransactionDetailDialog(context, transaction);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void _showTransactionDetailDialog(BuildContext context, FullTransactionModel fullTransaction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Detail Pesanan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Keterangan"),
                          Text("Total Pembayaran"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(fullTransaction.savedNotes),
                          Text("Rp ${fullTransaction.transactions.fold(0, (total, t) => total + t.product.totalPrice!)}"),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text("Rincian Pesanan"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: fullTransaction.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = fullTransaction.transactions[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${transaction.quantity} ${transaction.product.name}"),
                              Text("Rp ${transaction.product.price * transaction.quantity}"),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      // // Close the SavedTransactionsDialog if open
                      // Navigator.of(context, rootNavigator: true).pop();

               
                      // await context.read<TransactionCubit>().loadFullTransactions();
                      // context.read<BadgeCubit>().updateBadgeCount(context.read<TransactionCubit>().state.transactions.length);
                    },
                    child: Text("Cetak Struk"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context, rootNavigator: true).pop();

                      await context.read<TransactionCubit>().removeFullTransaction(fullTransaction);
                      context.read<BadgeCubit>().updateBadgeCount();
                    },
                    child: Text("Lanjutkan Transaksi"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}