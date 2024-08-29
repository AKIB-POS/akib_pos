import 'dart:typed_data';

import 'package:akib_pos/features/cashier/data/models/save_transaction_model.dart';
import 'package:akib_pos/util/printerenum.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SavedTransactionPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  void printTransaction(SaveTransactionModel transaction) async {
    ByteData bytesAsset = await rootBundle.load("assets/images/akib.png");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    var response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
    Uint8List bytesNetwork = response.bodyBytes;
    Uint8List imageBytesFromNetwork = bytesNetwork.buffer
        .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);

    // Ensure the printer is connected
    bool? isConnected = await bluetooth.isConnected;
    if (!isConnected!) return;

    List<String> formatText(String text, int limit) {
      List<String> lines = [];
      List<String> words = text.split(' ');
      String currentLine = '';

      for (var word in words) {
        if ((currentLine + word).length > limit) {
          lines.add(currentLine.trim());
          currentLine = word + ' ';
        } else {
          currentLine += word + ' ';
        }
      }

      if (currentLine.isNotEmpty) {
        lines.add(currentLine.trim());
      }

      return lines;
    }

    // Calculate values
    double subtotal = _calculateSubtotal(transaction);
    double tax = _calculateTax(transaction);
    double discount = _calculateDiscount(transaction);
    double total = _calculateTotal(transaction);

    // Start printing
    bluetooth.printNewLine();
    bluetooth.printCustom(
        "Caffee Arrazzaq", Size.boldLarge.val, Align.center.val);
    bluetooth.printCustom(
        "Jalan Toddopuli 10 No. 15", Size.medium.val, Align.center.val);
    bluetooth.printCustom(
        "Instagram: @caffeearrazaq", Size.medium.val, Align.center.val);
    bluetooth.printNewLine();
    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printCustom("Belum Lunas", Size.bold.val, Align.center.val);
    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printLeftRight(
      "Note : ",
      transaction.savedNotes != null ? transaction.savedNotes! : "-",
      Size.bold.val,
    );
    bluetooth.printLeftRight(
      transaction.orderType == 'take_away' ? "Take Away" : "Dine In",
      "${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
      Size.bold.val,
    );
    bluetooth.printNewLine();
    bluetooth.printCustom("--------------------------------", 1, 1);

    for (var item in transaction.transactions) {
      List<String> productNameLines = formatText(item.product.name, 12);

      // Print each line of the product name
      for (int i = 0; i < productNameLines.length; i++) {
        if (i == 0) {
          bluetooth.printLeftRight(
              "${item.quantity}x ${productNameLines[i]}",
              Utils.formatNumber(item.product.price.toString()),
              Size.bold.val);
        } else {
          bluetooth.printCustom(
              "   ${productNameLines[i]}", Size.bold.val, Align.left.val);
        }
      }

      if (item.selectedVariants.isNotEmpty) {
        for (var variant in item.selectedVariants) {
          List<String> variantNameLines = formatText("${variant.name}", 13);

          for (int i = 0; i < variantNameLines.length; i++) {
            if (i == 0) {
              bluetooth.printLeftRight(
                  "  +${variantNameLines[i]}",
                  Utils.formatNumber(variant.price.toString()),
                  Size.bold.val);
            } else {
              // Print in a smaller size and align with the previous line
              bluetooth.printCustom(
                  "  ${variantNameLines[i]}", Size.bold.val, Align.left.val);
            }
          }
        }
      }

      if (item.selectedAdditions.isNotEmpty) {
        for (var addition in item.selectedAdditions) {
          List<String> additionNameLines = formatText(addition.name, 13);

          for (int i = 0; i < additionNameLines.length; i++) {
            if (i == 0) {
              bluetooth.printLeftRight(
                "  +${additionNameLines[i]}",
                Utils.formatNumber(addition.price.toString()),
                Size.bold.val,
              );
            } else {
              bluetooth.printCustom(
                  "   ${additionNameLines[i]}", Size.bold.val, Align.left.val);
            }
          }
        }
      }

      if (item.notes.isNotEmpty) {
        List<String> notesLines = formatText(item.notes, 15);

        for (int i = 0; i < notesLines.length; i++) {
          if (i == 0) {
            bluetooth.printCustom("    Catatan: ${notesLines[i]}",
                Size.medium.val, Align.left.val);
          } else {
            bluetooth.printCustom(
                "   ${notesLines[i]}", Size.medium.val, Align.left.val);
          }
        }
      }

      bluetooth.printNewLine();
    }

    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printLeftRight(
        "Sub Total:", Utils.formatCurrencyDouble(subtotal), Size.bold.val);
    bluetooth.printLeftRight(
        "Pajak:", Utils.formatCurrencyDouble(tax), Size.bold.val);
    bluetooth.printLeftRight(
        "Diskon:", "-${Utils.formatCurrencyDouble(discount)}", Size.bold.val);
    bluetooth.printLeftRight(
        "Total:", Utils.formatCurrencyDouble(total), Size.bold.val);
    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printNewLine();

    bluetooth.printCustom("Terima Kasih :)", Size.bold.val, Align.center.val);
    bluetooth.printCustom(
        "Powered By AK Solutions", Size.bold.val, Align.center.val);
    bluetooth.printImageBytes(imageBytesFromAsset);
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
