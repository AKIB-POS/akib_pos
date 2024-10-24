import 'dart:io';

import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/models/full_transaction_model.dart';
import 'package:akib_pos/util/printerenum.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as Imagelib;
import 'package:shared_preferences/shared_preferences.dart';

class FinishedTransactionPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
    final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  Future<void> printTransaction({
    required FullTransactionModel transaction,
    required String receivedAmount,
    required String cashback,
  }) async {
    // Load assets (e.g., logo)
    ByteData bytesAsset = await rootBundle.load("assets/images/akib.png");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    // Get saved connection type (Bluetooth or WiFi) from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? connectionType = prefs.getString('saved_connection_type');

    // Determine connection type
    if (connectionType == 'bluetooth') {
      // Ensure Bluetooth printer is connected
      bool? isConnected = await bluetooth.isConnected;
      if (!isConnected!) {
        print("Bluetooth printer is not connected.");
        return;
      }
      // Proceed with Bluetooth printing
      _printBluetooth(
          transaction, receivedAmount, cashback, imageBytesFromAsset);
    } else if (connectionType == 'wifi') {
      // Get WiFi printer IP from SharedPreferences
      String? wifiPrinterIp = prefs.getString('saved_printer_ip');
      if (wifiPrinterIp == null) {
        print("No WiFi printer IP saved.");
        return;
      }
      // Proceed with WiFi printing
      _printWiFi(transaction, receivedAmount, cashback, wifiPrinterIp,
          imageBytesFromAsset);
    } else {
      print("No connection type saved in preferences.");
    }
  }

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

  void _printBluetooth(FullTransactionModel transaction, String receivedAmount,
      String cashback, Uint8List imageBytes) {

         double subtotal = _calculateSubtotal(transaction);
    double discount = _calculateDiscount(transaction);
    double total = _calculateTotal(transaction);
    // Bluetooth printing logic
    bluetooth.printNewLine();
    bluetooth.printCustom(
        "${_authSharedPref.getCompanyName()}", Size.boldLarge.val, Align.center.val);
    bluetooth.printCustom(
        "Jalan Toddopuli 10 No. 15", Size.medium.val, Align.center.val);
    bluetooth.printNewLine();
    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printCustom("Lunas", Size.bold.val, Align.center.val);
    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printNewLine();

    // Iterate through items and print them (same as before)
    for (var item in transaction.transactions) {
      bluetooth.printLeftRight("${item.quantity}x ${item.product.name}",
          Utils.formatNumber(item.product.price.toString()), Size.bold.val);
    

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

        if (item.product.totalDiscount != null) {
        bluetooth.printLeftRight(
            "Diskon",
            "-${Utils.formatCurrencyDouble(item.product.totalPriceDisc!)}",
            Size.bold.val);
    
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


    bluetooth.printNewLine();
    bluetooth.printLeftRight(
        "Sub Total:", Utils.formatCurrencyDouble(subtotal), Size.bold.val);
    bluetooth.printLeftRight("Diskon Produk:", "-${Utils.formatCurrencyDouble(_calculateProductDiscount(transaction))}", Size.bold.val);
    bluetooth.printLeftRight(
        "Diskon:", "-${Utils.formatCurrencyDouble(discount)}", Size.bold.val);
       bluetooth.printLeftRight(
        "Pajak:", "+${Utils.formatCurrencyDouble(transaction.tax)}", Size.bold.val);
    bluetooth.printLeftRight(
        "Total:", Utils.formatCurrencyDouble(total), Size.bold.val);
    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printLeftRight("Pembayaran:", transaction.paymentMethod!, Size.bold.val);
    bluetooth.printLeftRight("Diterima:", receivedAmount, Size.bold.val);
    bluetooth.printLeftRight("Kembalian:", cashback, Size.bold.val);
    bluetooth.printNewLine();

    bluetooth.printCustom("--------------------------------", 1, 1);
    bluetooth.printCustom("Terima Kasih :)", Size.bold.val, Align.center.val);
    bluetooth.printCustom(
        "Powered By AK Solutions", Size.bold.val, Align.center.val);
    bluetooth.printImageBytes(imageBytes);
    bluetooth.printNewLine();
    bluetooth.paperCut();
  }

  Future<void> _printWiFi(
      FullTransactionModel transaction,
      String receivedAmount,
      String cashback,
      String wifiPrinterIp,
      Uint8List imageBytes) async {
    // Create a connection to the WiFi printer using its IP address
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Convert Uint8List to Image using Imagelib
    Imagelib.Image? image = Imagelib.decodeImage(imageBytes);
    if (image == null) {
      print("Failed to load image for printing.");
      return;
    }

    // Generate ESC/POS formatted receipt
    final List<int> bytes = [];

    bytes.addAll(generator.text(
      "Caffee Arrazzaq",
      styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
    ));
    bytes.addAll(generator.text("Jalan Toddopuli 10 No. 15",
        styles: PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.hr()); // Horizontal line
    bytes.addAll(generator.text("Lunas",
        styles: PosStyles(align: PosAlign.center, bold: true)));
    bytes.addAll(generator.hr());

    // Iterate through transaction items
    for (var item in transaction.transactions) {
      bytes.addAll(generator.text(
        "${item.quantity}x ${item.product.name}   ${Utils.formatCurrency(item.product.price.toString())}",
      ));
    }

    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
        "Total: ${Utils.formatCurrencyDouble(_calculateTotal(transaction))}"));
    bytes.addAll(generator.text("Pembayaran: ${transaction.paymentMethod!}"));
    bytes.addAll(generator.text("Diterima: $receivedAmount"));
    bytes.addAll(generator.text("Kembalian: $cashback"));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text("Terima Kasih :)",
        styles: PosStyles(align: PosAlign.center, bold: true)));

    // Add the image (using the processed image from Imagelib)
    bytes.addAll(generator.image(image));

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    // Send data via TCP socket to the WiFi printer
    await _sendToPrinter(wifiPrinterIp, bytes);
  }

  Future<void> _sendToPrinter(String ip, List<int> bytes) async {
    try {
      final socket = await Socket.connect(ip, 9100);
      socket.add(Uint8List.fromList(bytes));
      await socket.flush();
      socket.destroy();
    } catch (e) {
      print("Failed to connect to WiFi printer: $e");
    }
  }

  // Helper methods to calculate totals, etc.
  double _calculateTotal(FullTransactionModel state) {
    final subtotal = _calculateSubtotal(state);
    final discount = _calculateDiscount(state);
    final discountProduct = _calculateProductDiscount(state);
    final totalAfterDiscount = subtotal - discount - discountProduct;
    return totalAfterDiscount + state.tax;
  }

  double _calculateSubtotal(FullTransactionModel state) {
    return state.transactions.fold(
        0, (total, transaction) => total + transaction.product.totalPrice!);
  }
   double _calculateProductDiscount(FullTransactionModel state) {
    return state.transactions.fold(
        0, (total, transaction) => total + transaction.product.totalPriceDisc!);
  }


  double _calculateDiscount(FullTransactionModel state) {
    double discount = state.discount;
    if (state.voucher != null) {
      if (state.voucher!.type == 'nominal') {
        discount += state.voucher!.amount;
      } else if (state.voucher!.type == 'percentage') {
        discount += (_calculateSubtotal(state) * state.voucher!.amount / 100);
      }
    }
    return discount;
  }
}
