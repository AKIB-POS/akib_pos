import 'package:akib_pos/features/cashier/data/datasources/local/cashier_shared_pref.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/left_body.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/open_cashier_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/right_body.dart';
import 'package:flutter/material.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/home/widget/my_drawer.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/app_bar_content.dart';
import 'package:get_it/get_it.dart';


class CashierPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Periksa status kasir
    _checkCashierStatus(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundGrey,
      drawer: MyDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        elevation: 0,
        flexibleSpace: AppBarContent(),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: LeftBody(),
          ),
          Expanded(
            flex: 3,
            child: RightBody(),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memeriksa status kasir
  void _checkCashierStatus(BuildContext context) async {
    final cashierSharedPref = GetIt.instance<CashierSharedPref>();
    final isOpen = await cashierSharedPref.isCashierOpen();

    if (!isOpen) {
      // Jika kasir belum dibuka, tampilkan dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OpenCashierDialog();
          },
          barrierDismissible: false, // This will make the dialog non-dismissible
        );
      });
    }
  }
}