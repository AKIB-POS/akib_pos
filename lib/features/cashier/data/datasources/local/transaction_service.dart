import 'dart:convert';

import 'package:akib_pos/features/cashier/data/models/save_transaction_model.dart';
import 'package:akib_pos/features/cashier/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class TransactionService {
  final SharedPreferences sharedPreferences;
  static const String _transactionKey = 'Save_transactions';

  TransactionService({required this.sharedPreferences});

  Future<void> saveFullTransaction(SaveTransactionModel fullTransaction) async {
    List<SaveTransactionModel> existingFullTransactions = await getFullTransactions();
    List<SaveTransactionModel> allFullTransactions = [fullTransaction] + existingFullTransactions;

    List<String> fullTransactionStrings = allFullTransactions.map((t) => json.encode(t.toJson())).toList();
    await sharedPreferences.setStringList(_transactionKey, fullTransactionStrings);
  }

  Future<List<SaveTransactionModel>> getFullTransactions() async {
    List<String>? fullTransactionStrings = sharedPreferences.getStringList(_transactionKey);
    if (fullTransactionStrings != null) {
      return fullTransactionStrings.map((t) => SaveTransactionModel.fromJson(json.decode(t))).toList();
    }
    return [];
  }
 Future<void> removeFullTransaction(SaveTransactionModel fullTransaction) async {
  List<SaveTransactionModel> fullTransactions = await getFullTransactions();
  
  fullTransactions.removeWhere((t) => t.time.isAtSameMomentAs(fullTransaction.time));
  
  List<String> fullTransactionStrings = fullTransactions.map((t) => json.encode(t.toJson())).toList();
  await sharedPreferences.setStringList(_transactionKey, fullTransactionStrings);
}
}