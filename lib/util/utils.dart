
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
class Utils{

  static String formatCurrencyDouble(double input) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(input);
  }
  static String formatCurrency(String input) {
  int value = int.parse(input);
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(value);
}

static  buildLoadingCardShimmer() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 40,
              color: Colors.grey[300],
              margin: const EdgeInsets.all(16),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            ),
          ],
        ),
      ),
    );
  }


  static String formatNumber(String input) {
  int value = int.parse(input);
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: '', // Menghilangkan simbol "Rp"
    decimalDigits: 0,
  );
  return formatter.format(value).trim(); // Menggunakan trim() untuk menghilangkan spasi ekstra
}

// Method untuk format angka dari double tanpa simbol "Rp"
static String formatNumberDouble(double input) {
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id',
    symbol: '', // Menghilangkan simbol "Rp"
    decimalDigits: 0,
  );
  return formatter.format(input).trim(); // Menggunakan trim() untuk menghilangkan spasi ekstra
}

static void showCustomInfoDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title, // Menggunakan judul dari parameter
                    style: AppTextStyle.headline5, // Gaya teks untuk judul
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Menutup dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // SvgPicture.asset(
              //   'assets/icons/accounting/ic_info.svg',
              //   height: 80,
              //   width: 80,
              // ), // Gambar SVG di dalam dialog
              // const SizedBox(height: 16),
              Container(
                width: double.infinity, // Membuat lebar container maksimal
                child: Text(
                  content,
                  style: AppTextStyle.bigCaptionBold.copyWith(fontWeight: FontWeight.normal), // Gaya teks untuk konten
                  textAlign: TextAlign.justify, // Meratakan teks kanan-kiri
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}



}



