import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/content_body_cashier/expenditure_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/member/member_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/saved_transactions_dialog.dart';
import 'package:akib_pos/features/cashier/presentation/widgets/transaction/voucher_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:badges/badges.dart' as badges;

class AppBarContent extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
          appBarRight(context, customerName,
              customerPhone), // Pass the phone number to the method
        ],
      ),
    );
  }

  Expanded appBarRight(
      BuildContext context, String? customerName, String? customerPhone) {
    // Add customerPhone parameter
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return VoucherDialog();
                  },
                );
              },
              child: SvgPicture.asset(
                "assets/icons/ic_disc.svg",
                height: 3.5.h,
                width: 3.5.w,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  customerName ?? 'Nama Pelanggan',
                  style: AppTextStyle.headline5
                      .copyWith(color: AppColors.textGrey800),
                ),
                const SizedBox(height: 0.5),
                Visibility(
                  visible: customerPhone != null && customerPhone.isNotEmpty,
                  child: Text(
                    customerPhone ?? '',
                    style: AppTextStyle.body3
                        .copyWith(color: AppColors.textGrey500),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                _showMemberDialog(
                    context); // Panggil fungsi untuk menampilkan MemberDialog
              },
              child: SvgPicture.asset(
                "assets/icons/ic_note.svg",
                height: 3.5.h,
                width: 3.5.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MemberDialog();
      },
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Syafii Qurani', style: AppTextStyle.headline6),
                SizedBox(
                  height: 4,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.successMain),
                    child: Text('Kasir Aktif >',
                        style:
                            AppTextStyle.body3.copyWith(color: Colors.white))),
              ],
            ),
            const SizedBox(width: 10),
            GestureDetector(
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
            const SizedBox(width: 10),
            Expanded(
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
            const SizedBox(width: 10),
            Container(
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
          ],
        ),
      ),
    );
  }

  void _performSearch(BuildContext context, String text) {
    BlocProvider.of<CashierCubit>(context).updateSearchText(text);
    _focusNode.unfocus();
  }
}
