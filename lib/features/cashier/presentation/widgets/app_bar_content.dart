import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/close_cashier/close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/app_bar_right.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/close_cashier_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/expenditure_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/open_cashier_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/printer_management_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/member/member_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/saved_transactions_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/voucher_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../common/util.dart';

class AppBarContent extends StatefulWidget {
  const AppBarContent({super.key});

  @override
  State<AppBarContent> createState() => _AppBarContentState();
}

class _AppBarContentState extends State<AppBarContent> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final AuthSharedPref _authSharedPref = GetIt.instance<AuthSharedPref>();

  bool isPerformSearch = false;

  @override
  Widget build(BuildContext context) {
    final customerName =
        context.select((TransactionCubit cubit) => cubit.state.customerName);
    final customerPhone = context.select(
        (TransactionCubit cubit) => cubit.state.customerPhone); // Add this line

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appBarLeft(_controller, context, _focusNode),
          isLandscape(context) ? Expanded(
            flex: 3,
            child: AppBarRight(buildContext: context, customerName: customerName,
                customerPhone: customerPhone),
          ) : Container(), // Pass the phone number to the method
        ],
      ),
    );
  }

  Expanded appBarLeft(TextEditingController controller, BuildContext context,
      FocusNode focusNode) {
    return Expanded(
      flex: 5,
      child: Container(
        color: AppColors.backgroundGrey,
        margin: const EdgeInsets.only(top: 20, left: 8),
        padding: EdgeInsets.only(right: 8),
        child: Row(
          children: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/ic_burger_menu.svg",
                    height: 6.w,
                    width: 6.h,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            const SizedBox(width: 10),
            // Wrap GestureDetector with BlocBuilder
            BlocBuilder<CashierCubit, CashierState>(
              builder: (context, cashierState) {
                return BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, transactionState) {
                    // Menentukan apakah tombol aktif atau tidak
                    bool isKasirActive =
                        cashierState.cashRegisterStatus != "close";
                    bool hasTransactions =
                        transactionState.transactions.isNotEmpty;

                    // Jika kasir tutup atau ada transaksi, tombol menjadi tidak aktif
                    bool isButtonEnabled = isKasirActive && !hasTransactions;

                    return GestureDetector(
                      onTap: () {
                        if (!isButtonEnabled) {
                          if (hasTransactions) {
                            _showWarningDialog(
                                context, transactionState.transactions.length);
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return isKasirActive
                                  ? CloseCashierDialog()
                                  : OpenCashierDialog();
                            },
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _shortenText(
                              _authSharedPref.getEmployeeName() ?? "",
                              13,
                            ),
                            style: AppTextStyle.headline6,
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: isButtonEnabled
                                  ? AppColors.successMain
                                  : Colors
                                      .grey, // Ubah warna berdasarkan kondisi
                            ),
                            child: Text(
                              isKasirActive ? 'Kasir Aktif >' : 'Kasir Tutup >',
                              style: AppTextStyle.body3
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 10),
            if(!isLandscape(context) && !isPerformSearch) Expanded(child: Container()),
            if((!isPerformSearch && !isLandscape(context)) || isLandscape(context)) GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PrinterManagementDialog();
                  },
                );
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // White background color
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: SvgPicture.asset(
                  "assets/icons/ic_print.svg",
                  height: 2.h,
                ),
              ),
            ),
            if((!isPerformSearch && !isLandscape(context)) || isLandscape(context)) const SizedBox(width: 10),
            if((!isPerformSearch && !isLandscape(context)) || isLandscape(context)) GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ExpenditureDialog();
                  },
                );
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // White background color
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: SvgPicture.asset(
                  "assets/icons/ic_expenditures.svg",
                  height: 2.h,
                ),
              ),
            ),
            if((!isPerformSearch && !isLandscape(context)) || isLandscape(context)) const SizedBox(width: 10),
            if(isPerformSearch || isLandscape(context)) Expanded(
              child: SizedBox(
                child: Center(
                  child: FocusScope(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        // Do something when TextField loses focus if needed
                      }
                    },
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onTapOutside: (pde){
                        _focusNode.unfocus();
                        setState(() {
                          isPerformSearch = false;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8.0),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: () {
                            _performSearch(context, controller.text);
                          },
                        ),
                      ),
                      onSubmitted: (text) {
                        _performSearch(context, text);
                      },
                    ),
                  ),
                ),
              ),
            ),
            if(!isLandscape(context) && !isPerformSearch) Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white, // White background color
                borderRadius: BorderRadius.circular(4.0), // Border radius of 4
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPerformSearch = true;
                    });
                    _focusNode.requestFocus();
                  },
                  child: Icon(Icons.search, color: AppColors.textGrey800, size: 20,),
                ),
              ),
            ),
            if((!isPerformSearch && !isLandscape(context)) || isLandscape(context)) const SizedBox(width: 10),
            if((!isPerformSearch && !isLandscape(context)) || isLandscape(context)) Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white, // White background color
                borderRadius: BorderRadius.circular(4.0), // Border radius of 4
              ),
              child: Center(
                child: BlocBuilder<BadgeCubit, int>(
                  builder: (context, badgeCount) {
                    context.read<BadgeCubit>().updateBadgeCount();
                    return badges.Badge(
                      badgeContent: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10), // Smaller text size
                      ),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor:
                            Colors.red, // Default badge color, adjust if needed
                        padding: EdgeInsets.all(4.0), // Smaller badge size
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SavedTransactionsDialog();
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          "assets/icons/ic_save1.svg",
                          height: 2.h,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if(isLandscape(context) == false) const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  void _showWarningDialog(BuildContext context, int badgeCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Kamu Masih ada $badgeCount Pesanan Yang Belum Diselesaikan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  "Selesaikan Semua Pesanan Tersimpan Terlebih Dahulu!",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Tutup Pesan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMain,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performSearch(BuildContext context, String text) {
    BlocProvider.of<CashierCubit>(context).updateSearchText(text);
    setState(() {
      isPerformSearch = false;
    });
    _focusNode.unfocus();
  }
}

String _shortenText(String text, int maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) + '...';
  } else {
    return text;
  }
}
