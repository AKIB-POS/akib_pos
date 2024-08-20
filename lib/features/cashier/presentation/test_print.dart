import 'package:akib_pos/features/cashier/data/models/save_transaction_model.dart';
import 'package:akib_pos/util/printerenum.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';

class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  void printTransaction(SaveTransactionModel transaction) async {
    // Ensure the printer is connected
    bool? isConnected = await bluetooth.isConnected;
    if (!isConnected!) return;

    // Calculate values
    double subtotal = _calculateSubtotal(transaction);
    double tax = _calculateTax(transaction);
    double discount = _calculateDiscount(transaction);
    double total = _calculateTotal(transaction);

    // Start printing
    bluetooth.printNewLine();
    bluetooth.printCustom("Caffee Arrazzaq", Size.boldLarge.val, Align.center.val);
    bluetooth.printCustom("Jalan Toddopuli 10 No. 15", Size.medium.val, Align.center.val);
    bluetooth.printCustom("Instagram: @caffeearrazaq", Size.medium.val, Align.center.val);
    bluetooth.printNewLine();
    bluetooth.printCustom("------Belum Lunas------", Size.bold.val, Align.center.val);
    bluetooth.printNewLine();
    bluetooth.printLeftRight("Tanggal Transaksi:", 
                             DateFormat('dd-MM-yyyy').format(transaction.time), 
                             Size.medium.val);
    bluetooth.printNewLine();

    for (var item in transaction.transactions) {
      bluetooth.printLeftRight(
        "${item.quantity}x ${item.product.name}",
        "Rp. ${item.product.price}",
        Size.medium.val,
      );

      if (item.selectedVariants.isNotEmpty) {
        bluetooth.printCustom("Varian", Size.medium.val, Align.left.val);
        for (var variant in item.selectedVariants) {
          bluetooth.printLeftRight(
            "    ${variant.subVariantType}: ${variant.name}",
            "+Rp. ${variant.price}",
            Size.medium.val,
          );
        }
      }

      if (item.selectedAdditions.isNotEmpty) {
        bluetooth.printCustom("Tambahan", Size.medium.val, Align.left.val);
        for (var addition in item.selectedAdditions) {
          bluetooth.printLeftRight(
            "    ${addition.name}",
            "+Rp. ${addition.price}",
            Size.medium.val,
          );
        }
      }

      if (item.notes.isNotEmpty) {
        bluetooth.printCustom("  Catatan: ${item.notes}", Size.medium.val, Align.left.val);
      }

      bluetooth.printNewLine();
    }

    bluetooth.printNewLine();
    bluetooth.printLeftRight("Sub Total:", "Rp. $subtotal", Size.medium.val);
    bluetooth.printLeftRight("Pajak:", "Rp. $tax", Size.medium.val);
    bluetooth.printLeftRight("Diskon:", "Rp. $discount", Size.medium.val);
    bluetooth.printNewLine();
    bluetooth.printLeftRight("Total:", "Rp. $total", Size.bold.val);
    bluetooth.printNewLine();

    bluetooth.printCustom("----------------------------", Size.medium.val, Align.center.val);
    bluetooth.printCustom("Terima Kasih :)", Size.bold.val, Align.center.val);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }

  double _calculateSubtotal(SaveTransactionModel transaction) {
    return transaction.transactions.fold(
      0.0,
      (total, item) => total + item.product.totalPrice!,
    );
  }

  double _calculateTax(SaveTransactionModel transaction) {
    final subtotal = _calculateSubtotal(transaction);
    return subtotal * (transaction.tax / 100);
  }

  double _calculateDiscount(SaveTransactionModel transaction) {
    return transaction.discount ?? 0.0;
  }

  double _calculateTotal(SaveTransactionModel transaction) {
    final subtotal = _calculateSubtotal(transaction);
    final tax = _calculateTax(transaction);
    final discount = _calculateDiscount(transaction);
    return subtotal + tax - discount;
  }
}