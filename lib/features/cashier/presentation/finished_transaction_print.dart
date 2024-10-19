import 'dart:typed_data';

import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/util/printerenum.dart';
import 'package:akib_pos/util/utils.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FinishedTransactionPrint {
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  void printTransaction(FullTransactionModel transaction, String receivedAmount,
      String cashback) async {
    // ByteData bytesAsset = await rootBundle.load("assets/images/akib.png");
    // Uint8List imageBytesFromAsset = bytesAsset.buffer
    //     .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    // var response = await http.get(Uri.parse(
    //     "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
    // Uint8List bytesNetwork = response.bodyBytes;
    // Uint8List imageBytesFromNetwork = bytesNetwork.buffer
    //     .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);
    // // Ensure the printer is connected
    // bool? isConnected = await bluetooth.isConnected;
    // if (!isConnected!) return;

    // List<String> formatText(String text, int limit) {
    //   List<String> lines = [];
    //   List<String> words = text.split(' ');
    //   String currentLine = '';

    //   for (var word in words) {
    //     if ((currentLine + word).length > limit) {
    //       lines.add(currentLine.trim());
    //       currentLine = word + ' ';
    //     } else {
    //       currentLine += word + ' ';
    //     }
    //   }

    //   if (currentLine.isNotEmpty) {
    //     lines.add(currentLine.trim());
    //   }

    //   return lines;
    // }

    // // Calculate values
    // double subtotal = _calculateSubtotal(transaction);
    // double discount = _calculateDiscount(transaction);
    // double total = _calculateTotal(transaction);

    // // Start printing
    // bluetooth.printNewLine();

    // bluetooth.printCustom(
    //     "Caffee Arrazzaq", Size.boldLarge.val, Align.center.val);
    // bluetooth.printCustom(
    //     "Jalan Toddopuli 10 No. 15", Size.medium.val, Align.center.val);
    // bluetooth.printCustom(
    //     "Instagram: @caffeearrazaq", Size.medium.val, Align.center.val);
    // bluetooth.printNewLine();
    // bluetooth.printCustom("--------------------------------", 1, 1);
    // bluetooth.printCustom("Lunas", Size.bold.val, Align.center.val);
    // bluetooth.printCustom("--------------------------------", 1, 1);
    // bluetooth.printNewLine();
    // bluetooth.printLeftRight(
    //   "Nama : ",
    //   transaction.customerName != null ? transaction.customerName! : "Tamu",
    //   Size.bold.val,
    // );
    // bluetooth.printLeftRight(
    //   transaction.orderType == 'take_away' ? "Take Away" : "Dine In",
    //   "${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
    //   Size.bold.val,
    // );
    // bluetooth.printNewLine();
    // bluetooth.printCustom("--------------------------------", 1, 1);

    // for (var item in transaction.transactions) {
    //   List<String> productNameLines = formatText(item.product.name, 12);

    //   // Print each line of the product name
    //   for (int i = 0; i < productNameLines.length; i++) {
    //     if (i == 0) {
    //       bluetooth.printLeftRight("${item.quantity}x ${productNameLines[i]}",
    //           Utils.formatNumber(item.product.price.toString()), Size.bold.val);
    //     } else {
    //       bluetooth.printCustom(
    //           "   ${productNameLines[i]}", Size.bold.val, Align.left.val);
    //     }
    //   }

    //   if (item.selectedVariants.isNotEmpty) {
    //     for (var variant in item.selectedVariants) {
    //       List<String> variantNameLines = formatText("${variant.name}", 13);

    //       for (int i = 0; i < variantNameLines.length; i++) {
    //         if (i == 0) {
    //           bluetooth.printLeftRight("   ${variantNameLines[i]}",
    //               Utils.formatNumber(variant.price.toString()), Size.bold.val);
    //         } else {
    //           // Print in a smaller size and align with the previous line
    //           bluetooth.printCustom(
    //               "  +${variantNameLines[i]}", Size.bold.val, Align.left.val);
    //         }
    //       }
    //     }
    //   }

    //   if (item.selectedAdditions.isNotEmpty) {
    //     for (var addition in item.selectedAdditions) {
    //       List<String> additionNameLines = formatText(addition.name, 13);

    //       for (int i = 0; i < additionNameLines.length; i++) {
    //         if (i == 0) {
    //           bluetooth.printLeftRight(
    //             "  +${additionNameLines[i]}",
    //             Utils.formatNumber(addition.price.toString()),
    //             Size.bold.val,
    //           );
    //         } else {
    //           bluetooth.printCustom(
    //               "   ${additionNameLines[i]}", Size.bold.val, Align.left.val);
    //         }
    //       }
    //     }
    //   }

    //   if (item.notes.isNotEmpty) {
    //     List<String> notesLines = formatText(item.notes, 15);

    //     for (int i = 0; i < notesLines.length; i++) {
    //       if (i == 0) {
    //         bluetooth.printCustom("    Catatan: ${notesLines[i]}",
    //             Size.medium.val, Align.left.val);
    //       } else {
    //         bluetooth.printCustom(
    //             "   ${notesLines[i]}", Size.medium.val, Align.left.val);
    //       }
    //     }
    //   }

    //   bluetooth.printNewLine();
    // }
    // bluetooth.printCustom("--------------------------------", 1, 1);
    // bluetooth.printNewLine();
    // bluetooth.printLeftRight(
    //     "Sub Total:", Utils.formatCurrencyDouble(subtotal), Size.bold.val);
    // bluetooth.printLeftRight(
    //     "Pajak:", Utils.formatCurrencyDouble(transaction.tax), Size.bold.val);
    // bluetooth.printLeftRight(
    //     "Diskon:", "-${Utils.formatCurrencyDouble(discount)}", Size.bold.val);
    // bluetooth.printLeftRight(
    //     "Total:", Utils.formatCurrencyDouble(total), Size.bold.val);
    // bluetooth.printCustom("--------------------------------", 1, 1);
    // bluetooth.printLeftRight("Pembayaran:", transaction.paymentMethod!, Size.bold.val);
    // bluetooth.printLeftRight("Diterima:", receivedAmount, Size.bold.val);
    // bluetooth.printLeftRight("Kembalian:", cashback, Size.bold.val);
    // bluetooth.printNewLine();

    // bluetooth.printCustom("--------------------------------", 1, 1);
    // bluetooth.printCustom("Terima Kasih :)", Size.bold.val, Align.center.val);
    // bluetooth.printCustom(
    //     "Powered By AK Solutions", Size.bold.val, Align.center.val);
    // bluetooth.printImageBytes(imageBytesFromAsset);
    // bluetooth.printNewLine();
    // bluetooth.paperCut();
  }

  double _calculateSubtotal(FullTransactionModel state) {
    return state.transactions.fold(
        0, (total, transaction) => total + transaction.product.totalPrice!);
  }

  double _calculateDiscount(FullTransactionModel state) {
    final subtotal = _calculateSubtotal(state);
    double discountAmount = state.discount;
    if (state.voucher != null) {
      if (state.voucher!.type == 'nominal') {
        discountAmount += state.voucher!.amount;
      } else if (state.voucher!.type == 'percentage') {
        discountAmount += (subtotal * state.voucher!.amount / 100);
      }
    }
    return discountAmount;
  }

  double _calculateTotal(FullTransactionModel state) {
    final subtotal = _calculateSubtotal(state);
    final discount = _calculateDiscount(state);
    final totalAfterDiscount = subtotal - discount;
    final tax = state.tax;
    return (totalAfterDiscount + tax);
  }

}
