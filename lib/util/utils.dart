import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/common/app_themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Utils {
  static const List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  // Fungsi untuk mendapatkan nama bulan dari nomor bulan
  static String getMonthString(int month) {
    if (month < 1 || month > 12) {
      throw Exception('Bulan harus di antara 1 hingga 12.');
    }
    return months[month - 1]; // Karena index dalam array mulai dari 0
  }

  // Fungsi untuk mendapatkan nomor bulan dari nama bulan
  static int getMonthNumber(String month) {
    final index = months.indexOf(month);
    if (index == -1) {
      throw Exception('Bulan tidak ditemukan.');
    }
    return index + 1;
  }

  static Widget buildLoadingCardShimmer() {
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

  static Future<void> showConfirmationDialog(
    BuildContext context, {
    required String buttonText, // Text for the action button
    required String message, // Custom message to be displayed
    required VoidCallback onConfirm, // Action for confirm button
    required VoidCallback onCancel, // Action for cancel button
  }) async {
    final width =
        MediaQuery.of(context).size.width * 0.95; // 95% of screen width

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              EdgeInsets.zero, // Remove default padding around content
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20), // Dialog margin
          content: SingleChildScrollView(
            child: SizedBox(
              width: width, // Set dialog width
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  SvgPicture.asset(
                    'assets/icons/hrd/ic_warning.svg', // Path to your SVG asset
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          message, // Custom message text
                          textAlign: TextAlign.center,
                          style: AppTextStyle.headline5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildActionButtons(
                      context,
                      buttonText,
                      onConfirm,
                      onCancel,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget untuk tombol aksi (Batal dan tombol sesuai parameter)
  static Widget _buildActionButtons(
    BuildContext context,
    String buttonText,
    VoidCallback onConfirm,
    VoidCallback onCancel,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryMain),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: onCancel,
            child: Text(
              'Batal',
              style:
                  AppTextStyle.headline5.copyWith(color: AppColors.primaryMain),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: onConfirm, // Call the confirm callback
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              buttonText, // Dynamic button text (e.g., 'Ya, Tolak')
              style: AppTextStyle.headline5.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> showInputTextVerificationDialog(
    BuildContext context, {
    required String buttonText, // Text for the action button
    required ValueChanged<String>
        onConfirm, // Passes the input value to onConfirm
    required VoidCallback onCancel, // Action for cancel button
  }) async {
    TextEditingController _reasonController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width *
            0.95; // Set dialog width to 95% of screen width
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              EdgeInsets.zero, // Removes default padding around content
          insetPadding: EdgeInsets.symmetric(
              horizontal: 20), // For some margin around dialog
          content: SingleChildScrollView(
            // Tambahkan SingleChildScrollView untuk scroll konten
            child: SizedBox(
              width: width, // Set the dialog width here
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  SvgPicture.asset(
                    'assets/icons/hrd/ic_warning.svg', // Path to your SVG
                    height: 48,
                    width: 48,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text('Alasan Verifikasi',
                            style: AppTextStyle.headline5),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _reasonController,
                          maxLines: 5, // Multiline input
                          decoration: AppThemes.inputDecorationStyle.copyWith(
                            hintText: 'Masukkan alasan', // Custom hint text
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildActionButtonsInput(context, buttonText,
                        onConfirm, onCancel, _reasonController),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget untuk action buttons (Batal dan action sesuai parameter)
  static Widget _buildActionButtonsInput(
    BuildContext context,
    String buttonText,
    ValueChanged<String> onConfirm, // Value passed to onConfirm
    VoidCallback onCancel,
    TextEditingController reasonController, // Controller for input text
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryMain),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: onCancel,
            child: Text(
              'Batal',
              style:
                  AppTextStyle.headline5.copyWith(color: AppColors.primaryMain),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Ambil nilai input dari TextEditingController
              final reason = reasonController.text;
              onConfirm(reason); // Panggil callback dengan nilai input
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMain,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              buttonText, // Text sesuai dengan parameter
              style: AppTextStyle.headline5.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  static FloatingActionButton buildFloatingActionButton({
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(
        "Tambah",
        style: AppTextStyle.body2.copyWith(color: Colors.white),
      ),
      icon: SvgPicture.asset(
        'assets/icons/hrd/ic_add.svg',
        width: 24,
        height: 24,
      ),
      backgroundColor: AppColors.successMain,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // Adjust the radius here
      ),
    );
  }

  // Buat Menu List
  static Widget buildMenuItem(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyle.bigCaptionBold),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }

  static Widget buildErrorState({
    required String title,
    required String message,
    required VoidCallback onRetry, // Parameter untuk menangani tombol retry
  }) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/accounting/empty_report.svg', // Ganti dengan path icon error yang sesuai
              height: 80,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyle.bigCaptionBold,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.caption,
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: onRetry, // Callback saat tombol ditekan
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Atur padding di sini
                backgroundColor:
                    AppColors.primaryMain, // Atur warna latar belakang
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Atur radius sudut
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  static Widget buildErrorStatePlain({
    required String title,
    required String message,
    required VoidCallback onRetry, // Parameter untuk menangani tombol retry
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/accounting/empty_report.svg', // Ganti dengan path icon error yang sesuai
              height: 80,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyle.bigCaptionBold,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.caption,
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: onRetry, // Callback saat tombol ditekan
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Atur padding di sini
                backgroundColor:
                    AppColors.primaryMain, // Atur warna latar belakang
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Atur radius sudut
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildEmptyState(String title, String? message) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/accounting/empty_report.svg',
              height: 80,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyle.bigCaptionBold,
            ),
            const SizedBox(height: 4),
            Text(
              message ?? "",
              textAlign: TextAlign.center,
              style: AppTextStyle.caption,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  static Widget buildEmptyStatePlain(String? title , String? message) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/accounting/empty_report.svg',
              height: 80,
            ),
            const SizedBox(height: 12),
            Text(
              title ?? "Belum Ada Data",
              style: AppTextStyle.bigCaptionBold,
            ),
            const SizedBox(height: 4),
            Text(
              message ?? "",
              textAlign: TextAlign.center,
              style: AppTextStyle.caption,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

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

  static String formatNumber(String input) {
    int value = int.parse(input);
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: '', // Menghilangkan simbol "Rp"
      decimalDigits: 0,
    );
    return formatter
        .format(value)
        .trim(); // Menggunakan trim() untuk menghilangkan spasi ekstra
  }

// Method untuk format angka dari double tanpa simbol "Rp"
  static String formatNumberDouble(double input) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: '', // Menghilangkan simbol "Rp"
      decimalDigits: 0,
    );
    return formatter
        .format(input)
        .trim(); // Menggunakan trim() untuk menghilangkan spasi ekstra
  }

  static void showCustomInfoDialog(
      BuildContext context, String title, String content) {
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
                    style: AppTextStyle.bigCaptionBold.copyWith(
                        fontWeight:
                            FontWeight.normal), // Gaya teks untuk konten
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
