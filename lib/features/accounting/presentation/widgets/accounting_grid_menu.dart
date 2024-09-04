import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/accounting/presentation/pages/sales_report.dart';
import 'package:akib_pos/features/accounting/presentation/pages/transaction_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class AccountingGridMenu extends StatelessWidget {
  final List<Map<String, String>> menuItems = [
    {"title": "Laporan\nTransaksi", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
    {"title": "Laporan\nPenjualan", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
    {"title": "Laporan\nPembelian", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
    {"title": "Laba\nRugi", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
    {"title": "Neraca\nKeuangan", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
    {"title": "Arus\nKas", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
    {"title": "Manajemen\nNilai Pajak", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
    {"title": "Manajemen\nAset", "icon": "assets/icons/accounting/ic_arus_kas.svg"},
  ];

  void onItemTap(int index, BuildContext context) {
  switch (index) {
    case 0:
      // If the first item is clicked
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionReport(),
        ),
      );
      break;
    case 1:
      // If the second item is clicked (you can replace this with your desired action)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SalesReport(), // Replace with your page
        ),
      );
      break;
    // Add more cases as needed
    default:
      // Handle any other cases or do nothing
      break;
  }
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true, // Tambahkan ini agar GridView mengukur tinggi berdasarkan isinya
      physics: const NeverScrollableScrollPhysics(), 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.26,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onItemTap(index, context);
          },
          child: AccountingMenuItem(
            title: menuItems[index]["title"]!,
            iconPath: menuItems[index]["icon"]!,
          ),
        );
      },
    );
  }
}

class AccountingMenuItem extends StatelessWidget {
  final String title;
  final String iconPath;

  AccountingMenuItem({required this.title, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0), // Terapkan radius yang sama
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/images/bg_card_accounting.svg", // Background SVG
                fit: BoxFit.scaleDown,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ), // Sesuaikan ukuran teks dengan Sizer atau AppTextStyle jika ada
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      SvgPicture.asset(
                        iconPath,
                        height: 40, // Sesuaikan ukuran ikon
                        width: 40,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Assuming you have a list or some identifier to handle the different cases


}