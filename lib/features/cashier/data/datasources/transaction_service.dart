import 'dart:convert';

import 'package:akib_pos/features/cashier/data/models/full_transaction_models.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class TransactionService {
  final SharedPreferences sharedPreferences;
  static const String _transactionKey = 'transactions';

  TransactionService({required this.sharedPreferences});

  Future<void> saveFullTransaction(FullTransactionModel fullTransaction) async {
    List<FullTransactionModel> existingFullTransactions = await getFullTransactions();
    List<FullTransactionModel> allFullTransactions = [fullTransaction] + existingFullTransactions;

    List<String> fullTransactionStrings = allFullTransactions.map((t) => json.encode(t.toJson())).toList();
    await sharedPreferences.setStringList(_transactionKey, fullTransactionStrings);
  }

  Future<List<FullTransactionModel>> getFullTransactions() async {
    List<String>? fullTransactionStrings = sharedPreferences.getStringList(_transactionKey);
    if (fullTransactionStrings != null) {
      return fullTransactionStrings.map((t) => FullTransactionModel.fromJson(json.decode(t))).toList();
    }
    return [];
  }
 Future<void> removeFullTransaction(FullTransactionModel fullTransaction) async {
  List<FullTransactionModel> fullTransactions = await getFullTransactions();
  
  fullTransactions.removeWhere((t) => t.time.isAtSameMomentAs(fullTransaction.time));
  
  List<String> fullTransactionStrings = fullTransactions.map((t) => json.encode(t.toJson())).toList();
  await sharedPreferences.setStringList(_transactionKey, fullTransactionStrings);
}
}