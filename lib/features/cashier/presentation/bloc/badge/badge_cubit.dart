import 'package:akib_pos/features/cashier/data/datasources/transaction_service.dart';
import 'package:akib_pos/features/cashier/data/models/save_transaction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BadgeCubit extends Cubit<int> {
  final TransactionService _transactionService;

  BadgeCubit(this._transactionService) : super(0);

  void updateBadgeCount() async {
    List<SaveTransactionModel> transactions = await _transactionService.getFullTransactions();
    emit(transactions.length);
  }

}